import 'package:auth_practices/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final AuthService _authService = AuthService();

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signUp(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signIn(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // If Email Enumeration Protection is off, we get specific errors:
      if (e.code == 'user-not-found') {
        throw Exception('User not registered. Please sign up first.');
      }
      if (e.code == 'wrong-password') {
        throw Exception(
          'Incorrect password. If you registered with Google, '
          'please sign in using Google.',
        );
      }
      // If EEP is on, we get "invalid-credential" for both missing users and wrong passwords.
      if (e.code == 'invalid-credential') {
        throw Exception(
          'Invalid credentials. If you are not registered, please sign up. '
          'If you registered with Google, please sign in using Google.',
        );
      }
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  /// Returns null if the user cancelled the Google account picker.
  Future<User?> signInWithGoogle({bool isLogin = false}) async {
    try {
      final googleAccount = await _authService.getGoogleAccount();
      if (googleAccount == null) return null; // User cancelled

      final credential = await _authService.signInWithGoogleAccount(
        googleAccount,
      );
      final user = credential?.user;

      // Ensure that a user registered with Email/Password cannot login with Google
      // We explicitly reload the user to ensure providerData is fully refreshed from Firebase
      await user?.reload();
      final freshUser = FirebaseAuth.instance.currentUser;
      final hasPasswordProvider =
          freshUser?.providerData.any((p) => p.providerId == 'password') ??
          false;

      if (hasPasswordProvider) {
        await _authService.signOut();
        throw Exception(
          'This email is registered with email & password. '
          'Please sign in using your email.',
        );
      }

      // Prevent unregistered users from logging in via Google
      if (isLogin && credential?.additionalUserInfo?.isNewUser == true) {
        await user?.delete(); // Delete the mistakenly created account
        await _authService.signOut();
        throw Exception('User not registered. Please sign up first.');
      }

      // Prevent already registered users from signing up again via Google
      if (!isLogin && credential?.additionalUserInfo?.isNewUser == false) {
        await _authService.signOut(); // Log them out immediately
        throw Exception('This user is already register please login');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception(
          'This email is registered with email & password. '
          'Please sign in using your email and password.',
        );
      }
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('network_error') ||
          msg.contains('network-request-failed')) {
        throw Exception('Network error. Check your internet connection.');
      }
      throw Exception('Google sign-in failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User not registered. Please sign up first.');
      }
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This user is already register please login';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'account-exists-with-different-credential':
        return 'This email is linked to a different sign-in method. '
            'Please use the correct sign-in option.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
