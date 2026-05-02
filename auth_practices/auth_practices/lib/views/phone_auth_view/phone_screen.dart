import 'package:auth_practices/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:auth_practices/bloc/phone_auth/phone_auth_event.dart';
import 'package:auth_practices/bloc/phone_auth/phone_auth_state.dart';
import 'package:auth_practices/core/utils/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PhoneScreenView extends StatefulWidget {
  const PhoneScreenView({super.key});

  @override
  State<PhoneScreenView> createState() => _PhoneScreenViewState();
}

class _PhoneScreenViewState extends State<PhoneScreenView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+92';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinueTapped() {
    if (_formKey.currentState?.validate() ?? false) {
      final phoneNumber = _phoneController.text.trim();

      if (phoneNumber.isEmpty) {
        return;
      }

      if (phoneNumber.length < 10) {
        return;
      }

      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      final fullPhoneNumber = _selectedCountryCode + cleanPhone;

      context.read<PhoneAuthBloc>().add(
        SendOtpRequested(phoneNumber: fullPhoneNumber),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneAuthOtpSent) {
          context.go(
            '/otp-verification',
            extra: {
              'verificationId': state.verificationId,
              'phoneNumber':
                  _selectedCountryCode + _phoneController.text.trim(),
            },
          );
        } else if (state is PhoneAuthVerified) {
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
        } else if (state is PhoneAuthError) {
          FlushbarHelper.showError(
            context: context,
            message: state.message,
            title: 'Authentication Failed',
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0A1628)],
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
                    onTap: () => context.go('/login'),
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
                        Icons.phone_android_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Title
                  const Text(
                    'Phone\nVerification 📱',
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
                    'Enter your phone number to receive a verification code',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 44),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Label
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Phone number field with country code
                        BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
                          builder: (context, state) {
                            final hasError = state is PhoneAuthError;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Country code dropdown
                                    Container(
                                      height: 56,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedCountryCode,
                                          dropdownColor: const Color(
                                            0xFF0D2137,
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white54,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: '+92',
                                              child: Text('+92'),
                                            ),
                                            DropdownMenuItem(
                                              value: '+1',
                                              child: Text('+1'),
                                            ),
                                            DropdownMenuItem(
                                              value: '+44',
                                              child: Text('+44'),
                                            ),
                                            DropdownMenuItem(
                                              value: '+91',
                                              child: Text('+91'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedCountryCode = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Phone number field
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: hasError
                                                ? Colors.red.withValues(
                                                    alpha: 0.5,
                                                  )
                                                : Colors.white.withValues(
                                                    alpha: 0.1,
                                                  ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: Icon(
                                                Icons.phone_outlined,
                                                color: Colors.white54,
                                                size: 20,
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                controller: _phoneController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: '3001234567',
                                                  hintStyle: TextStyle(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.3),
                                                    fontSize: 16,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 16,
                                                      ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                    15,
                                                  ),
                                                ],
                                                validator: (v) {
                                                  if (v == null || v.isEmpty) {
                                                    return 'Please enter your phone number';
                                                  }
                                                  if (v.length < 10) {
                                                    return 'Phone number must be at least 10 digits';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Error message from Bloc state
                                if (hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      top: 8,
                                    ),
                                    child: Text(
                                      state.message,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        // Continue button
                        BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
                          builder: (context, state) {
                            final isLoading = state is PhoneAuthLoading;

                            return SizedBox(
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
                                      : _onContinueTapped,
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
                                          'Send OTP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        // Back to login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Want to use email?  ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Color(0xFF66BB6A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFF66BB6A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
