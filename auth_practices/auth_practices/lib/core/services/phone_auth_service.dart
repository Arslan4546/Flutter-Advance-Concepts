import 'package:auth_practices/core/utils/phone_auth_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Simple repository for authentication operations
/// Directly communicates with Firebase Auth
class PhoneAuthService {
  final FirebaseAuth _firebaseAuth;

  PhoneAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Sends OTP to the provided phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) onVerificationCompleted,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(AuthFailure) onVerificationFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: onVerificationCompleted,
        verificationFailed: (FirebaseAuthException e) {
          final failure = AuthFailure.fromFirebaseException(e.code, e.message);
          onVerificationFailed(failure);
        },
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (_) {},
        timeout: const Duration(seconds: 60),
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e.code, e.message);
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }

  /// Verifies the OTP code and signs in the user
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String otpCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e.code, e.message);
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }

  /// Signs in with phone auth credential
  Future<UserCredential> signInWithCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebaseException(e.code, e.message);
    } catch (e) {
      throw AuthFailure.unknown(e.toString());
    }
  }

  /// Gets the current authenticated user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthFailure.unknown('Failed to sign out: ${e.toString()}');
    }
  }
}
