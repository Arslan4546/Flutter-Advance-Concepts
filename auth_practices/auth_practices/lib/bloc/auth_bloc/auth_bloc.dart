import 'package:auth_practices/bloc/auth_bloc/auth_event.dart';
import 'package:auth_practices/bloc/auth_bloc/auth_state.dart';
import 'package:auth_practices/data/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLogin);
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

  Future<void> _onGoogleLogin(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final credential = await _authRepo.googleLogin();
      final user = credential.user;
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(
          const AuthError(message: 'Google login failed. Please try again.'),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _authRepo.mapFirebaseError(e.code)));
    } catch (e) {
      // Exception('google-login-cancelled') wغیرہ yahan aayenge
      final raw = e.toString().replaceFirst('Exception: ', '');
      final message = _authRepo.mapFirebaseError(raw);
      emit(AuthError(message: message));
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
