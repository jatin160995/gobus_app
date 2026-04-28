import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';

class GenderDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final ValueChanged<String?> onChanged;

  const GenderDropdown({
    required this.value,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: AppColors.lightText)),
          icon: Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          items: [
            DropdownMenuItem(value: 'M', child: Text('Male')),
            DropdownMenuItem(value: 'F', child: Text('Female')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
