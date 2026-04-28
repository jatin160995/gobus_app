import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';

class PassengerRow extends StatelessWidget {
  final String name;
  final String gender;
  final String age;

  const PassengerRow({
    required this.name,
    required this.gender,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '($gender)',
                style: const TextStyle(
                  color: AppColors.lightText,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          /// Age
          Text(
            age,
            style: const TextStyle(
              color: AppColors.darkText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
