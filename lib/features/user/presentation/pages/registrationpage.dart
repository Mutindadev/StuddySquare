import 'package:flutter/material.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/home/presentation/pages/home.dart';

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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                  isSelected: const [false, true, false],
                  onPressed: (index) {},
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

                _buildTextField("Full Name", nameController, false),
                const SizedBox(height: 12),
                _buildTextField("Email", emailController, false),
                const SizedBox(height: 12),
                _buildTextField("Password", passwordController, true),
                const SizedBox(height: 12),
                _buildTextField(
                  "Confirm Password",
                  confirmPasswordController,
                  true,
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    print("Name: ${nameController.text}");
                    print("Email: ${emailController.text}");
                    print("Password: ${passwordController.text}");
                    print("Confirm: ${confirmPasswordController.text}");

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
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
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Palette.textOnPrimary),
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
