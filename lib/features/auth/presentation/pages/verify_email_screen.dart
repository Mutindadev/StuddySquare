import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studysquare/features/home/presentation/pages/home.dart';
import 'package:studysquare/features/user/presentation/pages/registrationpage.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  bool _isChecking = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isEmailVerified) {
      _sendVerificationEmail();

      // auto check every few seconds (background polling)
      _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => _canResendEmail = true);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Verification email sent.")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error sending email: $e")));
    }
  }

  Future<void> _checkEmailVerified({bool manual = false}) async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    try {
      await FirebaseAuth.instance.currentUser!.reload();
      final user = FirebaseAuth.instance.currentUser!;
      setState(() => _isEmailVerified = user.emailVerified);

      if (_isEmailVerified) {
        _timer?.cancel();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email verified successfully!")),
          );
        }
      } else if (manual && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email not verified yet. Try again later."),
          ),
        );
      }
    } catch (e) {
      if (manual && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error checking status: $e")));
      }
    } finally {
      setState(() => _isChecking = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(title: const Text("Verify Email")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "A verification email has been sent. Please check your inbox and click the verification link.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.email_outlined),
                    label: const Text("Resend Email"),
                    onPressed: _canResendEmail ? _sendVerificationEmail : null,
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: _isChecking
                        ? const Text("Checking...")
                        : const Text("Refresh Status"),
                    onPressed: _isChecking
                        ? null
                        : () => _checkEmailVerified(manual: true),
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistrationPage(),
                          ),
                        );
                      }
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ),
          );
  }
}
