import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/auth/presentation/provider/auth_provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  int _selectedMode = 1; // 0: User Login, 1: Register, 2: Admin Login
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_selectedMode == 2) {
      Navigator.pushNamed(context, '/admin-login');
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      if (_selectedMode == 1) {
        final confirm = confirmPasswordController.text.trim();
        if (password != confirm) {
          throw FirebaseAuthException(
            code: 'password-mismatch',
            message: 'Passwords do not match',
          );
        }
        await authProvider.signUp(email, password);

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/verify-email',
            (route) => false,
          );
        }
      } else if (_selectedMode == 0) {
        await authProvider.logIn(email, password);

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "An error occurred")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unknown error occurred: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Palette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Palette.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: Palette.shadowMedium,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: Palette.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.menu_book,
                    color: Palette.textOnPrimary,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "StudySquare",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Palette.textPrimary,
                  ),
                ),
                const Text(
                  "Learn skills at your own pace",
                  style: TextStyle(color: Palette.textSecondary),
                ),
                const SizedBox(height: 20),
                ToggleButtons(
                  isSelected: [
                    _selectedMode == 0,
                    _selectedMode == 1,
                    _selectedMode == 2,
                  ],
                  onPressed: (index) {
                    setState(() {
                      _selectedMode = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Palette.textOnPrimary,
                  fillColor: Palette.primary,
                  color: Palette.textPrimary,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("User Login"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Register"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Admin Login"),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                if (_selectedMode == 1) ...[
                  _buildTextField("Full Name", nameController, false),
                  const SizedBox(height: 12),
                ],
                if (_selectedMode != 2) ...[
                  _buildTextField("Email", emailController, false),
                  const SizedBox(height: 12),
                  _buildTextField("Password", passwordController, true),
                  const SizedBox(height: 12),
                ],
                if (_selectedMode == 1) ...[
                  _buildTextField(
                    "Confirm Password",
                    confirmPasswordController,
                    true,
                  ),
                ],
                if (_selectedMode != 1) const SizedBox(height: 12),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primary,
                          foregroundColor: Palette.textOnPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _selectedMode == 0
                              ? "Login"
                              : _selectedMode == 1
                              ? "Create Account"
                              : "Go to Admin Portal",
                          style: const TextStyle(color: Palette.textOnPrimary),
                        ),
                      ),
                const SizedBox(height: 25),
                const Divider(color: Palette.borderLight),
                const SizedBox(height: 10),
                const Text(
                  "Start learning today with\ninteractive lessons and progress tracking",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Palette.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Palette.surfaceVariant,
      ),
    );
  }
}
