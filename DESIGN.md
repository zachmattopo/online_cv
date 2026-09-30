---
name: GET /hafiz
description: A career served like a live API, carried by one 1-bit dithered globe on white paper and black ink.
colors:
  paper: "#FFFFFF"
  ink: "#151515"
  mute: "#6B6B66"
  hair: "#E4E4E0"
  wash: "#F3F3F0"
  code: "#D5DCE5"
  code-ink: "#1C2633"
  code-mute: "#55616F"
  slate: "#55687C"
  on-slate: "#FFFFFF"
  go: "#1A7F3F"
  dark-paper: "#0F0F0E"
  dark-ink: "#ECECE8"
  dark-mute: "#9C9C96"
  dark-hair: "#2B2B28"
  dark-wash: "#1B1B19"
  dark-code: "#1D252F"
  dark-code-ink: "#DCE3EC"
  dark-code-mute: "#93A0B0"
  dark-slate: "#93A7C0"
  dark-on-slate: "#0F0F0E"
  dark-go: "#4CC47E"
typography:
  display:
    fontFamily: "LibreCaslonText (rasterised pixel serif, PixelText)"
    fontSize: "clamp(72px, 7.8vw, 124px)"
    fontWeight: 400
    lineHeight: 1.08
    letterSpacing: "-0.25px"
  headline:
    fontFamily: "LibreCaslonText (rasterised pixel serif, PixelText)"
    fontSize: "96px"
    fontWeight: 400
    lineHeight: 1.08
    letterSpacing: "-0.25px"
  title:
    fontFamily: "LibreCaslonText (rasterised pixel serif, PixelText)"
    fontSize: "32px"
    fontWeight: 500
    lineHeight: 1.08
  body:
    fontFamily: "JetBrainsMono, monospace"
    fontSize: "14.5px"
    fontWeight: 400
    lineHeight: 1.7
  code:
    fontFamily: "JetBrainsMono, monospace"
    fontSize: "13px"
    fontWeight: 400
    lineHeight: 1.75
  label:
    fontFamily: "JetBrainsMono, monospace"
    fontSize: "11.5px"
    fontWeight: 500
    lineHeight: 1.3
    letterSpacing: "0.09em"
rounded:
  sm: "4px"
  focus: "5px"
  md: "6px"
spacing:
  gutter-mobile: "20px"
  gutter-desktop: "64px"
  nav-height: "60px"
  lane-height: "64px"
  stack-sm: "12px"
  stack-md: "22px"
  stack-lg: "40px"
  section-top: "104px"
components:
  button-primary:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.paper}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "13px 18px"
  button-primary-hover:
    backgroundColor: "{colors.slate}"
    textColor: "{colors.on-slate}"
  button-primary-compact:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.paper}"
    rounded: "{rounded.sm}"
    padding: "9px 14px"
  button-outline:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "13px 18px"
  button-outline-hover:
    backgroundColor: "{colors.wash}"
    textColor: "{colors.ink}"
  nav-item:
    textColor: "{colors.mute}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "7px 10px"
  nav-item-active:
    backgroundColor: "{colors.wash}"
    textColor: "{colors.ink}"
  stop-chip:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.sm}"
    padding: "6px 10px"
  stop-chip-active:
    backgroundColor: "{colors.slate}"
    textColor: "{colors.on-slate}"
  response-block:
    backgroundColor: "{colors.code}"
    textColor: "{colors.code-ink}"
    typography: "{typography.code}"
    rounded: "{rounded.md}"
    padding: "14px 18px 16px"
  fast-lane:
    backgroundColor: "{colors.paper}"
    rounded: "{rounded.md}"
    height: "64px"
    padding: "0 18px"
  project-card:
    backgroundColor: "{colors.paper}"
    rounded: "{rounded.md}"
    padding: "22px 24px"
  availability-pill:
    textColor: "{colors.go}"
    rounded: "{rounded.sm}"
    padding: "6px 11px"
  tooltip:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.paper}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
---

# Design System: GET /hafiz

Platform note: this is Flutter web, rendered to canvas. There is no CSS. Every token below lives in Dart; the source for each is named inline so later agents can find it. Colour tokens are fields on `HnPalette` (`lib/theme/hn_theme.dart`, `HnPalette.light` / `HnPalette.dark`, read with `HnPalette.of(context)`). The `slate` token is the `accent` field and `on-slate` is `onAccent`; `code-ink` / `code-mute` are `codeInk` / `codeMute`. Type helpers are `HnType.body` and `HnType.label`; layout constants are `HnLayout`; the Material theme is assembled in `buildTheme(Brightness)`.

## Overview

**Creative North Star: "The Printed Response"**

The page is a sheet of white paper with black ink on it, and the career arrives on it like the body of an API response. One object carries the whole page: an orthographic globe rendered as a 1-bit ordered dither, which the reader's scroll turns and zooms from stop to stop. Beside it, left-aligned text columns hold a pixel-serif place name, a mono paragraph, and a pale slate code block whose JSON fills in as the camera lands.

Every tone is made of two values. The globe's greys are Bayer dither, the display type is a real serif rasterised low and stepped up in hard pixels, icons are 11×11 bitmaps, and even section rules are bands of dither fading out. Colour is rationed: one slate blue sampled from the profile photo marks places, the live day/night line, the active stop, focus and selection; one green only ever means live or OK. Chrome is quiet: hairline borders, 4px corners, tracked mono caps, no shadows.

Density is editorial rather than dashboard: one column of text per viewport on desktop (440 to 560px wide), generous vertical air between sections, and the globe allowed to bleed off the right edge and tear raggedly into the paper instead of sitting in a frame.

**Key Characteristics:**
- Two-value material everywhere: ink or paper, with dither standing in for grey.
- A procedural pixel serif for display; JetBrains Mono for everything else.
- One slate accent for place, live time, active state and focus; one green for live/OK.
- Flat: hairlines and tonal wash, never drop shadows.
- Scroll is the only camera control; motion eases in and out and snaps under reduced motion.

## Colors

A monochrome paper-and-ink palette with a single cool slate taken from the photo and a status green held in reserve.

### Primary
- **Photo Slate** (`slate`, `HnPalette.accent`): stop markers on the globe, the day/night terminator and its "DAY / NIGHT · LIVE" label, the active fast-lane chip, the fill of a hovered primary button, hovered text links, the fast-lane prompt icon, the "Advanced" skill caption, the hero live-line dash, the focus ring, the text cursor, and selection (at 28% alpha). Dark theme uses **Pale Slate** (`dark-slate`) with `dark-on-slate` text.

### Secondary
- **Status Green** (`go`, `HnPalette.go`): the `LiveDot`, the nav availability pill text, and the `200 OK` dot in a finished response. It means live or OK and nothing else. Dark: `dark-go`.

### Neutral
- **Paper** (`paper`): page, nav (at 94% alpha), fast lane, cards, label plates on the globe, and the paper casing under every globe line.
- **Ink** (`ink`): text, primary buttons, routes and crosshair on the globe, dither dots, tooltip fill, avatar frame. Body paragraphs run at 86% ink alpha with bold runs at full ink.
- **Mute** (`mute`): pixel-serif subtitles, captions, meta text, inactive nav items, placeholder text, unfocused stop codes.
- **Hair** (`hair`): every 1px border and row divider. The fast lane's border is hair lerped 12% toward ink.
- **Wash** (`wash`): hover and active backgrounds (nav item, outline button, chip, contact row, theme toggle); also `ThemeData.hoverColor`.
- **Slate Code** (`code`, `code-ink`, `code-mute`): the ResponseBlock only. String values are `code-ink` lerped 65% toward slate; punctuation is `code-mute`. This is the one broad use of the blue family.

### Named Rules
**The Two Colour Jobs Rule.** Slate marks place, the live terminator, active state and focus; green marks live/OK. Neither is decoration, and routes on the globe stay ink so slate keeps meaning "a place" or "now".

**The Inverted Sheet Rule.** Dark theme is the same world inverted, not a new mood: ink and paper swap, slate lightens to `dark-slate`, and the globe shader reads night as shadow in both themes (`uDark` switches city lights to light single cells).

## Typography

**Display Font:** Libre Caslon Text, rasterised by `PixelText` (`lib/widgets/pixel_text.dart`); asset `assets/fonts/LibreCaslonText.ttf`
**Body Font:** JetBrains Mono (`HnType.mono`); asset `assets/fonts/JetBrainsMono.ttf`; also `ThemeData.fontFamily`
**Label/Mono Font:** JetBrains Mono, tracked caps via `HnType.label`

**Character:** A bookish old-style serif forced through a low-resolution grid, set against a working monospace. The serif gives the page a voice; the mono makes everything else read as output.

**How the pixel serif is made.** Text is laid out at `size / scale` (rounded), painted, hard-thresholded to one colour (alpha cutoff 96 below a 15px base, 112 above), then drawn back up with `FilterQuality.none`, so every edge steps in `scale`-pixel blocks. The base weight thickens as it shrinks (below 15px base: w600; below 20: w500; else w400) so hairlines survive. `fitOneLine` shrinks the base one pixel at a time until the line fits. Screen readers get the plain string, with `header: true` on headings.

### Hierarchy
- **Display** (pixel serif, scale 4, `clamp(72, width × 0.078, 124)px` desktop, 64px scale 3 mobile): the hero name. Contact title uses 120px desktop / 72px mobile.
- **Headline** (pixel serif, scale 4, 96px desktop / 60px scale 3 mobile): each journey stop's city. `SectionHead` titles use 72px (×0.72 and scale 3 on narrow).
- **Title** (pixel serif, scale 2, 32px desktop / 28px mobile, in `mute`): the grey line under every display or headline. The nav name uses 28px scale 2 in ink.
- **Body** (mono 400, 14.5px, line-height 1.7, `MarkupText`): ledes and summaries, `**double asterisks**` for w700 ink runs. Secondary rows use 13 to 13.5px at 1.45 to 1.6; card titles 15px w700.
- **Code** (mono, 13px, line-height 1.75): ResponseBlock; the method is w700, numbers and status w600.
- **Label** (mono 500, 11.5px, line-height 1.3, tracking 0.09em, uppercase): nav items, captions, globe labels, tooltips. Buttons use 12px w600 (11.5 compact).
- **Link** (mono, 12.5px, underline 1px at 40% ink, `HnTextLink`).

### Named Rules
**The One Serif Rule.** The serif appears only as `PixelText`. Never set Libre Caslon as smooth live text, and never set display type in the mono.

**The Stepped Pair Rule.** A pixel-serif heading is always followed by its grey scale-2 pixel-serif line (`SectionHead`, hero, stops, contact), at 12 to 18px spacing.

## Layout

- **Breakpoint** (`HnLayout.desktopBreakpoint`, 900px): at or above it, the globe fills the whole viewport behind the scroll list and text sits in a left column; below it, the globe sits in a fixed band under the nav (`JourneyTimeline.bandHeight`: 42% of viewport height, clamped 260 to 420px) and content scrolls beneath. The nav's availability pill appears only at 1180px and above.
- **Gutter** (`HnLayout.gutter`): 64px desktop, 20px mobile. Nav and fast lane use 28px (16px mobile nav).
- **Text column** (`HnLayout.column`): 40% of width, clamped 440 to 560px, on hero and stops. Contact is capped at 1080px max width.
- **Fixed chrome:** nav 60px (`HnLayout.navHeight`) pinned top with a hair bottom border; fast lane 64px (`HnLayout.laneHeight`) pinned bottom, inset 28px sides and 24px bottom on desktop; 56px full-bleed bar with a hair top border on mobile. Hero and stops pad their bottom by lane height plus 56 to 64px so nothing hides under it.
- **Sections:** hero and each stop are at least one viewport tall and vertically centred. Later sections (Projects, Stack, Plain CV, Contact) open with 96 to 104px top padding (80 to 84 mobile), a `DitherRule`, 28px, then the heading pair, then 40px to content. Projects are equal-height cards in a row, 24px apart, on desktop.
- **Rhythm:** vertical stacks step 12 / 14 / 18 / 22 / 26 / 30px between heading, subtitle, paragraph, response and links. Rows inside lists are separated by hair top borders with 8 to 22px vertical padding, not by gaps.
- **Globe framing** (`lib/globe/journey_timeline.dart`): hero globe radius `min(29% width, 40% height)`, centred at 71% width and 53% height, fading out 140 to 40px before the text column's right edge. At a stop the camera sits at 45% of the space right of the column, 62% down, radius `clamp(95% width, 900, 2200) × per-stop zoom`, with the horizon held just under the nav.

## Elevation & Depth

Flat. No surface in the system casts a drop shadow. Depth is conveyed by the globe itself (dither density, limb darkening and a faint dotted atmosphere), by tonal wash on hover, and by paper casings: every line and label drawn over the globe sits on a paper halo or plate so it separates from the dither without a shadow. Popups are `elevation: 0` with a 1px ink border. The nav is paper at 94% alpha over the scroll, with a hair rule.

### Named Rules
**The Casing Not Shadow Rule.** To lift a mark off the globe, draw paper under it (4px casing under dashed routes, 11px paper square under 7px stop markers, 5px paper ring under the slate crosshair ring, paper plates with a 1px border under labels). Never a blur.

## Shapes

Small, square-shouldered corners: 4px (`rounded.sm`) on buttons, chips, nav items, the availability pill, stack tags, tooltips and the mobile menu; 6px (`rounded.md`) on the larger containers (ResponseBlock, fast lane, project cards, project logo tiles). The focus ring is drawn at 5px so it hugs 4px controls. Borders are always 1px hair except the 2px slate focus ring and the 1px ink avatar frame. Everything drawn on the globe is square and unrounded: stop markers are squares (7px slate active-set, 8px ink outline for others, 10px ink core on the active stop), labels are square plates, and only the 22px crosshair ring is round. Pixel artefacts (avatar, icons, display type, dither) keep hard, unsmoothed edges; they are always drawn with `FilterQuality.none` or anti-aliasing off.

## Components

### Buttons (`HnButton`, `lib/widgets/hn_widgets.dart`)
Blunt and typographic.
- **Shape:** 4px corners, 1px border matching the fill (outline variant: hair).
- **Primary:** ink fill, paper text, uppercase label at 12px w600, 13×18px padding (compact 9×14px, 11.5px, used in the nav).
- **Hover:** fill turns slate with on-slate text, 140ms ease-out. Outline variant: paper to wash.
- **Focus:** 2px slate ring from `Pressable`. Enter and Space activate.
- Labels may carry a trailing arrow ("Get in touch →"); they are uppercased in code, never in data.

### Text links (`HnTextLink`)
Mono 12.5px with a 1px underline at 40% ink; on hover text and underline go slate. External links render as real anchors through `HnExternal` (`url_launcher` `Link`), `mailto:` opening in place and others in a new tab.

### Chips: fast-lane stops (`_StopChip`, `lib/widgets/fast_lane.dart`)
- **Style:** lower-case city at 12.5px ink plus the year at 11.5px mute, 6×10px padding, 1px hair border, 4px corners.
- **State:** active is slate fill and border with on-slate text (year at 75%); hover is wash; chips that do not match the search dim to 35% opacity (160ms). Fill and text change together, instantly. The active chip scrolls itself into view (260ms ease-out cubic), and the row fades its edges only while chips are clipped past them.

### Cards / Containers
- **Project card:** paper, 1px hair, 6px corners, 22×24px padding, 40px-tall project logo (32px on narrow screens) with 6px corners on the page's own paper, plus a dark-background variant where the artwork needs one, meta rows as caption + text separated by hair rules.
- **ResponseBlock:** `code` fill, 6px corners, 18px side padding. Header row is `GET /stops/<id>` and a status (`LiveDot` + "200 OK · 03:23 BST"; a grey dot and "pending…" before it finishes). Body is pretty-printed JSON. Unarrived lines are drawn transparent so the page never reflows.
- **Shadow strategy:** none (see Elevation).

### Inputs / Fields (fast-lane search)
Borderless mono 13.5px field inside the lane, placeholder "City, company, year" in mute, slate cursor, led by the slate pixel `prompt` icon. Typing dims non-matching chips; Enter flies to the first match; an empty result replaces the chips with a mute sentence. The lane is paper, 64px tall, 6px corners, a border of hair lerped 12% to ink.

### Navigation (`lib/widgets/nav_bar.dart`)
- Left: `PixelAvatar` (the photo decoded at 16×16 and upscaled nearest-neighbour, 32px, 1px ink frame) and the name in 28px pixel serif, together a back-to-top target.
- Section items: uppercase labels in mute, 7×10px padding, 4px corners; active and hover go ink on wash (160ms). Active item is announced as "current section".
- Right: availability pill (hair border, `LiveDot`, green mono 12px "Available now · Aberdeen 03:23", 1180px and up), LINKEDIN label link, the theme toggle (36px square, pixel sun or moon, with tooltip), compact primary "Get in touch →".
- Mobile (below 900px): links collapse into a `PopupMenuButton` behind a pixel `menu` icon; paper, 1px ink border, 4px corners, no elevation, the last item "GET IN TOUCH →" in slate.

### Pressable (`Pressable`)
The single interaction primitive. Every tap target goes through it: `FocusableActionDetector` for hover and keyboard focus, Enter/Space shortcuts, click cursor, `Semantics` as button or link with an optional label, and a 2px slate foreground ring at 5px radius when focus is visible.

### DitherRule (`DitherRule`)
An 8px band of 2px ink cells thresholded against a 4×4 Bayer matrix, dense (62%) at the left, thinning to about 6% by 55% width and to nothing at the right edge. It opens every section after the journey. Excluded from semantics.

### Pixel icons (`PixelIcon`, `lib/widgets/pixel_icon.dart`)
11×11 bitmaps (sun, moon, menu, prompt, arrowUpRight) drawn cell by cell without anti-aliasing at `cell` 1.5 or 2px. No icon font is shipped.

### LiveDot and Caption
`LiveDot`: a 6 to 7px green circle with a 3px spread ring of green at 18% alpha. `Caption`: uppercase mono label in mute, used as a field label beside or above data (period, contact channel, meta key), never as a heading kicker.

### The Globe (signature; `shaders/globe.frag`, `lib/globe/globe_view.dart`)
- **Material:** each 2px cell is shaded once and thresholded against a 4×4 Bayer matrix, so the output is only ink, paper, or slate. Land density comes from a land mask plus Blue Marble luminance (`assets/globe/`), with fixed top-left lighting, limb darkening and lighter polar caps. Ocean is near-empty with a 10° graticule of alternating cells (light) or a sparse grid (dark). A 7px dotted atmosphere sits just outside the limb.
- **Live sun:** the real subsolar point drives the night side; night reads as shadow, and city lights are scattered single cells (ink on light, paper on dark). The terminator is a solid slate line two cells wide on a paper casing, labelled "DAY / NIGHT · LIVE" in slate in the hero.
- **Edges:** the globe fades out toward the text column (desktop) or the band bottom (mobile) with a ragged, hash-and-sine-jittered edge, so the dither tears into the paper.
- **Marks** (`_MarksPainter`): routes are ink dashed great circles on paper casing (3 on / 4 to 5 off; the next leg finer, 1.5 on / 5 off). Hero shows the whole route with slate square markers. At a stop: an ink crosshair whose arms retract in flight, a 10px ink core, a 22px slate ring, and an ink-bordered label plate "BHX · 52.49°N 1.89°W · 03:23 BST". Other stops are 8px ink-outlined squares with mute code plates. A "→ NEXT: CITY" plate tries ten positions and is skipped rather than overlap anything. Labels never enter the nav, lane or faded region.
- The globe fades in over 420ms (instant under reduced motion) and is excluded from semantics; the same facts exist as text.

### Motion grammar
- **Camera** (`JourneyTimeline.frameAt`): scroll-driven only. The camera holds on a stop while its section is read and flies to the next along the great circle with ease-in-out cubic, pulling back to the whole disc after the last stop.
- **Idle spin:** 3.2°/s west to east (the real direction: anticlockwise from above the North Pole), hero only, stopped once the reader scrolls past 30% of the viewport.
- **Programmatic jumps** (nav, chips): ease-in-out cubic, 450 to 1800ms scaled by distance.
- **Response reveal:** on first landing, the JSON types in line by line over `180 + 110 × (lines)` ms, once.
- **State changes:** 140 to 160ms ease-out on hover and active fills.

## Do's and Don'ts

### Do:
- **Do** take every colour from `HnPalette.of(context)`; never hard-code a hex in a widget.
- **Do** build any tone, rule or texture from two values and an ordered dither, as `DitherRule` and `globe.frag` do.
- **Do** set display type with `PixelText` and pair it with the grey scale-2 pixel line beneath.
- **Do** route every interactive element through `Pressable` (or `HnExternal` for URLs) so it gets hover, the 2px slate focus ring, Enter/Space and semantics.
- **Do** lift marks over the globe with paper casings and square plates with 1px borders.
- **Do** honour reduced motion: `browserPrefersReducedMotion()` (`lib/core/motion_prefs.dart`) or `MediaQuery.disableAnimationsOf` snaps the camera between stops, stops the spin, fills responses instantly and skips the globe fade and scroll animations.
- **Do** keep content inside `SelectionArea` so all text stays selectable, with slate selection at 28% alpha.
- **Do** keep the fast lane and a route to the Plain CV visible at every scroll position.

### Don't:
- **Don't** add drop shadows, blurs, glows or glass to any surface.
- **Don't** use slate or green decoratively; slate is place, live terminator, active and focus, and green is live/OK.
- **Don't** draw routes in slate; they stay ink.
- **Don't** smooth pixel artefacts; the avatar, icons and display type are always drawn with `FilterQuality.none`.
- **Don't** ship an icon font or Material icons for chrome; add an 11×11 `PixelIcon` bitmap instead.
- **Don't** put uppercase captions above headings as kickers; `Caption` labels data only.
- **Don't** round beyond 6px, or use 1px borders in anything but hair (ink only for the avatar, the mobile menu and the active globe label).
- **Don't** animate anything from a timer or on load in the journey; the camera answers to scroll alone.
