import 'package:equatable/equatable.dart';

/// Base class for all phone authentication events
abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to send OTP to a phone number
class SendOtpRequested extends PhoneAuthEvent {
  final String phoneNumber;

  const SendOtpRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Event triggered when OTP is sent successfully
class OtpSentSuccess extends PhoneAuthEvent {
  final String verificationId;
  final int? resendToken;

  const OtpSentSuccess({required this.verificationId, this.resendToken});

  @override
  List<Object?> get props => [verificationId, resendToken];
}

/// Event triggered when verification is completed automatically
class AutoVerificationCompleted extends PhoneAuthEvent {
  const AutoVerificationCompleted();
}

/// Event triggered when verification fails
class VerificationFailed extends PhoneAuthEvent {
  final String errorMessage;
  final String? errorCode;

  const VerificationFailed({required this.errorMessage, this.errorCode});

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

/// Event to reset the authentication state
class ResetAuthState extends PhoneAuthEvent {
  const ResetAuthState();
}
