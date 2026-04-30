import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check current auth state (used by SplashView on app start)
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Sign up with email + password
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Sign in with email + password
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Sign in / sign up with Google OAuth
class AuthGoogleSignInRequested extends AuthEvent {
  final bool isLogin;
  
  const AuthGoogleSignInRequested({this.isLogin = false});

  @override
  List<Object?> get props => [isLogin];
}

/// Sign out the current user
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Request a password reset email
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}
