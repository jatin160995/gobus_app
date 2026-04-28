import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';

heading(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

headingBig(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}

smallHeading(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.lightText,
    ),
  );
}
