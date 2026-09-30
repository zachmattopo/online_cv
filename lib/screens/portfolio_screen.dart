import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../core/motion_prefs.dart';
import '../globe/globe_grip.dart';
import '../globe/globe_math.dart';
import '../globe/globe_view.dart';
import '../globe/journey_timeline.dart';
import '../models/journey_stop.dart';
import '../presentation/cubit/resume_cubit.dart';
import '../theme/hn_theme.dart';
import '../widgets/contact_section.dart';
import '../widgets/fast_lane.dart';
import '../widgets/hero_section.dart';
import '../widgets/journey_stop_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/plain_cv_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/stack_section.dart';
import '../widgets/visitor_counter_section.dart';

/// Lays out every list item up front so stop offsets are exact, which the
/// scroll-driven globe camera depends on.
class _PrecalculateAll extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) => true;
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ListController _listController = ListController();
  final _PrecalculateAll _precalc = _PrecalculateAll();

  final ValueNotifier<GlobeFrame> _frame = ValueNotifier(
    const GlobeFrame(camera: GlobeCamera(focusLon: -10, focusLat: 24, radius: 300, anchor: Offset(900, 450))),
  );
  final ValueNotifier<DateTime> _clock = ValueNotifier(DateTime.now());
  final ValueNotifier<int> _activeStop = ValueNotifier(-1);
  final ValueNotifier<int> _activeNav = ValueNotifier(-1);
  final ValueNotifier<double> _band = ValueNotifier(0);

  // List items: hero, one per stop, then the remaining sections.
  static const int _heroItem = 0;
  static const int _firstStopItem = 1;
  int get _projectsItem => _firstStopItem + _stops.length;
  int get _stackItem => _projectsItem + 1;
  int get _plainCvItem => _projectsItem + 2;
  int get _contactItem => _projectsItem + 3;

  List<JourneyStop> _stops = const [];
  Size _viewport = Size.zero;
  bool _reduceMotion = false;
  Timer? _clockTimer;
  late final Ticker _spin;
  double _heroLon = -10;
  double _heroLat = 24;
  Duration _lastSpin = Duration.zero;

  // Hero globe interaction: the reader can grab and spin it.
  final ValueNotifier<bool> _gripEnabled = ValueNotifier(true);
  bool _dragging = false;
  double _spinVelocity = 0; // extra °/s from a flick, decays back to idle

  static const double _idleSpin = 3.2; // °/s

  void _onGrab() {
    _dragging = true;
    _spinVelocity = 0;
  }

  void _onGripDrag(double dLon, double dLat) {
    _heroLon = (_heroLon + dLon + 180) % 360 - 180;
    _heroLat = (_heroLat + dLat).clamp(-60.0, 75.0);
    _update();
  }

  void _onRelease(double lonPerSecond) {
    _dragging = false;
    // Keep the flick's momentum (minus the idle spin it resumes into).
    _spinVelocity = _reduceMotion ? 0 : (lonPerSecond - _idleSpin).clamp(-720.0, 720.0);
  }

  void _onGripScroll(PointerScrollEvent e) {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    pos.jumpTo((pos.pixels + e.scrollDelta.dy).clamp(pos.minScrollExtent, pos.maxScrollExtent));
  }

  @override
  void initState() {
    super.initState();
    VisitorCounterSection.preload();
    _reduceMotion = browserPrefersReducedMotion();
    _scrollController.addListener(_update);
    _clockTimer = Timer.periodic(const Duration(seconds: 20), (_) => _clock.value = DateTime.now());
    _spin = createTicker(_onSpin);
    if (!_reduceMotion) _spin.start();
    _openDeepLink();
  }

  /// `?at=birmingham` (or projects, stack, plain-cv, contact) opens the page
  /// on that stop or section, so any stop can be shared as a link.
  void _openDeepLink() {
    final at = Uri.base.queryParameters['at'];
    if (at == null || at.isEmpty) return;
    var tries = 0;
    void attempt(Duration _) {
      if (!_listController.isAttached || _stops.isEmpty) {
        if (tries++ < 10) SchedulerBinding.instance.addPostFrameCallback(attempt);
        return;
      }
      final stop = _stops.indexWhere((s) => s.id == at || s.code.toLowerCase() == at.toLowerCase());
      final sections = {'projects': _projectsItem, 'stack': _stackItem, 'plain-cv': _plainCvItem, 'contact': _contactItem};
      final item = stop >= 0 ? _firstStopItem + stop : sections[at];
      if (item == null) return;
      _listController.jumpToItem(index: item, scrollController: _scrollController, alignment: 0);
      _update();
    }

    SchedulerBinding.instance.addPostFrameCallback(attempt);
  }

  void _onSpin(Duration elapsed) {
    final dt = (elapsed - _lastSpin).inMicroseconds / 1e6;
    _lastSpin = elapsed;
    final offset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    // Only the hero spins; once the camera leaves it the ticker idles.
    if (offset > _viewport.height * 0.3 || _dragging) return;
    // A flick carries on and decays back into the slow idle spin.
    _spinVelocity *= math.exp(-dt * 2.2);
    if (_spinVelocity.abs() < 0.05) _spinVelocity = 0;
    _heroLon = (_heroLon + dt * (_idleSpin + _spinVelocity) + 180) % 360 - 180;
    _update();
  }

  JourneyTimeline? _timeline() {
    if (!_listController.isAttached || _viewport == Size.zero || _stops.isEmpty) return null;
    final n = _listController.numberOfItems;
    final offsets = <double>[], extents = <double>[];
    var acc = 0.0;
    for (var i = 0; i < n; i++) {
      final e = _listController.extentForIndex(i).$1;
      offsets.add(acc);
      extents.add(e);
      acc += e;
    }
    return JourneyTimeline(
      viewport: _viewport,
      stops: _stops,
      offsets: offsets,
      extents: extents,
      firstStopItem: _firstStopItem,
      reduceMotion: _reduceMotion,
      heroLon: _heroLon,
      heroLat: _heroLat,
    );
  }

  void _update() {
    final tl = _timeline();
    if (tl == null) return;
    final s = _scrollController.hasClients ? _scrollController.offset : 0.0;
    _frame.value = tl.frameAt(s);
    // The globe is grabbable only while the page rests on the hero.
    _gripEnabled.value = _frame.value.activeStop < 0 && s < _viewport.height * 0.3;
    _activeStop.value = tl.activeStopAt(s);
    final h = _viewport.height, end = tl.journeyEnd;
    // Nav highlight: Journey, Projects, Stack, Plain CV (−1 in the hero).
    final probe = s + h * 0.4;
    final navStarts = [_firstStopItem, _projectsItem, _stackItem, _plainCvItem];
    var nav = -1;
    for (var k = 0; k < navStarts.length; k++) {
      if (navStarts[k] < tl.offsets.length && probe >= tl.offsets[navStarts[k]]) nav = k;
    }
    // Contact and the footer are not nav destinations.
    if (_contactItem < tl.offsets.length && probe >= tl.offsets[_contactItem]) nav = -1;
    _activeNav.value = nav;
    if (!tl.desktop) {
      final full = JourneyTimeline.bandHeight(_viewport);
      _band.value = full * (1 - ((s - (end - h)) / (h * 0.6)).clamp(0.0, 1.0));
    } else {
      _band.value = 0;
    }
  }

  /// Every jump (nav, hero buttons, fast lane) takes a fixed 300ms with a
  /// fast start, so the page responds the instant it's asked to.
  void _scrollToItem(int index) {
    if (!_listController.isAttached) return;
    if (_reduceMotion) {
      _listController.jumpToItem(index: index, scrollController: _scrollController, alignment: 0);
      return;
    }
    _listController.animateToItem(
      index: index,
      scrollController: _scrollController,
      alignment: 0,
      duration: (_) => const Duration(milliseconds: 300),
      curve: (_) => Curves.easeOutCubic,
    );
  }

  // Easter egg: `sudo` in the fast lane gets a "permission denied" head-shake.
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  void _shakeGlobe() {
    if (_reduceMotion) return;
    _shake.forward(from: 0);
  }

  /// Horizontal offset of the shaking globe: a quick, decaying back-and-forth.
  double get _shakeOffset {
    final t = _shake.value;
    if (t == 0 || t == 1) return 0;
    return math.sin(t * math.pi * 8) * 14 * (1 - t);
  }

  void _scrollToStop(int i) => _scrollToItem(_firstStopItem + i);

  void _onNavigate(int navIndex) {
    // Nav labels: Journey, Projects, Stack, Plain CV.
    final targets = [_firstStopItem, _projectsItem, _stackItem, _plainCvItem];
    _scrollToItem(targets[navIndex.clamp(0, targets.length - 1)]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = _reduceMotion || MediaQuery.disableAnimationsOf(context);
    if (reduce != _reduceMotion) {
      _reduceMotion = reduce;
      if (reduce) _spin.stop();
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _spin.dispose();
    _shake.dispose();
    _scrollController.dispose();
    _listController.dispose();
    _frame.dispose();
    _clock.dispose();
    _activeStop.dispose();
    _activeNav.dispose();
    _band.dispose();
    _gripEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size != _viewport) {
      _viewport = size;
      SchedulerBinding.instance.addPostFrameCallback((_) => _update());
    }
    final desktop = size.width >= HnLayout.desktopBreakpoint;
    final palette = HnPalette.of(context);

    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) {
        _stops = state.journeyStops;
        final band = desktop ? 0.0 : JourneyTimeline.bandHeight(size);
        final globe = AnimatedBuilder(
          animation: _shake,
          builder: (context, child) => Transform.translate(offset: Offset(_shakeOffset, 0), child: child),
          child: GlobeView(frame: _frame, clock: _clock, stops: state.journeyStops),
        );

        final list = SuperSliverList(
          listController: _listController,
          extentPrecalculationPolicy: _precalc,
          delegate: SliverChildListDelegate([
            HeroSection(
              key: const ValueKey('hero'),
              clock: _clock,
              topInset: HnLayout.navHeight + band,
              onContact: () => _scrollToItem(_contactItem),
              onPlainCv: () => _scrollToItem(_plainCvItem),
            ),
            for (var i = 0; i < state.journeyStops.length; i++)
              JourneyStopSection(
                key: ValueKey('stop-${state.journeyStops[i].id}'),
                stop: state.journeyStops[i],
                index: i,
                total: state.journeyStops.length,
                clock: _clock,
                activeStop: _activeStop,
                reduceMotion: _reduceMotion,
                topInset: HnLayout.navHeight + band,
              ),
            const ProjectsSection(key: ValueKey('projects')),
            const StackSection(key: ValueKey('stack')),
            const PlainCvSection(key: ValueKey('plain-cv')),
            ContactSection(key: const ValueKey('contact'), clock: _clock),
            const VisitorCounterSection(key: ValueKey('footer')),
          ]),
        );

        final scrollView = NotificationListener<ScrollMetricsNotification>(
          onNotification: (_) {
            _update();
            return false;
          },
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(controller: _scrollController, slivers: [list]),
          ),
        );

        return Scaffold(
          backgroundColor: palette.paper,
          body: SelectionArea(
            child: Stack(
              children: [
                if (desktop) Positioned.fill(child: globe),
                Positioned.fill(child: scrollView),
                if (!desktop)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: ValueListenableBuilder<double>(
                      valueListenable: _band,
                      builder: (context, b, child) => SizedBox(
                        height: HnLayout.navHeight + b,
                        child: ClipRect(
                          child: OverflowBox(
                            alignment: Alignment.topCenter,
                            minHeight: size.height,
                            maxHeight: size.height,
                            // The band only draws the globe; touches pass through
                            // to the page underneath so a swipe anywhere scrolls.
                            child: IgnorePointer(
                              child: ColoredBox(color: palette.paper, child: child),
                            ),
                          ),
                        ),
                      ),
                      child: globe,
                    ),
                  ),
                Positioned.fill(
                  child: GlobeGrip(
                    frame: _frame,
                    enabled: _gripEnabled,
                    allowTilt: desktop,
                    onStart: _onGrab,
                    onDrag: _onGripDrag,
                    onEnd: _onRelease,
                    onScroll: _onGripScroll,
                    scrollController: _scrollController,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: NavBar(
                    clock: _clock,
                    activeSection: _activeNav,
                    onNavigate: _onNavigate,
                    onHome: () => _scrollToItem(_heroItem),
                    onContact: () => _scrollToItem(_contactItem),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FastLane(
                    stops: state.journeyStops,
                    active: _activeStop,
                    onJump: _scrollToStop,
                    onPlainCv: () => _scrollToItem(_plainCvItem),
                    onSudo: _shakeGlobe,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
