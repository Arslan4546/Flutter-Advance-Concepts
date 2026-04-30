import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any check
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Auth operation in progress for splash/sign-out (no active button on screen)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Email/password sign-in or sign-up in progress
class AuthEmailLoading extends AuthState {
  const AuthEmailLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user.uid];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
