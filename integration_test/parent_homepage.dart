import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tamakan/Controller/authController.dart';

import 'package:tamakan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Parent View to test the rendering of the widgets',
      (tester) async {
    // Setup
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await app.main();
    int wait = 3;

    var user = AuthController();
    await user.login('ahmadbintariq4u@gmail.com', 'Ahmad121');

    // Do
    await tester.pumpAndSettle();
    final parentCenter1 = find.byKey(const Key('parent_center1'));
    final parentCenter2 = find.byKey(const Key('parent_center2'));
    final parentCenter3 = find.byKey(const Key('parent_center3'));

    await tester.pumpAndSettle();

    // Test
    await tester.pumpAndSettle();
    await tester.tap(parentCenter1);
    await tester.pumpAndSettle(Duration(seconds: wait));

    final text1 = find.text('integration test');
    expect(text1, findsOneWidget);
    await tester.tap(text1);

    await tester.pumpAndSettle(Duration(seconds: wait));
    Get.back();
    await tester.pumpAndSettle(Duration(seconds: wait));

    // Do
    Get.back();
    await tester.pumpAndSettle();
    await tester.tap(parentCenter2);
    await tester.pumpAndSettle(Duration(seconds: wait));

    final updateButton = find.byKey(const Key("UpdateButton"));
    await tester.tap(updateButton);
    await tester.pumpAndSettle(Duration(seconds: wait));
    Get.back();
    await tester.pumpAndSettle();

    final deleteButton = find.byKey(const Key("DeleteButton"));
    await tester.tap(deleteButton);
    await tester.pumpAndSettle(Duration(seconds: wait));
    Get.back();
    await tester.pumpAndSettle();

    // Do
    Get.back();
    await tester.pumpAndSettle();
    await tester.tap(parentCenter3);
    await tester.pumpAndSettle(Duration(seconds: wait));

    // Test
    // expect(find.text("ماذا تود أن تفعل اليوم؟"), findsOneWidget);
  });
}
