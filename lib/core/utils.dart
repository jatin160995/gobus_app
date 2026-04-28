import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}

void showError(String message, BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
}

Widget loader() {
  return const Center(
    child: CircularProgressIndicator(color: AppColors.primary),
  );
}
