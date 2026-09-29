import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../globe/globe_math.dart';
import '../main.dart';
import '../models/journey_stop.dart';
import '../presentation/cubit/resume_cubit.dart';
import '../theme/hn_theme.dart';
import 'hn_widgets.dart';
import 'pixel_icon.dart';
import 'pixel_text.dart';

class NavBar extends StatelessWidget {
  final ValueListenable<DateTime> clock;
  final ValueListenable<int> activeSection;
  final ValueChanged<int> onNavigate;
  final VoidCallback onHome;
  final VoidCallback onContact;

  const NavBar({
    super.key,
    required this.clock,
    required this.activeSection,
    required this.onNavigate,
    required this.onHome,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= HnLayout.desktopBreakpoint;
    final wide = width >= 1180;

    return BlocBuilder<ResumeCubit, ResumeState>(
      builder: (context, state) {
        final linkedIn = state.socialLinks.where((s) => s.label == 'LinkedIn').firstOrNull;
        return Container(
          height: HnLayout.navHeight,
          padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 16),
          decoration: BoxDecoration(
            color: p.paper.withValues(alpha: 0.94),
            border: Border(bottom: BorderSide(color: p.hair)),
          ),
          child: Row(
            children: [
              Pressable(
                onTap: onHome,
                semanticLabel: '${state.name}, back to top',
                builder: (context, hover, focus) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PixelAvatar(size: 32),
                    const SizedBox(width: 12),
                    PixelText(state.name, size: 28, scale: 2),
                  ],
                ),
              ),
              if (desktop) ...[
                const SizedBox(width: 28),
                ValueListenableBuilder<int>(
                  valueListenable: activeSection,
                  builder: (context, current, _) => Row(
                    children: [
                      for (var i = 0; i < state.navLabels.length; i++)
                        _NavItem(label: state.navLabels[i], active: i == current, onTap: () => onNavigate(i)),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              if (wide) ...[
                _AvailabilityPill(clock: clock, city: state.homeCity, zone: state.homeZone),
                const SizedBox(width: 18),
              ],
              if (desktop && linkedIn != null) ...[
                HnExternal(
                  url: linkedIn.url,
                  builder: (context, hover, focus) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: Text('LINKEDIN', style: HnType.label(hover ? p.accent : p.ink)),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const _ThemeToggle(),
              const SizedBox(width: 10),
              if (desktop)
                HnButton('Get in touch →', compact: true, onTap: onContact)
              else
                _MobileMenu(labels: state.navLabels, onNavigate: onNavigate, onContact: onContact),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Pressable(
      onTap: onTap,
      semanticLabel: active ? '$label, current section' : label,
      builder: (context, hover, focus) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: active || hover ? p.wash : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label.toUpperCase(), style: HnType.label(active || hover ? p.ink : p.mute)),
      ),
    );
  }
}

class _AvailabilityPill extends StatelessWidget {
  final ValueListenable<DateTime> clock;
  final String city;
  final StopZone zone;

  const _AvailabilityPill({required this.clock, required this.city, required this.zone});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(border: Border.all(color: p.hair), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LiveDot(size: 6),
          const SizedBox(width: 9),
          ValueListenableBuilder<DateTime>(
            valueListenable: clock,
            builder: (context, now, _) {
              final t = localTime(zone, now.toUtc());
              return Text(
                'Available now · $city ${hhmm(t.time)}',
                style: HnType.body(p.go, size: 12, weight: FontWeight.w500).copyWith(height: 1.2),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: dark ? 'Switch to light' : 'Switch to dark',
      child: Pressable(
        onTap: () => themeNotifier.value = dark ? ThemeMode.light : ThemeMode.dark,
        semanticLabel: dark ? 'Switch to light theme' : 'Switch to dark theme',
        builder: (context, hover, focus) => Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: hover ? p.wash : null, borderRadius: BorderRadius.circular(4)),
          alignment: Alignment.center,
          child: PixelIcon(dark ? PixelGlyph.sun : PixelGlyph.moon, color: p.ink, cell: 1.5),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final List<String> labels;
  final ValueChanged<int> onNavigate;
  final VoidCallback onContact;

  const _MobileMenu({required this.labels, required this.onNavigate, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final p = HnPalette.of(context);
    return PopupMenuButton<int>(
      tooltip: 'Menu',
      color: p.paper,
      elevation: 0,
      shape: RoundedRectangleBorder(side: BorderSide(color: p.ink), borderRadius: BorderRadius.circular(4)),
      icon: PixelIcon(PixelGlyph.menu, color: p.ink, cell: 2),
      onSelected: (i) => i < labels.length ? onNavigate(i) : onContact(),
      itemBuilder: (context) => [
        for (var i = 0; i < labels.length; i++)
          PopupMenuItem<int>(value: i, child: Text(labels[i].toUpperCase(), style: HnType.label(p.ink, size: 12.5))),
        PopupMenuItem<int>(
          value: labels.length,
          child: Text('GET IN TOUCH →', style: HnType.label(p.accent, size: 12.5, weight: FontWeight.w700)),
        ),
      ],
    );
  }
}
