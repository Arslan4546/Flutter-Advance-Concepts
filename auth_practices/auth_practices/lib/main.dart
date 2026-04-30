import 'package:auth_practices/bloc/auth_bloc/auth_bloc.dart';
import 'package:auth_practices/bloc/auth_bloc/auth_event.dart';
import 'package:auth_practices/routes/app_routes.dart';
import 'package:auth_practices/data/repositories/auth_repo.dart';
import 'package:auth_practices/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AuthApp());
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(AuthRepo())..add(AuthCheckRequested()),
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        title: 'AuthFlow',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF43A047),
            secondary: const Color(0xFF1B5E20),
            surface: const Color(0xFF0A1628),
          ),
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
