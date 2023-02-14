import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tamakan/Controller/authController.dart';

import 'package:tamakan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Children  View to test the rendering of the widgets',
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
    await tester.pumpAndSettle();

    // Test
    await tester.pumpAndSettle();
    await tester.tap(parentCenter1);
    await tester.pumpAndSettle(Duration(seconds: wait));

    // Do
    final text1 = find.text('integration test');

    // Test
    expect(text1, findsOneWidget);
    await tester.tap(text1);
    await tester.pumpAndSettle();

    // Do
    final childScroll = find.byKey(const Key('childScroll'));
    await tester.drag(childScroll, const Offset(100.0, 0.0));
    await tester.pumpAndSettle();

    final hazelNut = find.byKey(const Key('hazelnut'));
    final tree = find.byKey(const Key('tree'));
    await tester.pumpAndSettle();
    await tester.tap(tree);
    await tester.pumpAndSettle();

    await tester.tap(hazelNut);
    await tester.pumpAndSettle(Duration(seconds: wait));

    final levelScroll = find.byKey(const Key('levels'));
    expect(levelScroll, findsOneWidget);
    await tester.pumpAndSettle();
    await tester.drag(levelScroll, const Offset(0, 150.0));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle(Duration(seconds: wait));

    // Test
    // expect(find.text("ماذا تود أن تفعل اليوم؟"), findsOneWidget);
  });
}
