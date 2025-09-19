import 'package:flutter/material.dart';

@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.light,
    required this.dark,
    required this.muted,
    required this.accent,
  });

  final Color primary;
  final Color secondary;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color light;
  final Color dark;
  final Color muted;
  final Color accent;

  // Light theme brand colors
  static const BrandColors light = BrandColors(
    primary: Color(0xFF00796B), // Teal 700
    secondary: Color(0xFF26A69A), // Teal 400
    success: Color(0xFF2E7D32), // Green 800
    warning: Color(0xFFF9A825), // Amber 600
    danger: Color(0xFFC62828), // Red 800
    info: Color(0xFF1976D2), // Blue 700
    light: Color(0xFFF7F9FB), // Light gray
    dark: Color(0xFF263238), // Blue gray 900
    muted: Color(0xFF9E9E9E), // Gray 500
    accent: Color(0xFF4CAF50), // Green 500
  );

  // Dark theme brand colors
  static const BrandColors dark = BrandColors(
    primary: Color(0xFF4DB6AC), // Teal 300
    secondary: Color(0xFF80CBC4), // Teal 200
    success: Color(0xFF66BB6A), // Green 400
    warning: Color(0xFFFFB74D), // Amber 300
    danger: Color(0xFFEF5350), // Red 400
    info: Color(0xFF42A5F5), // Blue 400
    light: Color(0xFF37474F), // Blue gray 800
    dark: Color(0xFFECEFF1), // Blue gray 50
    muted: Color(0xFF90A4AE), // Blue gray 300
    accent: Color(0xFF81C784), // Green 300
  );

  @override
  BrandColors copyWith({
    Color? primary,
    Color? secondary,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? light,
    Color? dark,
    Color? muted,
    Color? accent,
  }) {
    return BrandColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      light: light ?? this.light,
      dark: dark ?? this.dark,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) {
      return this;
    }
    return BrandColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      light: Color.lerp(light, other.light, t)!,
      dark: Color.lerp(dark, other.dark, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }

  // Helper methods for common color variations
  Color get primaryLight => primary.withOpacity(0.1);
  Color get primaryDark => primary.withOpacity(0.8);
  Color get secondaryLight => secondary.withOpacity(0.1);
  Color get secondaryDark => secondary.withOpacity(0.8);
  Color get successLight => success.withOpacity(0.1);
  Color get successDark => success.withOpacity(0.8);
  Color get warningLight => warning.withOpacity(0.1);
  Color get warningDark => warning.withOpacity(0.8);
  Color get dangerLight => danger.withOpacity(0.1);
  Color get dangerDark => danger.withOpacity(0.8);
  Color get infoLight => info.withOpacity(0.1);
  Color get infoDark => info.withOpacity(0.8);
}

// Extension to easily access brand colors from BuildContext
extension BrandColorsExtension on BuildContext {
  BrandColors get brandColors => Theme.of(this).extension<BrandColors>()!;
}
