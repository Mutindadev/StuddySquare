import 'package:flutter/material.dart';
import 'progress/presentation/pages/progress_page.dart';

void main() => runApp(const ProgressApp());

class ProgressApp extends StatelessWidget {
  const ProgressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progress Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Inter',
      ),
      home: const ProgressPage(),
    );
  }
}

