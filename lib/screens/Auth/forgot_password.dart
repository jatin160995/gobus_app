import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/custom_edit_text.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/screens/Auth/reset_password.dart';
// Import the generated localizations file
import 'package:gobus_app/l10n/gen/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      // Setting extendBodyBehindAppBar to true allows the body content (like the top banner)
      // to extend up under the transparent status bar area.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text(
        //   l10n.forgotPasswordScreenTitle,
        //   style: const TextStyle(color: AppColors.darkText),
        // ),
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkText),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // --- TOP BANNER/ILLUSTRATION AREA ---
            Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.primary, // Orange background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Image.asset('assets/images/forgot_password.png'),
            ),
            const SizedBox(height: 30),

            Text(
              l10n.forgotHeading,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontFamily: 'poppins',
              ),
            ),
            Text(
              l10n.forgotSubHeading,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'poppins',
              ),
            ),

            // --- FORM AREA ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Email/Mobile Number
                  CustomEditText(
                    true,
                    15,
                    _emailController,
                    TextInputType.emailAddress,
                    l10n.emailHint, // Localized hint
                    isPassword: false,
                  ),
                  const SizedBox(height: 16),

                  // --- SUBMIT BUTTON ---
                  ElevatedButton(
                    onPressed: () {
                      // Handle login logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPassword(),
                        ),
                      );
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
                      l10n.submitBtn, // Localized button text
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
