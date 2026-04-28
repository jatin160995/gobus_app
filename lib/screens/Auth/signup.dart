import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/custom_edit_text.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/core/utils.dart';
import 'package:gobus_app/features/auth/services/auth_api.dart';
import 'package:gobus_app/screens/Auth/login.dart';
// Import the generated localizations file
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/screens/Auth/otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: const Text(
        //   'Sign Up',
        //   style: TextStyle(color: AppColors.darkText),
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.darkText,
        ), // Ensures back arrow is visible
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // --- TOP BANNER/ILLUSTRATION AREA ---
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Image.asset('assets/images/signup.png'),
            ),
            const SizedBox(height: 10),

            // --- SIGNUP FORM AREA ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- TITLE (Split into two lines for styling) ---
                      Text(
                        l10n.signUpHeading,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                          fontFamily: 'poppins',
                        ),
                      ),
                      Text(
                        l10n.signUpSubHeading,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  CustomEditText(
                    true,
                    15,
                    _nameController,
                    TextInputType.name,
                    l10n.nameHint, // Localized hint
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  CustomEditText(
                    true,
                    15,
                    _emailController,
                    TextInputType.emailAddress,
                    l10n.emailHint, // Localized hint
                  ),
                  const SizedBox(height: 16),
                  // Phome Field
                  CustomEditText(
                    true,
                    15,
                    _phoneController,
                    TextInputType.phone,
                    l10n.passengerPhoneHint, // Localized hint
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  CustomEditText(
                    true,
                    15,
                    _passwordController,
                    TextInputType.visiblePassword,
                    l10n.passwordHint, // Localized hint
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  CustomEditText(
                    true,
                    15,
                    _confirmPasswordController,
                    TextInputType.visiblePassword,
                    l10n.confirmPasswordHint, // Localized hint
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),

                  // --- SIGN UP BUTTON ---
                  ElevatedButton(
                    onPressed: () {
                      // Handle signup logic
                      _signup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 4,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                    ),
                    child: Text(
                      l10n.signupAction, // Localized button
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- OR DIVIDER ---
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.dividerColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          l10n.orSignupWith, // Localized divider text
                          style: const TextStyle(color: AppColors.lightText),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.dividerColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- SOCIAL SIGNUP BUTTONS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildSocialButton('Google', 'assets/images/google.png'),
                      const SizedBox(width: 16),
                      _buildSocialButton('Facebook', 'assets/images/fb.png'),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // --- LOGIN LINK ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        l10n.alreadyHaveAccount, // Localized prompt
                        style: const TextStyle(color: AppColors.mediumText),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.loginHere, // Localized action
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for Social Login Buttons (Not localized as it uses static platform names)
  Widget _buildSocialButton(String label, String iconPath) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          // Handle social login
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.dividerColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 25),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.darkText,
                fontFamily: "medium",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signup() async {
    final l10n = AppLocalizations.of(context)!;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showError("All fields are required", context);
      return;
    }

    if (password != confirmPassword) {
      showError("Passwords do not match", context);
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthApi.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (response.status) {
      final data = response.data!;
      final otp = data['otp'];
      final userId = data['user']['id'];
      final token = data['token'];

      // TEMP: show OTP
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP: $otp"), backgroundColor: Colors.green),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => OtpVerificationScreen(
                userId: userId,
                token: token,
                email: email,
              ),
        ),
      );
    } else {
      showError(response.message ?? "Signup failed", context);
    }
  }
}
