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
      cardTheme: CardTheme(
        elevation: AppSizes.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusMdAll,
        ),
        margin: AppSizes.paddingSm,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BrandColors.light.primaryLight,
        selectedColor: BrandColors.light.primary,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: BrandColors.light.primary,
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
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge,
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
            color: BrandColors.light.danger,
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
      dialogTheme: DialogTheme(
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusLgAll,
        ),
        titleTextStyle: AppTypography.textTheme.headlineSmall,
        contentTextStyle: AppTypography.textTheme.bodyMedium,
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
        BrandColors.light,
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
      cardTheme: CardTheme(
        elevation: AppSizes.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusMdAll,
        ),
        margin: AppSizes.paddingSm,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BrandColors.dark.primaryLight,
        selectedColor: BrandColors.dark.primary,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: BrandColors.dark.primary,
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
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: AppSizes.buttonPadding,
          minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: AppSizes.radiusMdAll,
          ),
          textStyle: AppTypography.textTheme.labelLarge,
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
            color: BrandColors.dark.danger,
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
      dialogTheme: DialogTheme(
        elevation: AppSizes.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.radiusLgAll,
        ),
        titleTextStyle: AppTypography.textTheme.headlineSmall,
        contentTextStyle: AppTypography.textTheme.bodyMedium,
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
        BrandColors.dark,
      ],
    );
  }
}


