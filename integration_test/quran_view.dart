import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tamakan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Quran View to test the rendering of the widgets',
      (tester) async {
    // Setup
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await app.main();
    await tester.pumpAndSettle();
    int wait = 3;

    // Do && Test
    // final mainText = find.text('القرآن الكريم');
    final mainText = find.byKey(Key('mainText'));

    expect(mainText, findsOneWidget);
    await tester.pumpAndSettle();

    // Do && Test
    // final secondaryText = find.text(
    //   'قصار السور',
    // );
    final secondaryText = find.byKey(Key('secondaryText'));
    // secondaryText
    expect(secondaryText, findsOneWidget);
    await tester.pumpAndSettle();

    final List<String> surahs = [
      'الفاتحة',
      'الإخلاص',
      'الفلق',
      "الناس",
      'الكوثر'
    ];
    for (var element in surahs) {
      final button = find.byKey(Key(element));
      expect(secondaryText, findsOneWidget);
      await tester.pumpAndSettle();

      await tester.tap(button);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final add1 = find.byKey(const Key('add1'));
      final add2 = find.byKey(const Key('add2'));
      expect(add1, findsOneWidget);
      expect(add2, findsOneWidget);

      await tester.tap(add1);
      await tester.pumpAndSettle();
      await tester.tap(add1);
      await tester.pumpAndSettle();
      await tester.tap(add2);
      await tester.pumpAndSettle();
      await tester.tap(add2);

      await tester.pumpAndSettle();
      Get.back();
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }
  });
}
