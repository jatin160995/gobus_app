import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/custom_edit_text.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/core/utils.dart';
import 'package:gobus_app/core/utils/validators.dart';
import 'package:gobus_app/features/auth/services/auth_api.dart';
import 'package:gobus_app/screens/Auth/forgot_password.dart';
import 'package:gobus_app/screens/Auth/otp_screen.dart';
import 'package:gobus_app/screens/Auth/signup.dart';
// Import the generated localizations file
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      showError(l10n.emailHint, context);
      return;
    }

    if (!Validators.isEmailValid(email)) {
      showError("Invalid email address", context);
      return;
    }

    if (password.isEmpty) {
      showError(l10n.passwordHint, context);
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthApi.login(username: email, password: password);

    setState(() => _isLoading = false);

    if (response.status) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      showError(response.message ?? "Login failed", context);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
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
              child: Image.asset('assets/images/login.png'),
            ),
            const SizedBox(height: 15),

            // --- LOGIN FORM AREA ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Split title implementation
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- TITLE (Split into two lines for styling) ---
                      Text(
                        l10n.loginHeading,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                          fontFamily: 'poppins',
                        ),
                      ),
                      Text(
                        l10n.loginSubHeading,
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

                  // Email Field
                  CustomEditText(
                    true,
                    15,
                    _emailController,
                    TextInputType.emailAddress,
                    l10n.emailHint, // Localized hint
                    isPassword: false,
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
                  const SizedBox(height: 8),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.forgotPassword, // Localized link
                        style: const TextStyle(
                          color: AppColors.lightText,
                          fontFamily: "medium",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- LOGIN BUTTON ---
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                            : Text(
                              l10n.loginBtn,
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
                          l10n.orLoginWith, // Localized divider text
                          style: const TextStyle(color: AppColors.lightText),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.dividerColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- SOCIAL LOGIN BUTTONS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildSocialButton('Google', 'assets/images/google.png'),
                      const SizedBox(width: 16),
                      _buildSocialButton('Facebook', 'assets/images/fb.png'),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // --- SIGN UP LINK ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        l10n.signupPrompt + " ", // Localized prompt
                        style: const TextStyle(color: AppColors.mediumText),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.signupAction, // Localized action
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
                  const SizedBox(height: 50),
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
}
