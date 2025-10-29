import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/app_theme.dart';
import 'package:studysquare/features/auth/presentation/pages/admin_login.dart';
import 'package:studysquare/features/auth/presentation/pages/forgot_pass_screen.dart';
import 'package:studysquare/features/auth/presentation/pages/splash_screen.dart';
import 'package:studysquare/features/auth/presentation/pages/verify_email_screen.dart';
import 'package:studysquare/features/auth/presentation/provider/auth_provider.dart';
import 'package:studysquare/features/home/presentation/pages/home.dart';
import 'package:studysquare/features/profile/presentation/pages/onboarding.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';
import 'package:studysquare/features/programs/data/repositories/enrollment_repository.dart';
import 'package:studysquare/features/programs/presentation/provider/enrollment_provider.dart';
import 'package:studysquare/features/programs/presentation/provider/program_admin_provider.dart';
import 'package:studysquare/features/user/presentation/pages/landing_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              EnrollmentProvider(EnrollmentRepository())
                ..onAuthChanged('demo_user'), // Initialize with a demo user
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ProgramAdminProvider()
                ..onAuthChanged('demo_user'), // Initialize with a demo user
        ),
      ],
      child: Consumer2<AuthProvider, ProfileProvider>(
        builder: (context, auth, profile, _) {
          return MaterialApp(
            title: 'StudySquare',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/register': (context) => const LandingPage(),
              '/login': (context) => const LandingPage(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/verify-email': (context) => const VerifyEmailScreen(),
              '/home': (context) => const HomePage(),
              '/admin-login': (context) => const AdminLogin(),
              '/landing': (context) => const LandingPage(),
              '/onboarding': (context) => const OnboardingScreen(),
            },
            home: auth.isLoading
                ? const SplashScreen()
                : auth.isAuthenticated
                ? FutureBuilder<bool>(
                    future: profile.isOnboardingComplete(auth.user?.uid ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print(auth.user?.uid);
                        return const SplashScreen();
                      }
                      return snapshot.data == true
                          ? const HomePage()
                          : const OnboardingScreen();
                    },
                  )
                : const LandingPage(),
          );
        },
      ),
    );
  }
}
