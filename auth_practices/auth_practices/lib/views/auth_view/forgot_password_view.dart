// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ForgotPasswordView extends StatefulWidget {
//   const ForgotPasswordView({super.key});

//   @override
//   State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
// }

// class _ForgotPasswordViewState extends State<ForgotPasswordView> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   void _onResetTapped() {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Remove focus from keyboard before request
//       FocusScope.of(context).unfocus();
      
//       context.read<AuthBloc>().add(
//         AuthPasswordResetRequested(
//           email: _emailController.text,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       // Only listen for specific reset states or errors
//       listenWhen: (previous, current) {
//         return current is AuthPasswordResetSuccess ||
//                current is AuthError && previous is AuthPasswordResetLoading;
//       },
//       listener: (context, state) async {
//         if (state is AuthPasswordResetSuccess) {
//           await FlushbarHelper.showSuccess(
//             context: context,
//             message: state.message,
//             title: 'Success',
//           );
//           if (context.mounted) {
//             Navigator.of(context).pop(); // Go back to login after success
//           }
//         } else if (state is AuthError) {
//           await FlushbarHelper.showError(
//             context: context,
//             message: state.message,
//             title: 'Reset Failed',
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         extendBodyBehindAppBar: true,
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0A1628)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 28),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   // Header icon
//                   Center(
//                     child: Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF1B5E20).withValues(alpha: 0.4),
//                             blurRadius: 20,
//                             spreadRadius: 3,
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.lock_reset_rounded,
//                         color: Colors.white,
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 36),
//                   const Text(
//                     'Reset\nPassword',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 36,
//                       fontWeight: FontWeight.w800,
//                       height: 1.2,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Enter your email address to receive a password reset link.',
//                     style: TextStyle(
//                       color: Colors.white.withValues(alpha: 0.5),
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 44),
//                   // Form
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           controller: _emailController,
//                           label: 'Email Address',
//                           hint: 'you@example.com',
//                           icon: Icons.email_outlined,
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
//                               return 'Enter a valid email address';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 40),
                        
//                         BlocBuilder<AuthBloc, AuthState>(
//                           builder: (context, state) {
//                             final isLoading = state is AuthPasswordResetLoading;

//                             return SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: DecoratedBox(
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [
//                                       Color(0xFF1B5E20),
//                                       Color(0xFF2E7D32),
//                                       Color(0xFF43A047),
//                                     ],
//                                     begin: Alignment.centerLeft,
//                                     end: Alignment.centerRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(16),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: const Color(0xFF1B5E20)
//                                           .withValues(alpha: 0.4),
//                                       blurRadius: 16,
//                                       offset: const Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: isLoading ? null : _onResetTapped,
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                   ),
//                                   child: isLoading
//                                       ? const SizedBox(
//                                           width: 24,
//                                           height: 24,
//                                           child: CircularProgressIndicator(
//                                             color: Colors.white,
//                                             strokeWidth: 2.5,
//                                           ),
//                                         )
//                                       : const Text(
//                                           'Send Reset Link',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.w700,
//                                             letterSpacing: 0.5,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
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
