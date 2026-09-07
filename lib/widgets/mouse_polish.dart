import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A pointer ring, click burst, and idle Zs, never replacing the native cursor.
/// Only these decorative overlays repaint, not the portfolio or its images.
class MousePolish extends StatefulWidget {
  const MousePolish({super.key, required this.child});

  final Widget child;

  static bool enabledOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MouseMode>();
    return (scope?.notifier?.value ?? true) &&
        !MediaQuery.disableAnimationsOf(context);
  }

  @override
  State<MousePolish> createState() => _MousePolishState();
}

class _MousePolishState extends State<MousePolish>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final _position = ValueNotifier<Offset?>(null);
  final _burstPosition = ValueNotifier<Offset?>(null);
  final _sleepPosition = ValueNotifier<Offset?>(null);
  final _mouseMode = ValueNotifier(false);
  late final AnimationController _clickAnimation;
  late final AnimationController _sleepAnimation;
  Timer? _idleTimer;
  Timer? _sleepTimer;

  @override
  void initState() {
    super.initState();
    _clickAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) _burstPosition.value = null;
    });
    _sleepAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    WidgetsBinding.instance.addObserver(this);
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) _deactivate();
    return false;
  }

  void _deactivate() {
    _idleTimer?.cancel();
    _wake();
    _clickAnimation.stop();
    _burstPosition.value = null;
    _position.value = null;
    _mouseMode.value = false;
  }

  void _hover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse ||
        MediaQuery.disableAnimationsOf(context)) {
      _deactivate();
      return;
    }
    _track(event.localPosition);
  }

  void _wake() {
    _sleepTimer?.cancel();
    _sleepAnimation.stop();
    _sleepPosition.value = null;
  }

  void _armSleep(Offset position) {
    _wake();
    // A single timer, with no animation frames until the full idle delay passes.
    _sleepTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted ||
          !_mouseMode.value ||
          MediaQuery.disableAnimationsOf(context)) {
        return;
      }
      _sleepPosition.value = position;
      _sleepAnimation.value = 0;
      _sleepAnimation.repeat();
    });
  }

  void _track(Offset position, {bool armSleep = true}) {
    _mouseMode.value = true;
    _position.value = position;
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(milliseconds: 1400), () {
      _position.value = null;
    });
    if (armSleep) {
      _armSleep(position);
    } else {
      _wake();
    }
  }

  void _down(PointerDownEvent event) {
    if (event.kind != PointerDeviceKind.mouse ||
        MediaQuery.disableAnimationsOf(context)) {
      _deactivate();
      return;
    }
    _track(event.localPosition, armSleep: false);
    if (event.buttons != kPrimaryMouseButton) return;
    // Reuse one burst; rapid clicks never accumulate particles or timers.
    _burstPosition.value = event.localPosition;
    _clickAnimation.forward(from: 0);
  }

  void _up(PointerUpEvent event) {
    if (event.kind != PointerDeviceKind.mouse ||
        MediaQuery.disableAnimationsOf(context) ||
        !(Offset.zero & MediaQuery.sizeOf(context)).contains(
          event.localPosition,
        )) {
      _deactivate();
      return;
    }
    // A held mouse button is activity, even without movement.
    _track(event.localPosition);
  }

  void _signal(PointerSignalEvent event) {
    if (event.kind != PointerDeviceKind.mouse ||
        MediaQuery.disableAnimationsOf(context)) {
      _deactivate();
      return;
    }
    _track(event.localPosition);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _deactivate();
  }

  @override
  void didChangeMetrics() => _deactivate();

  @override
  void dispose() {
    _idleTimer?.cancel();
    _sleepTimer?.cancel();
    HardwareKeyboard.instance.removeHandler(_onKey);
    WidgetsBinding.instance.removeObserver(this);
    _clickAnimation.dispose();
    _sleepAnimation.dispose();
    _position.dispose();
    _burstPosition.dispose();
    _sleepPosition.dispose();
    _mouseMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return _MouseMode(
      notifier: _mouseMode,
      child: MouseRegion(
        opaque: false,
        // Defer to links, text selection, and the platform's normal pointer.
        cursor: MouseCursor.defer,
        onExit: (_) => _deactivate(),
        child: Listener(
          onPointerHover: _hover,
          onPointerDown: _down,
          onPointerUp: _up,
          onPointerSignal: _signal,
          onPointerCancel: (_) => _deactivate(),
          onPointerMove: (_) {
            // Do not leave the ring behind while dragging or selecting text.
            _idleTimer?.cancel();
            _wake();
            _position.value = null;
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.child,
              ValueListenableBuilder<Offset?>(
                valueListenable: _position,
                builder: (context, position, _) {
                  if (position == null || reducedMotion) {
                    return const SizedBox.shrink();
                  }
                  return Positioned(
                    left: position.dx - 7,
                    top: position.dy - 7,
                    width: 14,
                    height: 14,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: RepaintBoundary(
                          child: DecoratedBox(
                            key: const ValueKey('mouse-cursor-ring'),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xC08E44AD),
                                width: 1.4,
                              ),
                              color: const Color(0x0F8E44AD),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x208E44AD),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<Offset?>(
                valueListenable: _burstPosition,
                builder: (context, position, _) {
                  if (position == null || reducedMotion) {
                    return const SizedBox.shrink();
                  }
                  return Positioned(
                    left: position.dx - 36,
                    top: position.dy - 36,
                    width: 72,
                    height: 72,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            key: const ValueKey('mouse-click-burst'),
                            painter: _ClickBurstPainter(_clickAnimation),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<Offset?>(
                valueListenable: _sleepPosition,
                builder: (context, position, _) {
                  if (position == null || reducedMotion) {
                    return const SizedBox.shrink();
                  }
                  final viewport = MediaQuery.sizeOf(context);
                  // Keep the whole animation visible near viewport edges.
                  return Positioned(
                    left: (position.dx + 2).clamp(
                      4.0,
                      math.max(4.0, viewport.width - 88),
                    ),
                    top: (position.dy - 54).clamp(
                      4.0,
                      math.max(4.0, viewport.height - 76),
                    ),
                    width: 84,
                    height: 72,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: RepaintBoundary(
                          child: _SleepingCursor(animation: _sleepAnimation),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Larger, spaced letters float beside the cursor; only this overlay rebuilds.
class _SleepingCursor extends StatelessWidget {
  const _SleepingCursor({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder:
        (context, _) => Stack(
          key: const ValueKey('mouse-sleep-zzz'),
          children: [
            for (var index = 0; index < 3; index++)
              _letter((animation.value + index / 3) % 1, index),
          ],
        ),
  );

  Widget _letter(double progress, int index) {
    final float = (1 - math.cos(2 * math.pi * progress)) / 2;
    return Positioned(
      left: 2 + 20.0 * index,
      top: 6 + (2 - index) * 12 - 6 * float,
      child: Opacity(
        opacity: 0.45 + 0.55 * float,
        child: Text(
          index == 0 ? 'Z' : 'z',
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            color: const Color(0xFF8E44AD),
            fontSize: 28 + 4.0 * index,
            fontWeight: FontWeight.w700,
            height: 1,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

/// Short rounded rays echo the supplied purple click indicator.
class _ClickBurstPainter extends CustomPainter {
  _ClickBurstPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    final spread = Curves.easeOutCubic.transform(progress);
    final center = size.center(Offset.zero);
    final paint =
        Paint()
          ..color = const Color(0xFF8E44AD).withValues(alpha: 1 - progress)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
    for (var ray = 0; ray < 10; ray++) {
      final angle = -math.pi / 2 + ray * math.pi / 5;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final inner = 9 + 13 * spread;
      final length = 7 * (1 - spread) + 3;
      canvas.drawLine(
        center + direction * inner,
        center + direction * (inner + length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ClickBurstPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

class _MouseMode extends InheritedNotifier<ValueNotifier<bool>> {
  const _MouseMode({required super.notifier, required super.child});
}
