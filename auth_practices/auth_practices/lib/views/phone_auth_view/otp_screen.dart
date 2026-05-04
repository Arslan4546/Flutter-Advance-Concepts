import 'dart:async';
import 'package:auth_practices/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:auth_practices/bloc/otp_verification/otp_verification_event.dart';
import 'package:auth_practices/bloc/otp_verification/otp_verification_state.dart';
import 'package:auth_practices/core/utils/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final OtpVerificationBloc _otpBloc;
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _otpBloc = OtpVerificationBloc();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpBloc.close();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  void _verifyOTP(String otp) {
    if (otp.length != 6) {
      FlushbarHelper.showError(
        context: context,
        message: 'Please enter complete 6-digit OTP',
        title: 'Incomplete OTP',
      );
      return;
    }

    _otpBloc.add(
      VerifyOtpRequested(verificationId: widget.verificationId, otpCode: otp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _otpBloc,
      child: BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            context.go('/home');
            Future.delayed(const Duration(milliseconds: 300), () {
              if (context.mounted) {
                FlushbarHelper.showSuccess(
                  context: context,
                  message: 'Welcome! You\'re signed in successfully 🎉',
                  title: 'Success',
                );
              }
            });
          } else if (state is OtpVerificationError) {
            FlushbarHelper.showError(
              context: context,
              message: state.message,
              title: 'Verification Failed',
            );
          }
        },
        builder: (context, state) {
          final hasError = state is OtpVerificationError;
          final isLoading = state is OtpVerificationLoading;

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0A1628),
                    Color(0xFF0D2137),
                    Color(0xFF0A1628),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Back button
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF1B5E20,
                                ).withValues(alpha: 0.4),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.sms_outlined,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      // Title
                      const Text(
                        'Enter\nVerification Code 🔐',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'We sent a 6-digit code to\n${widget.phoneNumber}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 44),
                      // OTP Input with Pinput
                      Center(
                        child: Pinput(
                          controller: _pinController,
                          focusNode: _focusNode,
                          length: 6,
                          enabled: !isLoading,
                          defaultPinTheme: PinTheme(
                            width: 52,
                            height: 56,
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: hasError
                                    ? Colors.red.withValues(alpha: 0.5)
                                    : Colors.white.withValues(alpha: 0.1),
                                width: 1.5,
                              ),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 52,
                            height: 56,
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: hasError
                                    ? Colors.red
                                    : const Color(0xFF43A047),
                                width: 2,
                              ),
                            ),
                          ),
                          errorPinTheme: PinTheme(
                            width: 52,
                            height: 56,
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                          ),
                          onCompleted: (pin) => _verifyOTP(pin),
                          onChanged: (value) {
                            // Clear error when user starts typing
                            if (hasError && value.isNotEmpty) {
                              setState(() {});
                            }
                          },
                          errorText: hasError ? state.message : null,
                          errorTextStyle: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1B5E20),
                                Color(0xFF2E7D32),
                                Color(0xFF43A047),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF1B5E20,
                                ).withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () => _verifyOTP(_pinController.text),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'Verify OTP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Resend OTP
                      Center(
                        child: _resendTimer > 0
                            ? Text(
                                'Resend OTP in $_resendTimer seconds',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _pinController.clear();
                                  _startResendTimer();
                                  // TODO: Implement resend OTP API call
                                },
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: Color(0xFF66BB6A),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF66BB6A),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
