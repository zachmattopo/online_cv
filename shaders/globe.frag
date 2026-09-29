#version 460 core

#include <flutter/runtime_effect.glsl>

precision highp float;

// Orthographic globe rendered as a 1-bit ordered dither.
// Every screen cell is shaded once from its centre, then thresholded
// against a 4x4 Bayer matrix, so the globe only ever uses ink or paper
// (plus the accent for the day/night terminator).

uniform vec2 uSize;     // logical px
uniform float uCell;    // logical px per dither cell
uniform vec2 uCenter;   // globe centre, logical px
uniform float uRadius;  // globe radius, logical px
uniform vec2 uView;     // lon0, lat0 of the view centre, radians
uniform vec3 uSun;      // sun direction in view space (x east, y north, z out)
uniform vec4 uInk;
uniform vec4 uPaper;
uniform vec4 uAccent;
uniform vec4 uFade;     // x0, x1: density ramps up left to right; y0, y1: ramps down top to bottom
uniform float uDark;    // 1 when ink is light on dark paper
uniform sampler2D uMask; // land coverage, equirectangular
uniform sampler2D uAux;  // r: Blue Marble luminance, g: elevation, b: city lights

out vec4 fragColor;

const float PI = 3.14159265359;

float bayer2(vec2 a) {
  a = floor(a);
  return fract(a.x / 2.0 + a.y * a.y * 0.75);
}

float hash(vec2 c) {
  return fract(sin(dot(c, vec2(12.9898, 78.233))) * 43758.5453);
}

float bayer4(vec2 a) {
  return bayer2(0.5 * a) * 0.25 + bayer2(a);
}

void main() {
  // Local (logical) coordinates on the web renderer.
  vec2 frag = FlutterFragCoord().xy;
  vec2 cell = floor(frag / uCell);
  vec2 p = (cell + 0.5) * uCell;
  float thr = bayer4(cell) + 0.03125;

  // The fade edge is ragged, so the dither tears into the page rather than
  // stopping at a ruled line.
  float fade = 1.0;
  if (uFade.y > uFade.x) {
    float rag = max(0.0, 40.0 + (hash(vec2(floor(cell.y / 2.0), 3.0)) - 0.5) * 30.0
        + sin(p.y * 0.021) * 18.0 + sin(p.y * 0.0063 + 1.7) * 24.0);
    fade *= clamp((p.x - rag - uFade.x) / (uFade.y - uFade.x), 0.0, 1.0);
  }
  if (uFade.w > uFade.z) {
    float rag = max(0.0, 14.0 + (hash(vec2(floor(cell.x / 2.0), 5.0)) - 0.5) * 16.0 + sin(p.x * 0.03) * 10.0);
    fade *= 1.0 - clamp((p.y + rag - uFade.z) / (uFade.w - uFade.z), 0.0, 1.0);
  }
  if (fade <= 0.0) {
    fragColor = uPaper;
    return;
  }

  float x = (p.x - uCenter.x) / uRadius;
  float y = -(p.y - uCenter.y) / uRadius;
  float rr = x * x + y * y;

  if (rr > 1.0) {
    // A faint dotted atmosphere just outside the limb.
    float t = (sqrt(rr) - 1.0) * uRadius;
    float v = t < 7.0 ? 0.22 * (1.0 - t / 7.0) : 0.0;
    fragColor = v * fade > thr ? uInk : uPaper;
    return;
  }

  float z = sqrt(1.0 - rr);
  float sp = sin(uView.y);
  float cp = cos(uView.y);
  float lat = asin(clamp(z * sp + y * cp, -1.0, 1.0));
  float lon = uView.x + atan(x, z * cp - y * sp);
  vec2 uv = vec2(fract(lon / (2.0 * PI) + 0.5), clamp(0.5 - lat / PI, 0.0, 1.0));

  float land = texture(uMask, uv).r;
  vec3 aux = texture(uAux, uv).rgb;

  vec3 n = vec3(x, y, z);
  float lit = max(0.0, dot(n, normalize(vec3(-0.35, 0.55, 0.76))));
  float limb = 1.0 - z;
  float sunDot = dot(n, uSun);
  float night = smoothstep(0.06, -0.12, sunDot);

  // Angular size of one cell, used to keep lines about one cell wide.
  float cellDeg = uCell / uRadius * 180.0 / PI;
  float latD = lat * 180.0 / PI;
  float lonD = lon * 180.0 / PI;

  float v;
  if (land > 0.5) {
    v = 0.2 + (0.55 - aux.r) * 0.85 + (1.0 - lit) * 0.22 + limb * 0.12;
    if (latD > 62.0 || latD < -60.0) {
      v -= 0.2;
    }
    // Night reads as shadow in both themes. City lights are scattered
    // single cells, more of them where the lights are brighter, so the
    // coastline survives even over a lit-up country.
    float glow = smoothstep(0.28, 0.8, aux.b);
    float spark = night * step(1.0 - glow * 0.5, hash(cell));
    if (uDark > 0.5) {
      v = mix(v * 0.85, 0.46, night * 0.75);
      v = spark > 0.5 ? 1.0 : v;
    } else {
      v = mix(v, 0.8, night * 0.85);
      v = spark > 0.5 ? 0.0 : v;
    }
  } else {
    v = 0.035 + limb * 0.3 + (1.0 - lit) * 0.08;
    v = uDark > 0.5 ? v * (1.0 - 0.6 * night) : v + night * 0.2;
    float wLat = 0.55 * cellDeg;
    float wLon = wLat / max(cos(lat), 0.08);
    float onLat = step(5.0 - wLat, abs(mod(latD, 10.0) - 5.0));
    float onLon = step(5.0 - wLon, abs(mod(lonD, 10.0) - 5.0));
    if (onLat + onLon > 0.0) {
      // Dark theme: a sparse grid that stays below night-side land.
      if (uDark > 0.5) {
        v = max(v, 0.14);
      } else if (mod(cell.x + cell.y, 2.0) < 1.0) {
        v = 0.9;
      }
    }
  }

  // Day/night terminator: a dotted accent line with a paper casing so it
  // reads over dense night-side dither.
  // Solid, two cells wide: the one live line, distinct from dashed routes.
  float band = uCell / uRadius;
  float d = abs(sunDot);
  if (fade > 0.5 && d < band * 3.2) {
    fragColor = d < band * 1.6 ? uAccent : uPaper;
    return;
  }

  fragColor = v * fade > thr ? uInk : uPaper;
}
