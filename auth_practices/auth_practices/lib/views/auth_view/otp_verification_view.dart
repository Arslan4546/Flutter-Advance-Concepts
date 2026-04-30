// import 'package:auth_practices/bloc/auth_bloc/auth_bloc.dart';
// import 'package:auth_practices/bloc/auth_bloc/auth_event.dart';
// import 'package:auth_practices/bloc/auth_bloc/auth_state.dart';
// import 'package:auth_practices/core/utils/flushbar_helper.dart';
// import 'package:auth_practices/views/home_view/home_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class OtpVerificationView extends StatefulWidget {
//   final String verificationId;
//   final String phoneNumber;

//   const OtpVerificationView({
//     super.key,
//     required this.verificationId,
//     required this.phoneNumber,
//   });

//   @override
//   State<OtpVerificationView> createState() => _OtpVerificationViewState();
// }

// class _OtpVerificationViewState extends State<OtpVerificationView> {
//   final TextEditingController _otpController = TextEditingController();

//   @override
//   void dispose() {
//     _otpController.dispose();
//     super.dispose();
//   }

//   void _verifyOtp() {
//     final otp = _otpController.text.trim();

//     if (otp.isEmpty || otp.length < 6) {
//       FlushbarHelper.showError(
//         context: context,
//         message: 'Please enter a valid 6-digit OTP code.',
//         title: 'Invalid OTP',
//       );
//       return;
//     }

//     context.read<AuthBloc>().add(
//       AuthOtpVerifyRequested(
//         verificationId: widget.verificationId,
//         smsCode: otp,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthAuthenticated) {
//           if (context.mounted) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => const HomeView()),
//               (_) => false,
//             );
//           }
//         }

//         if (state is AuthError) {
//           await FlushbarHelper.showError(
//             context: context,
//             message: state.message,
//             title: 'OTP Verification Failed',
//           );
//         }
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0A1628)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 28),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 25),

//                   IconButton(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                   ),

//                   const SizedBox(height: 30),

//                   Center(
//                     child: Container(
//                       width: 85,
//                       height: 85,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(
//                               0xFF1B5E20,
//                             ).withValues(alpha: 0.4),
//                             blurRadius: 20,
//                             spreadRadius: 3,
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.sms_outlined,
//                         color: Colors.white,
//                         size: 38,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 35),

//                   const Text(
//                     'OTP\nVerification 🔐',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 34,
//                       fontWeight: FontWeight.w800,
//                       height: 1.2,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   Text(
//                     'Enter the 6-digit verification code sent to\n${widget.phoneNumber}',
//                     style: TextStyle(
//                       color: Colors.white.withValues(alpha: 0.55),
//                       fontSize: 15,
//                       height: 1.4,
//                     ),
//                   ),

//                   const SizedBox(height: 45),

//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF132238),
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     child: TextField(
//                       controller: _otpController,
//                       keyboardType: TextInputType.number,
//                       maxLength: 6,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         letterSpacing: 8,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         counterText: '',
//                         hintText: '••••••',
//                         hintStyle: TextStyle(
//                           color: Colors.white.withValues(alpha: 0.25),
//                           letterSpacing: 8,
//                         ),
//                         prefixIcon: const Icon(
//                           Icons.lock_outline,
//                           color: Colors.white54,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 22,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   BlocBuilder<AuthBloc, AuthState>(
//                     builder: (context, state) {
//                       final isLoading = state is AuthPhoneLoading;

//                       return SizedBox(
//                         width: double.infinity,
//                         height: 56,
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Color(0xFF1B5E20),
//                                 Color(0xFF2E7D32),
//                                 Color(0xFF43A047),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(
//                                   0xFF1B5E20,
//                                 ).withValues(alpha: 0.4),
//                                 blurRadius: 16,
//                                 offset: const Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: ElevatedButton(
//                             onPressed: isLoading ? null : _verifyOtp,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             ),
//                             child: isLoading
//                                 ? const SizedBox(
//                                     width: 24,
//                                     height: 24,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2.4,
//                                     ),
//                                   )
//                                 : const Text(
//                                     'Verify OTP',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w700,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 24),

//                   Center(
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         'Wrong number? Change Phone Number',
//                         style: TextStyle(
//                           color: Color(0xFF66BB6A),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
