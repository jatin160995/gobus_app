import 'package:flutter/material.dart';
import 'package:gobus_app/Widgets/design_utils.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/screens/Profile/widget/gender_dropdown.dart';
import 'package:gobus_app/widgets/custom_edit_text.dart';

class EditPassengerScreen extends StatefulWidget {
  const EditPassengerScreen({super.key});

  @override
  State<EditPassengerScreen> createState() => _EditPassengerScreenState();
}

class _EditPassengerScreenState extends State<EditPassengerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  String? selectedGender;

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
          l10n.editPassengerTitle,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Passenger Name
              smallHeading(l10n.passengerNameLabel),
              const SizedBox(height: 6),
              CustomEditText(
                true,
                14,
                nameController,
                TextInputType.name,
                l10n.passengerNameHint,
              ),

              const SizedBox(height: 16),

              /// Phone Number
              smallHeading(l10n.passengerPhoneLabel),
              const SizedBox(height: 6),
              CustomEditText(
                true,
                14,
                phoneController,
                TextInputType.phone,
                l10n.passengerPhoneHint,
              ),

              const SizedBox(height: 16),

              /// Gender
              smallHeading(l10n.passengerGenderLabel),
              const SizedBox(height: 6),
              GenderDropdown(
                value: selectedGender,
                hint: l10n.passengerGenderHint,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              /// ID Number
              smallHeading(l10n.passengerIdLabel),
              const SizedBox(height: 6),
              CustomEditText(
                true,
                14,
                idController,
                TextInputType.text,
                l10n.passengerIdHint,
              ),

              const SizedBox(height: 30),

              /// Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Update passenger later
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
                    l10n.passengerUpdateButton,
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
