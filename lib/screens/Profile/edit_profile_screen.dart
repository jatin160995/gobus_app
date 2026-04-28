import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/widgets/custom_edit_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
          l10n.editProfileTitle,
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

              /// Name
              CustomEditText(
                true,
                14,
                nameController,
                TextInputType.name,
                l10n.editProfileNameHint,
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 14),

              /// Email
              CustomEditText(
                true,
                14,
                emailController,
                TextInputType.emailAddress,
                l10n.editProfileEmailHint,
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 14),

              /// Phone
              CustomEditText(
                true,
                14,
                phoneController,
                TextInputType.phone,
                l10n.editProfilePhoneHint,
                icon: Icons.phone_outlined,
              ),

              const SizedBox(height: 30),

              /// Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // API integration later
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
                    l10n.editProfileUpdateButton,
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
