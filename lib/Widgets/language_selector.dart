import 'package:flutter/material.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/main.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final selected =
        provider.locale?.languageCode ?? ''; // '' means system/default
    final l10n = AppLocalizations.of(context)!;

    // Helper to style active/inactive button
    Widget langButton(String code, String label) {
      final bool isActive = selected == code;
      return Expanded(
        child: InkWell(
          onTap: () async {
            await provider.changeLanguage(code); // persists and notifies
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.dividerColor,
              ),
              boxShadow:
                  isActive
                      ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.white : AppColors.darkText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.languageHeadeing,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            langButton('en', 'English'),
            const SizedBox(width: 12),
            langButton('fr', 'Français'),
          ],
        ),
        // const SizedBox(height: 8),
        // Row(
        //   children: [
        //     TextButton(
        //       onPressed: () => provider.clearLanguage(),
        //       child: Text(
        //         'System locale',
        //         style: TextStyle(color: AppColors.mediumText),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
