import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'globe_math.dart';

/// An invisible, disc-shaped handle laid over the hero globe so it can be
/// dragged to spin. It only exists while the camera is on the hero; once
/// the journey starts, the globe belongs to the scroll again.
class GlobeGrip extends StatefulWidget {
  final ValueListenable<GlobeFrame> frame;

  /// Whether the page is still at the hero (the grip hides otherwise).
  final ValueListenable<bool> enabled;

  /// Narrow layouts only spin horizontally, so vertical swipes still scroll.
  final bool allowTilt;
  final VoidCallback onStart;

  /// Drag delta in degrees of longitude and latitude.
  final void Function(double dLon, double dLat) onDrag;

  /// Release velocity in degrees of longitude per second.
  final ValueChanged<double> onEnd;

  /// Forwards mouse-wheel and trackpad scrolls to the page underneath.
  final ValueChanged<PointerScrollEvent> onScroll;

  const GlobeGrip({
    super.key,
    required this.frame,
    required this.enabled,
    required this.allowTilt,
    required this.onStart,
    required this.onDrag,
    required this.onEnd,
    required this.onScroll,
  });

  @override
  State<GlobeGrip> createState() => _GlobeGripState();
}

class _GlobeGripState extends State<GlobeGrip> {
  bool _dragging = false;

  static const double _deg = 57.29577951308232;

  void _update(Offset delta, double radius) {
    // A drag of one radius turns the planet one radian, so the land under
    // the pointer roughly follows it.
    widget.onDrag(-delta.dx / radius * _deg, widget.allowTilt ? delta.dy / radius * _deg : 0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.enabled,
      builder: (context, enabled, _) {
        if (!enabled) return const SizedBox.shrink();
        return ValueListenableBuilder<GlobeFrame>(
          valueListenable: widget.frame,
          builder: (context, f, _) {
            final c = f.camera.center, r = f.camera.radius;
            void start() {
              setState(() => _dragging = true);
              widget.onStart();
            }

            void end(double vx) {
              setState(() => _dragging = false);
              widget.onEnd(-vx / r * _deg);
            }

            return Stack(
              children: [
                Positioned(
                  left: c.dx - r,
                  top: c.dy - r,
                  width: r * 2,
                  height: r * 2,
                  child: Semantics(
                    label: 'Globe. Drag to spin it.',
                    child: Listener(
                      onPointerSignal: (e) {
                        if (e is PointerScrollEvent) widget.onScroll(e);
                      },
                      // ClipOval makes only the disc itself grabbable.
                      child: ClipOval(
                        child: MouseRegion(
                          cursor: _dragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
                          child: widget.allowTilt
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onPanStart: (_) => start(),
                                  onPanUpdate: (d) => _update(d.delta, r),
                                  onPanEnd: (d) => end(d.velocity.pixelsPerSecond.dx),
                                  onPanCancel: () => end(0),
                                )
                              : GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onHorizontalDragStart: (_) => start(),
                                  onHorizontalDragUpdate: (d) => _update(d.delta, r),
                                  onHorizontalDragEnd: (d) => end(d.velocity.pixelsPerSecond.dx),
                                  onHorizontalDragCancel: () => end(0),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
