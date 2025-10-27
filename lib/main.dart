import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/home/presentation/pages/home.dart';
import 'package:studysquare/features/profile/presentation/pages/onboarding.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';

import 'core/theme/app_theme.dart';
// ...existing imports...

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProfileProvider())],
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return FutureBuilder<bool>(
            future: profileProvider.isOnboardingComplete('1'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MaterialApp(
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              final isOnboardingComplete = snapshot.data ?? false;
              return MaterialApp(
                title: 'StudySquare',
                theme: AppTheme.lightTheme,
                home: isOnboardingComplete ? HomePage() : OnboardingScreen(),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
