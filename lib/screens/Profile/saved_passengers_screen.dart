import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/screens/Profile/edit_passenger_screen.dart';
import 'package:gobus_app/screens/Profile/widget/passenger_row.dart';

class SavedPassengersScreen extends StatelessWidget {
  const SavedPassengersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mock data – replace with API later
    final passengers = [
      {'name': 'John Smith', 'gender': 'M', 'age': '30y'},
      {'name': 'John Smith', 'gender': 'M', 'age': '30y'},
      {'name': 'John Smith', 'gender': 'M', 'age': '5y'},
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: AppColors.darkText),
        title: Text(
          l10n.savedPassengersTitle,
          style: const TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditPassengerScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.passengerNameLabel,
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 12,
                  ),
                ),
                Text(
                  l10n.passengerAgeLabel,
                  style: const TextStyle(
                    color: AppColors.lightText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(color: AppColors.dividerColor),

            /// Passenger list
            Expanded(
              child: ListView.separated(
                itemCount: passengers.length,
                separatorBuilder:
                    (_, __) => const Divider(color: AppColors.dividerColor),
                itemBuilder: (context, index) {
                  final p = passengers[index];
                  return PassengerRow(
                    name: p['name']!,
                    gender: p['gender']!,
                    age: p['age']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
