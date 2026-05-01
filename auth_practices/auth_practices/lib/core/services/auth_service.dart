import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ─── GOOGLE SIGN IN ───────────────────────────────────────────
  Future<UserCredential> loginWithGoogle() async {
    try {
      // Sign out first to force account picker every time
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the picker
        throw Exception('google-login-cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        print('idToken: ${googleAuth.idToken}');
        print('accessToken: ${googleAuth.accessToken}');
        throw Exception('google-login-failed');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow; // Let bloc handle Firebase errors
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('google-login-cancelled')) {
        throw Exception('google-login-cancelled');
      }
      throw Exception('google-login-failed');
    }
  }

  Future<UserCredential> signUpWithGoogle() async {
    return await loginWithGoogle();
  }

  Future<void> signOut() async {
    await Future.wait([_googleSignIn.signOut(), _firebaseAuth.signOut()]);
  }
}
