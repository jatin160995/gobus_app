import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'models/recent_search.dart';
import 'package:intl/intl.dart';

class RecentSearchCard extends StatelessWidget {
  final RecentSearch item;
  final VoidCallback? onTap;

  const RecentSearchCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toString(),
    ).format(item.date);
    final transportIcon =
        item.transport == 'car' ? Icons.directions_car : Icons.directions_bus;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.dividerColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // left code
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fromCode,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.fromName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mediumText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // center transport icon
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        child: Icon(transportIcon, color: AppColors.secondary),
                      ),
                    ],
                  ),

                  // right code
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.toCode,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.toName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mediumText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Text(
                dateLabel,
                style: const TextStyle(
                  color: AppColors.lightText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
