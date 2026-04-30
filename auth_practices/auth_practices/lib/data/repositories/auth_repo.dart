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
      if (e.code == 'user-not-found') {
        throw Exception('User not registered. Please sign up first.');
      }

      if (e.code == 'wrong-password') {
        throw Exception(
          'Incorrect password. If you registered with Google, use Google sign in.',
        );
      }

      if (e.code == 'invalid-credential') {
        throw Exception(
          'Invalid credentials. If not registered, please sign up.',
        );
      }

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
      case 'email-already-in-use':
        return 'This user is already registered. Please login.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'account-exists-with-different-credential':
        return 'This email is linked with a different sign in method.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Unexpected error occurred. Please try again.';
    }
  }
}
