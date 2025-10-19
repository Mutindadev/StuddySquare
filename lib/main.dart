import 'package:flutter/material.dart';
import 'package:studysquare/dashboard_screen.dart';

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
      home: const DashboardScreen(),
    );
  }
}
