import 'dart:async';
import 'package:auth_practices/bloc/auth_bloc/auth_event.dart';
import 'package:auth_practices/bloc/auth_bloc/auth_state.dart';
import 'package:auth_practices/data/repositories/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthPhoneSignInRequested>(_onPhoneSignInRequested);
    on<AuthOTPVerificationRequested>(_onOTPVerificationRequested);
    on<AuthResendOTPRequested>(_onResendOTPRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final user = _authRepo.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthEmailLoading());
    try {
      final user = await _authRepo.signUp(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Sign up failed. Please try again.'));
      }
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(message: message));
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthEmailLoading());
    try {
      final user = await _authRepo.signIn(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Sign in failed. Please try again.'));
      }
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(message: message));
    }
  }

  // ─── PHONE AUTHENTICATION HANDLERS ────────────────────────────
  Future<void> _onPhoneSignInRequested(
    AuthPhoneSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthPhoneLoading());

    try {
      final completer = Completer<void>();
      bool hasCompleted = false;

      final timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!hasCompleted) {
          hasCompleted = true;
          if (!completer.isCompleted) {
            completer.complete();
          }
          if (!emit.isDone) {
            emit(
              const AuthError(
                message:
                    'Phone verification timeout. Please check:\n'
                    '1. Phone Authentication is enabled in Firebase Console\n'
                    '2. Your phone number format is correct\n'
                    '3. You have internet connection',
              ),
            );
          }
        }
      });

      await _authRepo.sendOTP(
        phoneNumber: event.phoneNumber,
        onCodeSent: (verificationId) {
          if (!hasCompleted) {
            hasCompleted = true;
            timeoutTimer.cancel();
            if (!completer.isCompleted) {
              completer.complete();
            }
            if (!emit.isDone) {
              emit(
                AuthOTPSent(
                  verificationId: verificationId,
                  phoneNumber: event.phoneNumber,
                ),
              );
            }
          }
        },
        onError: (error) {
          if (!hasCompleted) {
            hasCompleted = true;
            timeoutTimer.cancel();
            if (!completer.isCompleted) {
              completer.complete();
            }
            if (!emit.isDone) {
              emit(AuthError(message: error));
            }
          }
        },
        onAutoVerified: (credential) {
          if (!hasCompleted) {
            hasCompleted = true;
            timeoutTimer.cancel();
            if (!completer.isCompleted) {
              completer.complete();
            }
            final user = credential.user;
            if (user != null && !emit.isDone) {
              emit(AuthAuthenticated(user: user));
            }
          }
        },
      );

      await completer.future;
      timeoutTimer.cancel();
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (!emit.isDone) {
        emit(AuthError(message: message));
      }
    }
  }

  Future<void> _onOTPVerificationRequested(
    AuthOTPVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthOTPVerifying());

    try {
      final credential = await _authRepo.verifyOTP(
        verificationId: event.verificationId,
        otp: event.otp,
      );

      final user = credential.user;
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(
          const AuthError(message: 'Verification failed. Please try again.'),
        );
      }
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(message: message));
    }
  }

  Future<void> _onResendOTPRequested(
    AuthResendOTPRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthPhoneLoading());

    try {
      final completer = Completer<void>();
      bool hasCompleted = false;

      final timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!hasCompleted) {
          hasCompleted = true;
          if (!completer.isCompleted) {
            completer.complete();
          }
          if (!emit.isDone) {
            emit(
              const AuthError(message: 'Resend OTP timeout. Please try again.'),
            );
          }
        }
      });

      await _authRepo.resendOTP(
        phoneNumber: event.phoneNumber,
        onCodeSent: (verificationId) {
          if (!hasCompleted) {
            hasCompleted = true;
            timeoutTimer.cancel();
            if (!completer.isCompleted) {
              completer.complete();
            }
            if (!emit.isDone) {
              emit(
                AuthOTPSent(
                  verificationId: verificationId,
                  phoneNumber: event.phoneNumber,
                ),
              );
            }
          }
        },
        onError: (error) {
          if (!hasCompleted) {
            hasCompleted = true;
            timeoutTimer.cancel();
            if (!completer.isCompleted) {
              completer.complete();
            }
            if (!emit.isDone) {
              emit(AuthError(message: error));
            }
          }
        },
      );

      await completer.future;
      timeoutTimer.cancel();
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (!emit.isDone) {
        emit(AuthError(message: message));
      }
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepo.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(AuthError(message: message));
    }
  }
}
