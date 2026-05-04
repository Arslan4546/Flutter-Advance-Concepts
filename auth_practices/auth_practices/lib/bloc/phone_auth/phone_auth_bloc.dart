import 'package:auth_practices/bloc/phone_auth/phone_auth_event.dart';
import 'package:auth_practices/bloc/phone_auth/phone_auth_state.dart';
import 'package:auth_practices/core/services/phone_auth_service.dart';
import 'package:auth_practices/core/utils/phone_auth_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC for handling phone authentication (sending OTP)
class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthService _repository;

  PhoneAuthBloc({PhoneAuthService? repository})
    : _repository = repository ?? PhoneAuthService(),
      super(const PhoneAuthInitial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<OtpSentSuccess>(_onOtpSentSuccess);
    on<AutoVerificationCompleted>(_onAutoVerificationCompleted);
    on<VerificationFailed>(_onVerificationFailed);
    on<ResetAuthState>(_onResetAuthState);
  }

  /// Handles the send OTP request event
  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<PhoneAuthState> emit,
  ) async {
    emit(const PhoneAuthLoading());

    try {
      // Format phone number with Pakistan country code
      final formattedPhone = _formatPhoneNumber(event.phoneNumber);

      await _repository.sendOtp(
        phoneNumber: formattedPhone,
        onVerificationCompleted: (PhoneAuthCredential credential) {
          add(const AutoVerificationCompleted());
        },
        onCodeSent: (String verificationId, int? resendToken) {
          add(
            OtpSentSuccess(
              verificationId: verificationId,
              resendToken: resendToken,
            ),
          );
        },
        onVerificationFailed: (AuthFailure failure) {
          add(
            VerificationFailed(
              errorMessage: failure.message,
              errorCode: failure.code,
            ),
          );
        },
      );
    } on AuthFailure catch (failure) {
      emit(PhoneAuthError(message: failure.message, code: failure.code));
    } catch (e) {
      emit(PhoneAuthError(message: e.toString(), code: 'unknown'));
    }
  }

  /// Handles the OTP sent success event
  void _onOtpSentSuccess(OtpSentSuccess event, Emitter<PhoneAuthState> emit) {
    emit(
      PhoneAuthOtpSent(
        verificationId: event.verificationId,
        resendToken: event.resendToken,
      ),
    );
  }

  /// Handles the auto verification completed event
  void _onAutoVerificationCompleted(
    AutoVerificationCompleted event,
    Emitter<PhoneAuthState> emit,
  ) {
    emit(const PhoneAuthVerified());
  }

  /// Handles the verification failed event
  void _onVerificationFailed(
    VerificationFailed event,
    Emitter<PhoneAuthState> emit,
  ) {
    emit(PhoneAuthError(message: event.errorMessage, code: event.errorCode));
  }

  /// Handles the reset auth state event
  void _onResetAuthState(ResetAuthState event, Emitter<PhoneAuthState> emit) {
    emit(const PhoneAuthInitial());
  }

  /// Formats phone number with country code
  String _formatPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.startsWith('92') && cleanNumber.length == 12) {
      return '+$cleanNumber';
    }

    return '+92$cleanNumber';
  }
}

