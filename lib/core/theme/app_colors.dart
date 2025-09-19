import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color (used as ColorScheme seed)
  static const Color primary = Color(0xFF00796B); // Teal 700
  
  // Legacy colors (deprecated - use BrandColors extension instead)
  @Deprecated('Use BrandColors extension instead')
  static const Color secondary = Color(0xFF26A69A); // Teal 400
  @Deprecated('Use BrandColors extension instead')
  static const Color success = Color(0xFF2E7D32);
  @Deprecated('Use BrandColors extension instead')
  static const Color warning = Color(0xFFF9A825);
  @Deprecated('Use BrandColors extension instead')
  static const Color danger = Color(0xFFC62828);
  @Deprecated('Use BrandColors extension instead')
  static const Color background = Color(0xFFF7F9FB);
  
  // Material ColorScheme generation
  static ColorScheme lightColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );
  }
  
  static ColorScheme darkColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    );
  }
}


