import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/app_theme.dart';
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // FIX: Make ProfileProvider listen to AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (context) => ProfileProvider(null), // Create with null auth
          update: (context, auth, previousProfile) {
            // This 'update' function is called whenever AuthProvider notifies listeners
            if (previousProfile == null) return ProfileProvider(auth);
            previousProfile.updateAuth(auth); // Pass the new auth state in
            return previousProfile;
          },
        ),

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
      child: Consumer<AuthProvider>(
        // We only need to consume AuthProvider here
        builder: (context, auth, _) {
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
              //'/admin-login': (context) => const AdminLogin(),
              '/landing': (context) => const LandingPage(),
              '/onboarding': (context) => const OnboardingScreen(),
            },
            // FIX: This home logic is now much simpler and safer
            home: Consumer<ProfileProvider>(
              builder: (context, profile, _) {
                // 1. Auth is still loading
                if (auth.isLoading) {
                  return const SplashScreen();
                }

                // 2. User is not logged in
                if (!auth.isAuthenticated) {
                  return const LandingPage();
                }

                // 3. User is logged in, but Profile is loading
                if (profile.isLoading) {
                  return const SplashScreen();
                }

                // 4. Profile is loaded, but it's null (needs onboarding)
                if (profile.profile == null) {
                  return const OnboardingScreen();
                }

                // 5. User is logged in and has a profile
                return const HomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
