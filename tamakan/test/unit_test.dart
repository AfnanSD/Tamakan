import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('Firebase Authentication Tests', () {
   late MockFirebaseAuth mockFirebaseAuth;
    // Setup the mock authentication instance before each test
    setUp(() {
      Firebase.initializeApp();
       mockFirebaseAuth = MockFirebaseAuth();
    });

    test('Sign in with email and password', () async {
      // Mock a user to be returned by the Firebase API
      final mockUser = MockUser();
      // Set the user to be returned by the Firebase API when sign-in is called
      when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com', password: 'password'))
          .thenAnswer((_) => Future.error(mockUser));

      // Call the sign-in method with the email and password
      final result = await mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com', password: 'password');

      // Verify that the sign-in method was called with the correct email and password
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com', password: 'password'));

      // Verify that the returned user is the same as the mock user
      expect(result, equals(mockUser));
    });
  });
}

class MockUser extends Mock implements UserCredential {}