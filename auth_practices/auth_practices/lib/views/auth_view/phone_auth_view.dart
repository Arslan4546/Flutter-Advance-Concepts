// import 'package:auth_practices/bloc/auth_bloc/auth_bloc.dart';
// import 'package:auth_practices/bloc/auth_bloc/auth_event.dart';
// import 'package:auth_practices/bloc/auth_bloc/auth_state.dart';
// import 'package:auth_practices/core/utils/flushbar_helper.dart';
// import 'package:auth_practices/views/auth_view/otp_verification_view.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PhoneAuthView extends StatefulWidget {
//   const PhoneAuthView({super.key});

//   @override
//   State<PhoneAuthView> createState() => _PhoneAuthViewState();
// }

// class _PhoneAuthViewState extends State<PhoneAuthView> {
//   final TextEditingController _phoneController = TextEditingController();

//   void _sendCode() {
//     final phone = _phoneController.text.trim();
//     if (phone.isEmpty) return;

//     context.read<AuthBloc>().add(AuthPhoneCodeRequested(phoneNumber: phone));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthCodeSent) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => OtpVerificationView(
//                 verificationId: state.verificationId,
//                 phoneNumber: _phoneController.text.trim(),
//               ),
//             ),
//           );
//         }

//         if (state is AuthError) {
//           await FlushbarHelper.showError(
//             context: context,
//             message: state.message,
//             title: 'Phone Auth Failed',
//           );
//         }
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: const Color(0xFF0A1628),
//         appBar: AppBar(backgroundColor: Colors.transparent),
//         body: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               const SizedBox(height: 80),
//               const Icon(
//                 Icons.phone_android,
//                 size: 70,
//                 color: Color(0xFF66BB6A),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Phone Verification',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Enter your phone number to receive OTP',
//                 style: TextStyle(color: Colors.white54),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   hintText: '+923001234567',
//                   hintStyle: const TextStyle(color: Colors.white38),
//                   filled: true,
//                   fillColor: const Color(0xFF132238),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               BlocBuilder<AuthBloc, AuthState>(
//                 builder: (context, state) {
//                   return SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed: state is AuthPhoneLoading ? null : _sendCode,
//                       child: state is AuthPhoneLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text('Get Code'),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
