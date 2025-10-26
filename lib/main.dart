import 'package:flutter/material.dart';
import 'package:studysquare/features/user/presentation/pages/registrationpage.dart';

import 'core/theme/app_theme.dart';
// ...existing imports......

void main() {
  runApp(const MyApp());
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