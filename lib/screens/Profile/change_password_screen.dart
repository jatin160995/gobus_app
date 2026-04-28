import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/widgets/custom_edit_text.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: AppColors.darkText),
        title: Text(
          l10n.changePasswordTitle,
          style: const TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// Current Password
              CustomEditText(
                true,
                14,
                currentPasswordController,
                TextInputType.text,
                l10n.changePasswordCurrent,
                isPassword: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 14),

              /// New Password
              CustomEditText(
                true,
                14,
                newPasswordController,
                TextInputType.text,
                l10n.changePasswordNew,
                isPassword: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 14),

              /// Confirm Password
              CustomEditText(
                true,
                14,
                confirmPasswordController,
                TextInputType.text,
                l10n.changePasswordConfirm,
                isPassword: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 30),

              /// Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // API logic later
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.changePasswordUpdateButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
