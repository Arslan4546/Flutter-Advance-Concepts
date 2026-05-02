import 'package:equatable/equatable.dart';

/// Base class for all OTP verification states
abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state before OTP verification
class OtpVerificationInitial extends OtpVerificationState {
  const OtpVerificationInitial();
}

/// State when OTP is being verified
class OtpVerificationLoading extends OtpVerificationState {
  const OtpVerificationLoading();
}

/// State when OTP verification is successful
class OtpVerificationSuccess extends OtpVerificationState {
  final String userId;

  const OtpVerificationSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// State when OTP verification fails
class OtpVerificationError extends OtpVerificationState {
  final String message;
  final String? code;

  const OtpVerificationError({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}
