import 'package:equatable/equatable.dart';

/// Base class for all phone authentication states
abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any authentication action
class PhoneAuthInitial extends PhoneAuthState {
  const PhoneAuthInitial();
}

/// State when OTP is being sent
class PhoneAuthLoading extends PhoneAuthState {
  const PhoneAuthLoading();
}

/// State when OTP is sent successfully
class PhoneAuthOtpSent extends PhoneAuthState {
  final String verificationId;
  final int? resendToken;

  const PhoneAuthOtpSent({required this.verificationId, this.resendToken});

  @override
  List<Object?> get props => [verificationId, resendToken];
}

/// State when verification is completed automatically (Android only)
class PhoneAuthVerified extends PhoneAuthState {
  const PhoneAuthVerified();
}

/// State when authentication fails
class PhoneAuthError extends PhoneAuthState {
  final String message;
  final String? code;

  const PhoneAuthError({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
