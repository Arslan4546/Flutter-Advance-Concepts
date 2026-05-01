import 'package:auth_practices/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  AuthRepo._();

  static final AuthRepo _instance = AuthRepo._();

  factory AuthRepo() => _instance;

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
      throw Exception(mapFirebaseError(e.code));
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
      throw Exception(mapFirebaseError(e.code));
    }
  }

  Future<UserCredential> googleLogin() async {
    return await _authService.loginWithGoogle();
  }

  Future<UserCredential> googleSignUp() async {
    return await _authService.signUpWithGoogle();
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseError(e.code));
    }
  }

  String mapFirebaseError(String code) {
    switch (code) {
      // =========================================================
      // EMAIL / PASSWORD SIGNUP + LOGIN ERRORS
      // =========================================================

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'missing-email':
        return 'Email address is required.';

      case 'missing-password':
        return 'Password is required.';

      case 'email-already-in-use':
        return 'An account already exists with this email. Please login instead.';

      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';

      case 'operation-not-allowed':
        return 'This sign-in method is not enabled right now.';

      case 'user-not-found':
        return 'No account found with this email address.';

      case 'wrong-password':
        return 'Incorrect password. Please try again.';

      case 'invalid-credential':
        return 'Email or password is incorrect.';

      case 'user-disabled':
        return 'This user account has been disabled. Contact support.';

      case 'too-many-requests':
        return 'Too many attempts detected. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      case 'timeout':
        return 'Request timed out. Please try again.';

      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';

      case 'user-token-expired':
        return 'Your session has expired. Please login again.';

      case 'invalid-user-token':
        return 'Authentication session is invalid. Please login again.';

      // =========================================================
      // GOOGLE LOGIN CUSTOM BUSINESS ERRORS
      // =========================================================

      case 'google-password-conflict':
        return 'This email is registered with email/password. Kindly login using password.';

      case 'google-login-cancelled':
        return 'Google sign in was cancelled by user.';

      case 'google-login-failed':
        return 'Unable to login with Google right now. Please try again.';

      case 'google-account-not-found':
        return 'No Google account found. Please sign up first.';

      // =========================================================
      // GOOGLE SIGNUP CUSTOM BUSINESS ERRORS
      // =========================================================

      case 'google-already-used':
        return 'This Google account is already registered. Please login instead.';

      case 'google-signup-cancelled':
        return 'Google sign up was cancelled by user.';

      case 'google-signup-failed':
        return 'Unable to sign up with Google right now. Please try again.';

      // =========================================================
      // GOOGLE / FIREBASE PROVIDER CONFLICT ERRORS
      // =========================================================

      case 'account-exists-with-different-credential':
        return 'This email is already linked with another sign-in provider.';

      case 'popup-closed-by-user':
        return 'Google authentication was cancelled.';

      case 'popup-blocked':
        return 'Google authentication popup was blocked. Please allow popups and try again.';

      case 'invalid-verification-code':
        return 'Google verification failed. Please try again.';

      case 'invalid-verification-id':
        return 'Google authentication session is invalid.';

      case 'provider-already-linked':
        return 'This Google account is already linked with this user.';

      case 'requires-recent-login':
        return 'Please login again to continue this action.';

      // =========================================================
      // DEFAULT FALLBACK
      // =========================================================

      default:
        return 'Unexpected authentication error occurred. Please try again.';
    }
  }
}
