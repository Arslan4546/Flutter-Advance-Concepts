import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

// ─── PHONE AUTHENTICATION EVENTS ──────────────────────────────────
class AuthPhoneSignInRequested extends AuthEvent {
  final String phoneNumber;

  const AuthPhoneSignInRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthOTPVerificationRequested extends AuthEvent {
  final String verificationId;
  final String otp;

  const AuthOTPVerificationRequested({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [verificationId, otp];
}

class AuthResendOTPRequested extends AuthEvent {
  final String phoneNumber;

  const AuthResendOTPRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}
