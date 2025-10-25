import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/app_theme.dart';
import 'package:studysquare/features/auth/presentation/pages/forgot_pass_screen.dart';
import 'package:studysquare/features/auth/presentation/pages/login_screen.dart';
import 'package:studysquare/features/auth/presentation/pages/signup_screen.dart';
import 'package:studysquare/features/auth/presentation/pages/splash_screen.dart';
import 'package:studysquare/features/auth/presentation/pages/verify_email_screen.dart';
import 'package:studysquare/features/auth/presentation/pages/welcome_screen.dart';
import 'package:studysquare/features/auth/presentation/provider/auth_provider.dart';
import 'package:studysquare/features/home/presentation/pages/home.dart';
import 'package:studysquare/features/user/presentation/pages/registrationpage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(create: (_) => AuthProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySquare',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegistrationPage(),
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/verify-email': (context) => const VerifyEmailScreen(),
        '/home': (context) => const HomePage(),
        '/signup': (context) => const SignUpScreen(),
      },
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const SplashScreen();
          }
          return auth.isAuthenticated
              ? const HomePage()
              : const WelcomeScreen();
        },
      ),
    );
  }
}
