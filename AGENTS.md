When editing or debugging this Flutter CV app, mind these non-obvious facts:

## Commands
- `flutter run -d chrome` — run locally
- `flutter build web --release` — deploy build; output at `build/web/`
- `flutter analyze` — lint/typecheck (uses `flutter_lints`), CRITICAL: always run and verify no issues found before ending response
- `flutter pub get` — install deps
- FVM: `.fvmrc` pins Flutter 3.41.7 — don't upgrade without updating

## Architecture
- Single-page Flutter web app. Entry: `lib/main.dart`. Only one screen: `lib/screens/portfolio_screen.dart`.
- Data flows: `lib/core/static_data.dart` (const lists) → `ResumeRepository` → `ResumeCubit` → UI via `BlocBuilder`.
- Edit CV content in `lib/core/static_data.dart`, **not** in widgets. Models are immutable const classes in `lib/models/`.
- Navigation: `PortfolioScreen` uses `SuperSliverList` + `CustomScrollController` + `GlobalKey`s + `ListController` (`super_sliver_list`) to scroll between sections. Preserve this when adding sections.
- Sections order (matching `_sectionKeys`): Hero → About → Experience → Projects → Skills → Education → Contact → VisitorCounter.
- App bar breakpoint: `screenWidth > 600`. Hero section breakpoint: `screenWidth > 900`.
- Dark/light toggle: global `themeNotifier` (`ValueNotifier<ThemeMode>`) in `main.dart`. Not cubit-managed.

## Theming & libs
- Material 3, `ColorScheme.fromSeed(seedColor: 0xFF0284C7)`, `GoogleFonts.interTextTheme()`.
- Icons: `phosphor_flutter` (not Material Icons for social). Use `url_launcher` for external links (`canLaunchUrl` → `launchUrl`). Animations via `flutter_animate`. Visitor counter: `visitorbadge.io` SVG via `jovial_svg`.
- No tests, no CI, no build scripts — do not add them unless asked.

## Content editing
- `lib/core/static_data.dart` — all CV content (experience, skills, projects, education, about, contact, social links).
- `lib/models/` — data classes only. `Experience`, `Project`, `Skill`, `SocialLink`, `UrlLink`.
- Visitor counter: footer SVG badge in `visitor_counter_section.dart` — uses `visitorbadge.io`. Edit the path there if the live URL changes.
- Splash screen: `flutter_native_splash` configured in `pubspec.yaml`. Image at `assets/images/splash_image.png`.
