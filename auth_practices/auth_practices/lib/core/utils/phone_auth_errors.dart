import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  factory AuthFailure.invalidPhoneNumber() {
    return const AuthFailure(
      message: 'Please enter a valid phone number',
      code: 'invalid-phone-number',
    );
  }

  factory AuthFailure.invalidVerificationCode() {
    return const AuthFailure(
      message: 'Wrong OTP! Please check and try again.',
      code: 'invalid-verification-code',
    );
  }

  factory AuthFailure.sessionExpired() {
    return const AuthFailure(
      message: 'OTP expired. Please request a new one.',
      code: 'session-expired',
    );
  }

  factory AuthFailure.tooManyRequests() {
    return const AuthFailure(
      message: 'Too many requests. Please try again later.',
      code: 'too-many-requests',
    );
  }

  factory AuthFailure.networkError() {
    return const AuthFailure(
      message: 'Network error. Please check your connection.',
      code: 'network-error',
    );
  }

  factory AuthFailure.quotaExceeded() {
    return const AuthFailure(
      message: 'SMS quota exceeded. Please try again later.',
      code: 'quota-exceeded',
    );
  }

  factory AuthFailure.invalidAppCredential() {
    return const AuthFailure(
      message: 'Invalid app credential. Please contact support.',
      code: 'invalid-app-credential',
    );
  }

  factory AuthFailure.userDisabled() {
    return const AuthFailure(
      message: 'This account has been disabled.',
      code: 'user-disabled',
    );
  }

  factory AuthFailure.operationNotAllowed() {
    return const AuthFailure(
      message: 'Phone authentication is not enabled.',
      code: 'operation-not-allowed',
    );
  }

  factory AuthFailure.unknown(String message) {
    return AuthFailure(
      message: message.isEmpty ? 'An unknown error occurred' : message,
      code: 'unknown',
    );
  }

  factory AuthFailure.fromFirebaseException(String code, String? message) {
    switch (code) {
      case 'invalid-phone-number':
        return AuthFailure.invalidPhoneNumber();
      case 'invalid-verification-code':
        return AuthFailure.invalidVerificationCode();
      case 'session-expired':
        return AuthFailure.sessionExpired();
      case 'too-many-requests':
        return AuthFailure.tooManyRequests();
      case 'network-request-failed':
        return AuthFailure.networkError();
      case 'quota-exceeded':
        return AuthFailure.quotaExceeded();
      case 'invalid-app-credential':
        return AuthFailure.invalidAppCredential();
      case 'user-disabled':
        return AuthFailure.userDisabled();
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed();
      default:
        return AuthFailure.unknown(message ?? 'Verification failed');
    }
  }
}

/// Server related failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Cache related failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}
