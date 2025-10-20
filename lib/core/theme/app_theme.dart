import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_sizes.dart';
import 'brand_colors.dart';

class AppTheme {
  static ThemeData light() {
    final colorScheme = AppColors.lightColorScheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Scaffold
      scaffoldBackgroundColor: colorScheme.surface,
      
      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: AppSizes.elevationSm,
        scrolledUnderElevation: AppSizes.elevationMd,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppSizes.iconMd,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        elevation: AppSizes.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusMdAll,
        ),
        margin: AppSizes.paddingSm,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BrandColors.lightTheme.primaryLight,
        selectedColor: BrandColors.lightTheme.primary,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: BrandColors.lightTheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusRoundAll,
        ),
        padding: AppSizes.paddingHorizontalMd,
        labelPadding: AppSizes.paddingHorizontalSm,
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSizes.elevationSm,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSizes.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: BrandColors.lightTheme.danger,
            width: AppSizes.borderWidthThin,
          ),
        ),
        contentPadding: AppSizes.inputPadding,
        labelStyle: AppTypography.textTheme.bodyMedium,
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: AppSizes.elevationLg,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.textTheme.labelSmall,
        unselectedLabelStyle: AppTypography.textTheme.labelSmall,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppSizes.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusLgAll,
        ),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        elevation: AppSizes.elevationXl,
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusLgAll,
        ),
        titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusTopLg,
        ),
        backgroundColor: colorScheme.surface,
      ),
      
      // Extensions
      extensions: const <ThemeExtension<dynamic>>[
        BrandColors.lightTheme,
      ],
    );
  }

  static ThemeData dark() {
    final colorScheme = AppColors.darkColorScheme();
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Scaffold
      scaffoldBackgroundColor: colorScheme.surface,
      
      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: AppSizes.elevationSm,
        scrolledUnderElevation: AppSizes.elevationMd,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppSizes.iconMd,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        elevation: AppSizes.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusMdAll,
        ),
        margin: AppSizes.paddingSm,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BrandColors.darkTheme.primaryLight,
        selectedColor: BrandColors.darkTheme.primary,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: BrandColors.darkTheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusRoundAll,
        ),
        padding: AppSizes.paddingHorizontalMd,
        labelPadding: AppSizes.paddingHorizontalSm,
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppSizes.elevationSm,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSizes.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.radiusMdAll,
          borderSide: BorderSide(
            color: BrandColors.darkTheme.danger,
            width: AppSizes.borderWidthThin,
          ),
        ),
        contentPadding: AppSizes.inputPadding,
        labelStyle: AppTypography.textTheme.bodyMedium,
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: AppSizes.elevationLg,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.textTheme.labelSmall,
        unselectedLabelStyle: AppTypography.textTheme.labelSmall,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppSizes.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusLgAll,
        ),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        elevation: AppSizes.elevationXl,
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusLgAll,
        ),
        titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusTopLg,
        ),
        backgroundColor: colorScheme.surface,
      ),
      
      // Extensions
      extensions: const <ThemeExtension<dynamic>>[
        BrandColors.darkTheme,
      ],
    );
  }
}


