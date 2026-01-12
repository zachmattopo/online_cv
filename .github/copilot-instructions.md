<!-- Copilot / AI agent instructions for the `online_cv` Flutter project -->

Purpose
-------
- Quick, actionable guidance for AI coding agents to be productive in this repo.

Big picture (what this app is)
------------------------------
- Single-page Flutter web/app that renders an online CV/portfolio.
- Entrypoint: [lib/main.dart](lib/main.dart#L1-L40) — global `themeNotifier` controls theme.
- Primary screen: [lib/screens/portfolio_screen.dart](lib/screens/portfolio_screen.dart#L1-L200) — uses `SuperSliverList` to compose sections.
- Data instances live under `lib/models` (example: [lib/models/experience.dart](lib/models/experience.dart#L1-L120)) as const lists — edit these to change content shown in the UI.

Architecture & patterns to follow
--------------------------------
- UI-first structure: most logic lives in `lib/widgets/*` (sections like `hero_section.dart`, `experience_section.dart`). Refer to [lib/widgets/hero_section.dart](lib/widgets/hero_section.dart#L1-L200) for common patterns (responsive breakpoints, `Image.network` with `errorBuilder`, `Wrap` for buttons).
- Responsive breakpoint convention: components often check `screenWidth > 900` to decide desktop layout (see `hero_section`).
- The app keeps minimal app-wide state: `themeNotifier` is a global `ValueNotifier<ThemeMode>` in `main.dart` used by the `MaterialApp`.
- Navigation / scrolling: `PortfolioScreen` uses `ListController` + `ScrollController` to animate between GlobalKey-marked sections — preserve this pattern when adding new sections.
- Data model conventions: models use immutable `const` classes and top-level `final List<...>` values (edit these rather than scattering data across widgets).
- In widgets' `build` method, prefer extracting sub-widgets to a separate stateless widget class rather than a helper method (for better performance and readability).
- If using `bloc` or `cubit` from the bloc package, prefer using `BlocBuilder` instead of direct `read` usages so UI automatically updates if the bloc/cubit changes later.
- If making a List, prefer to define concrete types (e.g., `List<SocialLink>`) rather than untyped `List` for better type safety.
- If a stateless widget has no constructor parameters, prefer defining it as a `const` constructor for better performance.
- Prefer using safe access patterns (e.g., null-aware operators) when reading data from models to avoid runtime exceptions.

Developer workflows (discovered from project files)
-------------------------------------------------
- Install deps: `flutter pub get` (manifest: [pubspec.yaml](pubspec.yaml#L1-L40)).
- Run locally (web): `flutter run -d chrome` or choose a device; hot reload works as usual.
- Build for web: `flutter build web --release` — result appears in `build/web/` and `build/**/web/` (this repo includes previously built web assets).
- Lints: project uses `flutter_lints` (dev_dependency in `pubspec.yaml`).

Common libraries & integration points
------------------------------------
- `url_launcher` — used for external links (see `hero_section`'s `_launchUrl`). Use `canLaunchUrl` then `launchUrl`.
- `phosphor_flutter` — icon pack used across buttons.
- `google_fonts` — consistent typography via `GoogleFonts.interTextTheme()` in `main.dart`.
- `super_sliver_list` — used to manage sliver lists and animated scrolling in `PortfolioScreen`.

Practical editing guidance (examples)
------------------------------------
- To update experience items: edit [lib/models/experience.dart](lib/models/experience.dart#L1-L120). The UI reads these const objects directly.
- To add a new section: create a widget in `lib/widgets/`, add it to the `SliverChildListDelegate` in [lib/screens/portfolio_screen.dart](lib/screens/portfolio_screen.dart#L1-L200) and include a matching `GlobalKey` entry for scrolling.
- For responsive UI, follow the `isDesktop = screenWidth > 900` pattern used in `hero_section`.
- When adding network images, include an `errorBuilder` fallback (pattern shown in `hero_section`).

Conventions & small-but-important details
----------------------------------------
- Prefer immutable `const` data for static content; this repository follows that pattern for model lists.
- Styling: app uses Material 3 and `ThemeData` seeded with `ColorScheme.fromSeed` in `main.dart` — use `theme.colorScheme` and `theme.textTheme` consistently.
- Floating action behavior: `PortfolioScreen` toggles FAB visibility based on scroll offset — keep scroll listeners performant and paired with `dispose()`.

What not to assume
-------------------
- There are no automated tests or CI config in the repo — do not add test-related assertions unless requested.
- Separation of UI vs business logic is still WIP (not yet enforced) — expect UI widgets to contain presentation logic.

When you change code
--------------------
- Run `flutter analyze` locally (or `flutter pub get` then `flutter run`) to verify formatting and runtime behavior.
- For web deployment, use `flutter build web --release` and inspect `build/web` before publishing.

If you need clarification
------------------------
- Ask which area to prioritize (content edits, responsive fixes, or refactor to separate layers). If editing content, point to the specific model file to update.

End of instructions
