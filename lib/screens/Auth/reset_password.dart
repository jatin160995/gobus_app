import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/custom_edit_text.dart';
import 'package:gobus_app/core/theme.dart';
// Import the generated localizations file
import 'package:gobus_app/l10n/gen/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text(
        //   l10n.resetPasswordTitle,
        //   style: const TextStyle(color: AppColors.darkText),
        // ),
        backgroundColor: Colors.transparent,
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
                //color: AppColors.primary, // Orange background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Image.asset('assets/images/reset_password.png'),
            ),
            const SizedBox(height: 30),
            // --- TITLE (Split into two lines for styling) ---
            Text(
              l10n.resetPasswordHeading,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontFamily: 'poppins',
              ),
            ),
            Text(
              l10n.resetPasswordSubHeading,
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
                  // Password
                  CustomEditText(
                    true,
                    15,
                    _passwordController,
                    TextInputType.emailAddress,
                    l10n.passwordHint, // Localized hint
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password (Fixed 'Confrim' typo)
                  CustomEditText(
                    true,
                    15,
                    _cPasswordController,
                    TextInputType.emailAddress,
                    l10n.confirmPasswordHint, // Localized hint
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),

                  // --- SUBMIT BUTTON ---
                  ElevatedButton(
                    onPressed: () {
                      // Handle login logic
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
                      l10n.submitBtn, // Localized button
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
