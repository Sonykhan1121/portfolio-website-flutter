import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/widgets/mouse_polish.dart';

const _halo = ValueKey('mouse-cursor-ring');
const _burst = ValueKey('mouse-click-burst');
const _sleep = ValueKey('mouse-sleep-zzz');

Widget _app({bool reducedMotion = false, VoidCallback? onTap, Widget? child}) =>
    MaterialApp(
      builder:
          (context, navigator) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(disableAnimations: reducedMotion),
            child: MousePolish(child: navigator!),
          ),
      home: Scaffold(
        body:
            child ??
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: onTap ?? () {},
                    child: const Text('Tap me'),
                  ),
                  Builder(
                    builder:
                        (context) => Text(
                          MousePolish.enabledOf(context)
                              ? 'mouse effects'
                              : 'plain controls',
                        ),
                  ),
                ],
              ),
            ),
      ),
    );

Future<TestGesture> _mouse(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: const Offset(5, 5));
  await mouse.moveTo(const Offset(120, 100));
  await tester.pump(const Duration(milliseconds: 120));
  return mouse;
}

void main() {
  testWidgets('touch gets no halo and buttons still respond', (tester) async {
    var clicks = 0;
    await tester.pumpWidget(_app(onTap: () => clicks++));
    expect(find.byKey(_halo), findsNothing);
    expect(find.text('plain controls'), findsOneWidget);
    await tester.tap(find.text('Tap me'));
    await tester.pump();
    expect(clicks, 1);
    expect(find.byKey(_halo), findsNothing);
    expect(find.byKey(_burst), findsNothing);
  });

  testWidgets(
    'halo follows mouse, preserves cursor and never intercepts clicks',
    (tester) async {
      var clicks = 0;
      await tester.pumpWidget(_app(onTap: () => clicks++));
      final mouse = await _mouse(tester);
      expect(find.byKey(_halo), findsOneWidget);
      expect(tester.getSize(find.byKey(_halo)), const Size(14, 14));
      expect(find.text('mouse effects'), findsOneWidget);
      await mouse.moveTo(const Offset(200, 150));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      expect(tester.getCenter(find.byKey(_halo)), const Offset(200, 150));
      final ignored = find.ancestor(
        of: find.byKey(_halo),
        matching: find.byWidgetPredicate(
          (widget) => widget is IgnorePointer && widget.ignoring,
        ),
      );
      expect(ignored, findsWidgets);
      final rootRegion = tester.widget<MouseRegion>(
        find
            .descendant(
              of: find.byType(MousePolish),
              matching: find.byType(MouseRegion),
            )
            .first,
      );
      expect(rootRegion.cursor, MouseCursor.defer);
      await mouse.moveTo(tester.getCenter(find.text('Tap me')));
      await tester.pump(const Duration(milliseconds: 120));
      await mouse.down(tester.getCenter(find.text('Tap me')));
      await mouse.up();
      await tester.pump();
      expect(clicks, 1);
      expect(find.byKey(_halo), findsOneWidget);
      expect(find.byKey(_burst), findsOneWidget);
      expect(
        tester.getCenter(find.byKey(_burst)),
        tester.getCenter(find.text('Tap me')),
      );
      expect(
        find.ancestor(
          of: find.byKey(_burst),
          matching: find.byWidgetPredicate(
            (widget) => widget is IgnorePointer && widget.ignoring,
          ),
        ),
        findsWidgets,
      );
      await tester.pump(const Duration(milliseconds: 450));
      expect(find.byKey(_burst), findsNothing);
      await mouse.removePointer();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'hybrid input switches off for touch and keyboard, back on for mouse',
    (tester) async {
      await tester.pumpWidget(_app());
      final mouse = await _mouse(tester);
      await mouse.down(const Offset(120, 100));
      await mouse.up();
      await tester.pump();
      expect(find.byKey(_burst), findsOneWidget);
      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(find.byKey(_halo), findsNothing);
      expect(find.byKey(_burst), findsNothing);
      expect(find.text('plain controls'), findsOneWidget);
      await mouse.moveTo(const Offset(220, 120));
      await tester.pump();
      expect(find.byKey(_halo), findsOneWidget);
      await mouse.down(const Offset(220, 120));
      await mouse.up();
      await tester.pump();
      expect(find.byKey(_burst), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(find.byKey(_halo), findsNothing);
      expect(find.byKey(_burst), findsNothing);
      expect(find.text('plain controls'), findsOneWidget);
      await mouse.moveTo(const Offset(230, 120));
      await tester.pump();
      expect(find.byKey(_halo), findsOneWidget);
      await mouse.removePointer();
      await tester.pump();
      expect(find.byKey(_halo), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'reduced motion suppresses halo, including when changed at runtime',
    (tester) async {
      await tester.pumpWidget(_app());
      final mouse = await _mouse(tester);
      expect(find.byKey(_halo), findsOneWidget);
      await mouse.down(const Offset(120, 100));
      await mouse.up();
      await tester.pump();
      expect(find.byKey(_burst), findsOneWidget);
      await tester.pumpWidget(_app(reducedMotion: true));
      expect(find.byKey(_halo), findsNothing);
      expect(find.byKey(_burst), findsNothing);
      expect(find.text('plain controls'), findsOneWidget);
      await mouse.moveTo(const Offset(250, 150));
      await mouse.down(const Offset(250, 150));
      await mouse.up();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(_halo), findsNothing);
      expect(find.byKey(_burst), findsNothing);
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'pointer motion does not rebuild content; idle halo stops scheduling frames',
    (tester) async {
      var builds = 0;
      await tester.pumpWidget(
        _app(
          child: Builder(
            builder: (context) {
              builds++;
              return const ColoredBox(
                color: Colors.white,
                child: SizedBox.expand(),
              );
            },
          ),
        ),
      );
      final initialBuilds = builds;
      final mouse = await _mouse(tester);
      for (var step = 0; step < 10; step++) {
        await mouse.moveTo(Offset(150 + step * 4, 100));
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(builds, initialBuilds);
      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pump();
      expect(find.byKey(_halo), findsNothing);
      expect(tester.binding.hasScheduledFrame, isFalse);
      await mouse.removePointer();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('inactive application removes the halo', (tester) async {
    await tester.pumpWidget(_app());
    final mouse = await _mouse(tester);
    await mouse.down(const Offset(120, 100));
    await mouse.up();
    await tester.pump();
    expect(find.byKey(_burst), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byKey(_halo), findsNothing);
    expect(find.byKey(_burst), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('burst stays at click position while the small ring follows', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    final mouse = await _mouse(tester);
    await mouse.down(const Offset(120, 100));
    await mouse.up();
    await tester.pump();
    await mouse.moveTo(const Offset(250, 200));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getCenter(find.byKey(_halo)), const Offset(250, 200));
    expect(tester.getCenter(find.byKey(_burst)), const Offset(120, 100));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byKey(_burst), findsNothing);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('rapid clicks reuse one burst and stop repainting when done', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    final mouse = await _mouse(tester);
    for (var step = 0; step < 8; step++) {
      final position = Offset(130 + step * 12, 100);
      await mouse.moveTo(position);
      await mouse.down(position);
      await mouse.up();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byKey(_burst), findsOneWidget);
      expect(tester.getCenter(find.byKey(_burst)), position);
    }
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();
    expect(find.byKey(_burst), findsNothing);
    expect(find.byKey(_halo), findsNothing);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('secondary mouse clicks do not trigger a burst', (tester) async {
    await tester.pumpWidget(_app());
    final mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await mouse.addPointer(location: const Offset(120, 100));
    await mouse.down(const Offset(120, 100));
    await mouse.up();
    await tester.pump();
    expect(find.byKey(_burst), findsNothing);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('drag input reaches content and does not leave a stale ring', (
    tester,
  ) async {
    var moves = 0;
    await tester.pumpWidget(
      _app(
        child: Listener(
          onPointerMove: (_) => moves++,
          child: const ColoredBox(
            color: Colors.white,
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
    final mouse = await _mouse(tester);
    await mouse.down(const Offset(120, 100));
    await tester.pump();
    expect(find.byKey(_halo), findsOneWidget);
    await mouse.moveTo(const Offset(250, 200));
    await tester.pump();
    expect(moves, 1);
    expect(find.byKey(_halo), findsNothing);
    await mouse.up();
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('sleep starts only after twenty seconds of actual mouse idle', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(seconds: 25));
    expect(find.byKey(_sleep), findsNothing);
    final mouse = await _mouse(tester);
    await mouse.moveTo(const Offset(200, 150));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 19999));
    expect(find.byKey(_sleep), findsNothing);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.byKey(_sleep), findsOneWidget);
    expect(
      find.descendant(of: find.byKey(_sleep), matching: find.text('Z')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byKey(_sleep), matching: find.text('z')),
      findsNWidgets(2),
    );
    expect(
      find.ancestor(
        of: find.byKey(_sleep),
        matching: find.byType(IgnorePointer),
      ),
      findsWidgets,
    );
    final before =
        tester
            .widgetList<Positioned>(
              find.descendant(
                of: find.byKey(_sleep),
                matching: find.byType(Positioned),
              ),
            )
            .map((widget) => widget.top)
            .toList();
    await tester.pump(const Duration(milliseconds: 400));
    final after =
        tester
            .widgetList<Positioned>(
              find.descendant(
                of: find.byKey(_sleep),
                matching: find.byType(Positioned),
              ),
            )
            .map((widget) => widget.top)
            .toList();
    expect(after, isNot(before));
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'movement, clicks, and wheel scrolling wake and reset the delay',
    (tester) async {
      var clicks = 0;
      var scrollSignals = 0;
      await tester.pumpWidget(
        _app(
          child: Listener(
            onPointerSignal: (_) => scrollSignals++,
            child: Center(
              child: TextButton(
                onPressed: () => clicks++,
                child: const Text('Tap me'),
              ),
            ),
          ),
        ),
      );
      final mouse = await _mouse(tester);
      await tester.pump(const Duration(seconds: 20));
      expect(find.byKey(_sleep), findsOneWidget);
      final button = tester.getCenter(find.text('Tap me'));
      await mouse.moveTo(button);
      await tester.pump();
      expect(find.byKey(_sleep), findsNothing);
      await tester.pump(const Duration(seconds: 19));
      expect(find.byKey(_sleep), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(_sleep), findsOneWidget);
      await mouse.down(button);
      await mouse.up();
      await tester.pump();
      expect(clicks, 1);
      expect(find.byKey(_sleep), findsNothing);
      expect(find.byKey(_burst), findsOneWidget);
      await tester.pump(const Duration(seconds: 20));
      expect(find.byKey(_sleep), findsOneWidget);
      tester.binding.handlePointerEvent(
        PointerScrollEvent(
          kind: PointerDeviceKind.mouse,
          position: button,
          scrollDelta: const Offset(0, 80),
        ),
      );
      await tester.pump();
      expect(scrollSignals, 1);
      expect(find.byKey(_sleep), findsNothing);
      await tester.pump(const Duration(seconds: 19));
      expect(find.byKey(_sleep), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(_sleep), findsOneWidget);
      await mouse.removePointer();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'keyboard, touch, and pointer exit cancel sleep until mouse returns',
    (tester) async {
      await tester.pumpWidget(_app());
      final mouse = await _mouse(tester);
      await tester.pump(const Duration(seconds: 20));
      expect(find.byKey(_sleep), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(find.byKey(_sleep), findsNothing);
      await tester.pump(const Duration(seconds: 25));
      expect(find.byKey(_sleep), findsNothing);
      await mouse.moveTo(const Offset(200, 150));
      await tester.pump(const Duration(seconds: 20));
      expect(find.byKey(_sleep), findsOneWidget);
      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(find.byKey(_sleep), findsNothing);
      await tester.pump(const Duration(seconds: 25));
      expect(find.byKey(_sleep), findsNothing);
      await mouse.moveTo(const Offset(250, 150));
      await tester.pump(const Duration(seconds: 20));
      expect(find.byKey(_sleep), findsOneWidget);
      await mouse.removePointer();
      await tester.pump();
      expect(find.byKey(_sleep), findsNothing);
      await tester.pump(const Duration(seconds: 25));
      expect(find.byKey(_sleep), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'reduced motion immediately cancels sleeping animation and timers',
    (tester) async {
      await tester.pumpWidget(_app());
      final mouse = await _mouse(tester);
      await tester.pump(const Duration(seconds: 20));
      expect(find.byKey(_sleep), findsOneWidget);
      await tester.pumpWidget(_app(reducedMotion: true));
      expect(find.byKey(_sleep), findsNothing);
      await mouse.moveTo(const Offset(250, 150));
      await tester.pump(const Duration(seconds: 25));
      expect(find.byKey(_sleep), findsNothing);
      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('leaving the application cancels both pending and active sleep', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    final mouse = await _mouse(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(seconds: 25));
    expect(find.byKey(_sleep), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await mouse.moveTo(const Offset(250, 150));
    await tester.pump(const Duration(seconds: 20));
    expect(find.byKey(_sleep), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byKey(_sleep), findsNothing);
    await tester.pump(const Duration(seconds: 25));
    expect(tester.binding.hasScheduledFrame, isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('holding or dragging a mouse button never counts as sleeping', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    final mouse = await _mouse(tester);
    await mouse.down(const Offset(120, 100));
    await tester.pump(const Duration(seconds: 25));
    expect(find.byKey(_sleep), findsNothing);
    await mouse.moveTo(const Offset(250, 150));
    await tester.pump(const Duration(seconds: 25));
    expect(find.byKey(_sleep), findsNothing);
    await mouse.up();
    await tester.pump(const Duration(seconds: 19));
    expect(find.byKey(_sleep), findsNothing);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(_sleep), findsOneWidget);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('sleep letters stay inside the viewport at each corner', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    final mouse = await _mouse(tester);
    for (final position in const [
      Offset(2, 2),
      Offset(798, 2),
      Offset(2, 598),
      Offset(798, 598),
    ]) {
      await mouse.moveTo(position);
      await tester.pump(const Duration(seconds: 20));
      final bounds = tester.getRect(find.byKey(_sleep));
      expect(bounds.left, greaterThanOrEqualTo(0));
      expect(bounds.top, greaterThanOrEqualTo(0));
      expect(bounds.right, lessThanOrEqualTo(800));
      expect(bounds.bottom, lessThanOrEqualTo(600));
    }
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('sleep animation does not rebuild portfolio content', (
    tester,
  ) async {
    var builds = 0;
    await tester.pumpWidget(
      _app(
        child: Builder(
          builder: (context) {
            builds++;
            return const ColoredBox(
              color: Colors.white,
              child: SizedBox.expand(),
            );
          },
        ),
      ),
    );
    final mouse = await _mouse(tester);
    final initialBuilds = builds;
    await tester.pump(const Duration(seconds: 20));
    for (var frame = 0; frame < 20; frame++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byKey(_sleep), findsOneWidget);
    expect(builds, initialBuilds);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
