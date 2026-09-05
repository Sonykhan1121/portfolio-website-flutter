import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/widgets/screenshot_gallery.dart';

void main() {
  testWidgets('gallery arrows, swipe, viewer keyboard and resize work', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScreenshotGallery(
            screenshots: [
              ('Google Play', 'assets/images/projects/grozziie/play_01.webp'),
              ('App Store', 'assets/images/projects/grozziie/ios_01.jpg'),
              ('Google Play', 'assets/images/projects/grozziie/play_02.webp'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1–1 of 3'), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton &&
                  widget.tooltip == 'Previous screenshots',
            ),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.byTooltip('Next screenshots'));
    await tester.pumpAndSettle();
    expect(find.text('2–2 of 3'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-350, 0));
    await tester.pumpAndSettle();
    expect(find.text('3–3 of 3'), findsOneWidget);
    await tester.tap(find.byType(OutlinedButton).last);
    await tester.pumpAndSettle();
    expect(find.text('Grozziie · Google Play · 3/3'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('Grozziie · App Store · 2/3'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    tester.view.physicalSize = const Size(1000, 900);
    await tester.pumpAndSettle();
    expect(find.text('1–3 of 3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
