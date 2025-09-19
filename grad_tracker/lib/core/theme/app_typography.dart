import 'package:flutter/material.dart';

class AppTypography {
  // Font families
  static const String primaryFont = 'Roboto';
  static const String displayFont = 'Roboto';
  
  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // Font sizes
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  
  // Line heights
  static const double displayLargeHeight = 64.0;
  static const double displayMediumHeight = 52.0;
  static const double displaySmallHeight = 44.0;
  static const double headlineLargeHeight = 40.0;
  static const double headlineMediumHeight = 36.0;
  static const double headlineSmallHeight = 32.0;
  static const double titleLargeHeight = 28.0;
  static const double titleMediumHeight = 24.0;
  static const double titleSmallHeight = 20.0;
  static const double bodyLargeHeight = 24.0;
  static const double bodyMediumHeight = 20.0;
  static const double bodySmallHeight = 16.0;
  static const double labelLargeHeight = 20.0;
  static const double labelMediumHeight = 16.0;
  static const double labelSmallHeight = 16.0;
  
  // Letter spacing
  static const double displayLargeSpacing = -0.25;
  static const double displayMediumSpacing = 0.0;
  static const double displaySmallSpacing = 0.0;
  static const double headlineLargeSpacing = 0.0;
  static const double headlineMediumSpacing = 0.0;
  static const double headlineSmallSpacing = 0.0;
  static const double titleLargeSpacing = 0.0;
  static const double titleMediumSpacing = 0.15;
  static const double titleSmallSpacing = 0.1;
  static const double bodyLargeSpacing = 0.5;
  static const double bodyMediumSpacing = 0.25;
  static const double bodySmallSpacing = 0.4;
  static const double labelLargeSpacing = 0.1;
  static const double labelMediumSpacing = 0.5;
  static const double labelSmallSpacing = 0.5;

  static TextTheme get textTheme {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontFamily: displayFont,
        fontSize: displayLarge,
        fontWeight: regular,
        height: displayLargeHeight / displayLarge,
        letterSpacing: displayLargeSpacing,
      ),
      displayMedium: TextStyle(
        fontFamily: displayFont,
        fontSize: displayMedium,
        fontWeight: regular,
        height: displayMediumHeight / displayMedium,
        letterSpacing: displayMediumSpacing,
      ),
      displaySmall: TextStyle(
        fontFamily: displayFont,
        fontSize: displaySmall,
        fontWeight: regular,
        height: displaySmallHeight / displaySmall,
        letterSpacing: displaySmallSpacing,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: headlineLarge,
        fontWeight: regular,
        height: headlineLargeHeight / headlineLarge,
        letterSpacing: headlineLargeSpacing,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: headlineMedium,
        fontWeight: regular,
        height: headlineMediumHeight / headlineMedium,
        letterSpacing: headlineMediumSpacing,
      ),
      headlineSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: headlineSmall,
        fontWeight: regular,
        height: headlineSmallHeight / headlineSmall,
        letterSpacing: headlineSmallSpacing,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: titleLarge,
        fontWeight: medium,
        height: titleLargeHeight / titleLarge,
        letterSpacing: titleLargeSpacing,
      ),
      titleMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: titleMedium,
        fontWeight: medium,
        height: titleMediumHeight / titleMedium,
        letterSpacing: titleMediumSpacing,
      ),
      titleSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: titleSmall,
        fontWeight: medium,
        height: titleSmallHeight / titleSmall,
        letterSpacing: titleSmallSpacing,
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: bodyLarge,
        fontWeight: regular,
        height: bodyLargeHeight / bodyLarge,
        letterSpacing: bodyLargeSpacing,
      ),
      bodyMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: bodyMedium,
        fontWeight: regular,
        height: bodyMediumHeight / bodyMedium,
        letterSpacing: bodyMediumSpacing,
      ),
      bodySmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: bodySmall,
        fontWeight: regular,
        height: bodySmallHeight / bodySmall,
        letterSpacing: bodySmallSpacing,
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontFamily: primaryFont,
        fontSize: labelLarge,
        fontWeight: medium,
        height: labelLargeHeight / labelLarge,
        letterSpacing: labelLargeSpacing,
      ),
      labelMedium: TextStyle(
        fontFamily: primaryFont,
        fontSize: labelMedium,
        fontWeight: medium,
        height: labelMediumHeight / labelMedium,
        letterSpacing: labelMediumSpacing,
      ),
      labelSmall: TextStyle(
        fontFamily: primaryFont,
        fontSize: labelSmall,
        fontWeight: medium,
        height: labelSmallHeight / labelSmall,
        letterSpacing: labelSmallSpacing,
      ),
    );
  }
}
