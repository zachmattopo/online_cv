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

## Task-observer skill activation block

Before the first tool call of any session — and before writing or
proposing a plan, not merely before executing one — invoke the
task-observer skill AND execute its Session Start Protocol (storage
check, frontmatter scan, review trigger). Loading the skill and running
the protocol are separate steps; a session that loads the file and stops
has activated nothing. Any turn that will involve a tool call counts; do
not classify the session as "too simple" from its opening message.

Select skills on the DECISION the request is about, not on the artefact it
arrived as. Name what the user is deciding, then match the installed skill
descriptions against that — a request handed over as a file to review
still needs the skill whose description names its subject.

After completing each task, list the observation records written this
session in the same turn and report a one-line summary from that listing
(ids and titles, or "none logged and why") — never from memory of
writing them. This is the activation backstop: it forces a look at the log,
so a session that silently skipped the protocol is discovered at the
first task boundary instead of never.

Loading a skill is not complete until you have queried the observation
log for OPEN observations naming it and read their bodies:
find "[ABSOLUTE PATH]/skill-observations/observation-log" -maxdepth 1 \
 -name '_.md' -exec grep -l "skill:._<skill-name>" {} +
(Use find, not a bare \*.md glob. Under zsh an unmatched glob is an error,
so on an empty log the command never runs and the enclosing block aborts —
and 2>/dev/null does not help, because the redirection belongs to a
command that never starts. This is the first thing that fires on a fresh
install, in every session, for as long as the log is empty.)
Apply their insights to the current work — meaning: let them change what
you do in THIS task. Editing the skill file, or writing the rule into any
other file a later session reads, is acting on the observation and waits
for the review. See "Log, don't act" in SKILL.md: the test is whether the
action leaves a durable change outside the observation log. Run this at every skill load, however many skills load
in one session. The session-start scan does not cover it: that is a
frontmatter sweep over every observation at session start, this is a
body-level lookup for one skill at the moment its rules are applied.

The converse holds too: the grep, and any checkpoint line recording the
load, run only in the same batch as the Skill invocation, and take the
skill name from a load that has actually happened — never from a list of
skills you built to load. A checkpoint line written without the load is a
false record. Before writing to any file a skill reads at run time (a
state file), load that skill: a state file that describes itself is not a
substitute for the skill that owns it.

The task-observer workspace for this project is:
[ABSOLUTE PATH]
Every path the skill uses derives from that root and nothing else:
[ABSOLUTE PATH]/skill-observations/observation-log/ (the log)
[ABSOLUTE PATH]/skill-observations/cross-cutting-principles.md
[ABSOLUTE PATH]/skill-updates/ (staging root)
[ABSOLUTE PATH]/skill-updates/PENDING.md (staging manifest)
Never resolve any of them from the current working
directory — a cwd inside an ephemeral checkout (a git worktree, a temporary
clone) is torn down and takes the log with it. Never place the workspace
inside a skills-discovery directory or any path linked into one. If this
environment mints a separate project identity per checkout, or more than
one agent works this project, the pinned path above is the single shared
location; do not derive one per session, tool or project.

The user's repositories live under:
[PROJECTS ROOT]
(the root the sibling check sweeps before declaring a skill absent;
observation-log.md, "Skill families and the sibling check").

A subagent dispatched by a session that already runs this protocol does
not run it again and does not write to the log. The controller observes,
because only it sees the whole task and its review; a subagent that
notices something worth logging says so in its final report, and the
controller writes it, running the id snippet per write. A start-up rule
in a project file reaches every agent the project ever dispatches.

An observation file comes into being only through
bash "<skill directory>/scripts/new-observation.sh" <slug> "[ABSOLUTE PATH]"
which prints the path to write into. Never by copying another file's
header or counting a listing — including on the turn after a
compaction, when the skill body is out of context.
