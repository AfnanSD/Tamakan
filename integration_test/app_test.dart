import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tamakan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Access login through correct credentials', (tester) async {
    // Setup
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await app.main();
    await tester.pumpAndSettle();
    int wait = 3;

    // Do
    final loginEmail = find.byKey(const Key('loginEmail'));
    final loginPassword = find.byKey(const Key('loginPassword'));

    final loginSignInButton = find.byKey(const Key('loginSignInButton'));

    // Login credentials
    await tester.tap(loginEmail);
    await tester.enterText(loginEmail, "ahmadbintariq4u@gmail.com");
    await tester.pumpAndSettle();

    await tester.tap(loginPassword);
    await tester.enterText(loginPassword, 'Ahmad121');
    await tester.pumpAndSettle();
    await tester.tap(loginSignInButton);
    await tester.pumpAndSettle(Duration(seconds: wait));
    // Test
    expect(find.text('integration test'), findsOneWidget);
  });
}
