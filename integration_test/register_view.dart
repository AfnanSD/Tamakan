import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tamakan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register View to test the rendering of the widgets',
      (tester) async {
    // Setup
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    app.main();
    await tester.pumpAndSettle();
    int wait = 3;

    // Do
    final nameField = find.byKey(const Key('nameField'));
    final genderDropdown = find.byKey(const Key('genderDropdown'));
    final dateField = find.byKey(const Key('dateField'));
    final emailField = find.byKey(const Key('emailField'));
    final passwordField = find.byKey(const Key('passwordField'));
    final password2Field = find.byKey(const Key('password2Field'));
    final registerView = find.byKey(const Key("registerScrollView"));

    // Login credentials
    await tester.tap(nameField);
    await tester.enterText(nameField, "name");
    await tester.pumpAndSettle();
    await tester.drag(registerView, const Offset(0.0, 100.0));

    await tester.tap(emailField);
    await tester.enterText(emailField, 'testingEmail@gmail.com');
    await tester.pumpAndSettle();

    await tester.drag(registerView, const Offset(0.0, 100.0));
    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'passwrod');
    await tester.pumpAndSettle();

    await tester.drag(registerView, const Offset(0.0, 100.0));

    await tester.tap(password2Field);
    await tester.enterText(password2Field, 'passwrod');

    // Test
    // expect(find.text('إنشاء حساب'), findsOneWidget);
  });
}
