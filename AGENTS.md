When editing or debugging this Flutter CV app, mind these non-obvious facts:

## Commands
- `flutter run -d chrome` — run locally
- `flutter build web --release` — deploy build; output at `build/web/`
- `flutter analyze` — lint/typecheck (uses `flutter_lints`), CRITICAL: always run and verify no issues found before ending response
- `flutter pub get` — install deps
- `dart run flutter_native_splash:create` — regenerate the web splash after changing its config in `pubspec.yaml`
- FVM: `.fvmrc` pins Flutter 3.41.7 — don't upgrade without updating

## Architecture
- Single-page Flutter web app. Entry: `lib/main.dart`. Only one screen: `lib/screens/portfolio_screen.dart`.
- Data flows: `lib/core/static_data.dart` (const lists) → `ResumeRepository` → `ResumeCubit` → UI via `BlocBuilder`.
- Edit CV content in `lib/core/static_data.dart`, **not** in widgets. Models are immutable const classes in `lib/models/`. The career globe reads `journeyStops` (`JourneyStop`: coordinates, time zone, summary with `**bold**` markup, response-block `facts`, and the `Experience`/`Education` entries it covers).
- List items (in `SuperSliverList` order): Hero → one `JourneyStopSection` per stop (most recent first) → Projects → Stack → Plain CV → Contact → footer (visitor counter). Navigation uses `ListController.animateToItem`; preserve this when adding sections.
- The list uses an `ExtentPrecalculationPolicy` that lays out every item, because the globe camera maps exact item offsets to scroll position (`lib/globe/journey_timeline.dart`). Keep journey stops as separate list items.
- Globe: `shaders/globe.frag` (1-bit Bayer-dithered orthographic globe, real day/night terminator) drawn by `lib/globe/globe_view.dart`; math (projection, great-circle flights, sun position, local time with DST for UK/Malaysia/US Central) in `lib/globe/globe_math.dart`. On the web renderer `FlutterFragCoord()` is already in logical px — do not divide by DPR. Unused uniforms may be stripped, so keep the Dart `setFloat` order in sync with the shader's uniform declarations.
- Baked textures: `assets/globe/land_mask.webp` (4096×2048 land coverage) and `assets/globe/earth_aux.webp` (R: Blue Marble luminance, G: elevation, B: city lights). Rebake from `.impeccable/mocks/src/textures.html` if needed.
- Deep links: `?at=<stop id|projects|stack|plain-cv|contact>` opens on that stop or section; `?theme=light|dark` pins the theme.
- Breakpoint: `width >= 900` is desktop (globe behind the left text column); below that the globe is a band under the nav and collapses after the journey.
- Dark/light toggle: global `themeNotifier` (`ValueNotifier<ThemeMode>`) in `main.dart`. Not cubit-managed.
- Reduced motion: `lib/core/motion_prefs.dart` reads `prefers-reduced-motion` (the web engine does not); the camera then snaps between stops and the hero globe stops spinning.

## Theming & libs
- Tokens live in `lib/theme/hn_theme.dart` (`HnPalette` light/dark as a ThemeExtension, `HnType`, `HnLayout`). Paper, ink and one slate blue (`#55687C`, from the profile photo) used sparingly for places, focus and the active chip; green only means live/OK.
- Display type is `PixelText` (procedural bitmap serif: Libre Caslon rasterised low, thresholded, scaled nearest-neighbour). Everything else is JetBrains Mono. Both fonts are bundled in `assets/fonts/` (OFL); there is no `google_fonts` dependency.
- Icons are 11×11 bitmaps in `lib/widgets/pixel_icon.dart` (no icon font). Use `url_launcher`'s `Link` (via `HnExternal`) for external links so they are real anchors. Visitor counter: `visitorbadge.io` SVG via `jovial_svg` (returns 400 on localhost; works on the production path).
- No tests, no CI, no build scripts — do not add them unless asked.

## Content editing
- `lib/core/static_data.dart` — all CV content (experience, skills, projects, education, about, contact, social links, journey stops, hero and section copy).
- `lib/models/` — data classes only. `Experience`, `Project`, `Skill`, `SocialLink`, `UrlLink`, `Education`, `JourneyStop`.
- Visitor counter: footer SVG badge in `visitor_counter_section.dart`. Edit the path there if the live URL changes.
- Splash screen: `flutter_native_splash` configured in `pubspec.yaml`. Image at `assets/images/splash_image.png` (also the source of the pixelated nav avatar).
