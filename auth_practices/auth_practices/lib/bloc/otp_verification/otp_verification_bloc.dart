import 'package:auth_practices/bloc/otp_verification/otp_verification_event.dart';
import 'package:auth_practices/bloc/otp_verification/otp_verification_state.dart';
import 'package:auth_practices/core/services/phone_auth_service.dart';
import 'package:auth_practices/core/utils/phone_auth_errors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for handling OTP verification
class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final PhoneAuthService _repository;

  OtpVerificationBloc({PhoneAuthService? repository})
    : _repository = repository ?? PhoneAuthService(),
      super(const OtpVerificationInitial()) {
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResetOtpVerificationState>(_onResetOtpVerificationState);
  }

  /// Handles the verify OTP request event
  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(const OtpVerificationLoading());

    try {
      final userCredential = await _repository.verifyOtp(
        verificationId: event.verificationId,
        otpCode: event.otpCode,
      );

      final userId = userCredential.user?.uid ?? '';
      emit(OtpVerificationSuccess(userId: userId));
    } on AuthFailure catch (failure) {
      emit(OtpVerificationError(message: failure.message, code: failure.code));
    } catch (e) {
      emit(OtpVerificationError(message: e.toString(), code: 'unknown'));
    }
  }

  /// Handles the reset OTP verification state event
  void _onResetOtpVerificationState(
    ResetOtpVerificationState event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(const OtpVerificationInitial());
  }
}

