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
        return 'This email is already registered. Please login instead.';

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
      // PHONE AUTHENTICATION ERRORS
      // =========================================================

      case 'invalid-phone-number':
        return 'Invalid phone number format. Please check and try again.';

      case 'missing-phone-number':
        return 'Phone number is required.';

      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';

      case 'invalid-verification-code':
        return 'Invalid OTP code. Please check and try again.';

      case 'invalid-verification-id':
        return 'Verification session expired. Please request a new OTP.';

      case 'session-expired':
        return 'OTP session expired. Please request a new code.';

      case 'captcha-check-failed':
        return 'reCAPTCHA verification failed. Please try again.';

      case 'missing-client-identifier':
        return 'App configuration error. Please contact support.';

      case 'app-not-authorized':
        return 'This app is not authorized for phone authentication. '
            'Please ensure:\n'
            '1. Phone Authentication is enabled in Firebase Console\n'
            '2. SHA-1/SHA-256 keys are added to Firebase project\n'
            '3. google-services.json is up to date';

      case 'api-key-not-valid':
        return 'Invalid API key. Please check Firebase configuration.';

      case 'web-context-cancelled':
        return 'Phone verification was cancelled.';

      case 'web-context-already-presented':
        return 'Phone verification is already in progress.';

      case 'phone-verification-failed':
        return 'Phone verification failed. Please try again.';

      case 'auto-verification-failed':
        return 'Auto-verification failed. Please enter OTP manually.';

      // =========================================================
      // DEFAULT FALLBACK
      // =========================================================

      default:
        return 'Unexpected authentication error occurred. Please try again.';
    }
  }
}
