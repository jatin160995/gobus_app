import 'package:flutter/material.dart';

/// A utility class to easily generate flexible and customizable BoxDecorations.
/// All parameters are optional, allowing developers to set only what they need.
class DecorationUtils {
  /// Generates a BoxDecoration suitable for a Flutter Container.
  ///
  /// - [radius]: The circular border radius. Defaults to 12.0.
  /// - [color]: The background color. Only used if [gradientColors] is null.
  /// - [borderColor]: The color of the border.
  /// - [borderWidth]: The width of the border.
  /// - [gradientColors]: A list of exactly two colors to create a linear gradient.
  ///   If provided, this overrides the [color] parameter.
  static BoxDecoration buildBoxDecoration({
    double? radius,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    List<Color>? gradientColors,
  }) {
    // 1. Determine Border Radius (uses 12.0 if not provided)
    final BorderRadius borderRadius = BorderRadius.circular(radius ?? 12.0);

    // 2. Determine Border (if color or width is provided)
    Border? border;
    if (borderColor != null || borderWidth != null) {
      border = Border.all(
        color: borderColor ?? Colors.grey.shade300, // Default border color
        width: borderWidth ?? 1.0, // Default border width
      );
    }

    // 3. Determine Gradient (if two colors are provided)
    LinearGradient? gradient;
    if (gradientColors != null && gradientColors.length == 2) {
      // Creates a simple linear gradient from top-left to bottom-right
      gradient = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    // 4. Return the complete BoxDecoration
    // Note: If a gradient is defined, 'color' must be null.
    return BoxDecoration(
      borderRadius: borderRadius,
      border: border,
      gradient: gradient,
      color:
          gradient == null
              ? color
              : null, // Apply color only if no gradient is present
    );
  }
}
