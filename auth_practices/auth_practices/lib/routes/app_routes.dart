import 'package:auth_practices/views/auth_view/login_view.dart';
import 'package:auth_practices/views/auth_view/signup_view.dart';
import 'package:auth_practices/views/phone_auth_view/phone_screen.dart';
import 'package:auth_practices/views/phone_auth_view/otp_screen.dart';
import 'package:auth_practices/views/splash_view/splash_view.dart';
import 'package:auth_practices/views/home_view/home_view.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashView()),
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
    GoRoute(
      path: '/phone-auth',
      builder: (context, state) => const PhoneScreenView(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final verificationId = extra?['verificationId'] as String? ?? '';
        final phoneNumber = extra?['phoneNumber'] as String? ?? '';

        return OtpScreen(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
        );
      },
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeView()),
  ],
);
