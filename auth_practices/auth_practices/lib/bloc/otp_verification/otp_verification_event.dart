import 'package:equatable/equatable.dart';

/// Base class for all OTP verification events
abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to verify OTP code
class VerifyOtpRequested extends OtpVerificationEvent {
  final String verificationId;
  final String otpCode;

  const VerifyOtpRequested({
    required this.verificationId,
    required this.otpCode,
  });

  @override
  List<Object?> get props => [verificationId, otpCode];
}

/// Event to reset OTP verification state
class ResetOtpVerificationState extends OtpVerificationEvent {
  const ResetOtpVerificationState();
}
