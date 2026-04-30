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
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
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
        return 'Email/Password sign in is not enabled in Firebase console.';

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

      case 'account-exists-with-different-credential':
        return 'This email is already linked with another sign-in method.';

      case 'credential-already-in-use':
        return 'This credential is already associated with another account.';

      case 'user-token-expired':
        return 'Your session has expired. Please login again.';

      case 'invalid-user-token':
        return 'Authentication session is invalid. Please login again.';

      default:
        return 'Unexpected authentication error occurred. Please try again.';
    }
  }
}
