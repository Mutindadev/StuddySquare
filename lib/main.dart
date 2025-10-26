import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/user/presentation/pages/registrationpage.dart';

import 'core/theme/app_theme.dart';
import 'features/programs/data/repositories/enrollment_repository.dart';
import 'features/programs/presentation/provider/enrollment_provider.dart';
// ...existing imports...

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          EnrollmentProvider(EnrollmentRepository())
            ..onAuthChanged('demo_user'), // Initialize with a demo user
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySquare',
      theme: AppTheme.lightTheme,
      // Remove the old theme configuration
      home: const RegistrationPage(), // or your initial route
      debugShowCheckedModeBanner: false,
    );
  }
}
