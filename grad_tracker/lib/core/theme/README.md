# Flutter Theme System

This directory contains a comprehensive theming system for the Flutter application, following Material Design 3 guidelines and best practices.

## Components

### 1. AppTypography (`app_typography.dart`)
Custom typography system with consistent font families, sizes, weights, and spacing.

**Features:**
- Material Design 3 typography scale
- Consistent line heights and letter spacing
- Custom font weights and families
- Complete TextTheme implementation

**Usage:**
```dart
Text(
  'Hello World',
  style: Theme.of(context).textTheme.headlineMedium,
)
```

### 2. AppSizes (`app_sizes.dart`)
Comprehensive sizing system for consistent spacing, radius, icons, and elevation.

**Features:**
- Spacing scale (xs, sm, md, lg, xl, xxl, xxxl)
- Border radius values
- Icon sizes
- Elevation levels
- Component dimensions (buttons, inputs, etc.)
- Pre-defined EdgeInsets and BorderRadius

**Usage:**
```dart
Container(
  padding: AppSizes.paddingLg,
  margin: AppSizes.paddingSm,
  decoration: BoxDecoration(
    borderRadius: AppSizes.radiusMdAll,
    elevation: AppSizes.elevationSm,
  ),
  child: Icon(
    Icons.star,
    size: AppSizes.iconMd,
  ),
)
```

### 3. BrandColors (`brand_colors.dart`)
ThemeExtension for brand-specific colors with light and dark theme support.

**Features:**
- Custom brand colors (primary, secondary, success, warning, danger, info)
- Light and dark theme variants
- Color variations (light, dark variants)
- Easy access via BuildContext extension

**Usage:**
```dart
// Access brand colors
final brandColors = context.brandColors;

Container(
  color: brandColors.primary,
  child: Text(
    'Success',
    style: TextStyle(color: brandColors.success),
  ),
)
```

### 4. AppColors (`app_colors.dart`)
Material ColorScheme generation and legacy color support.

**Features:**
- Material 3 ColorScheme generation from seed color
- Light and dark theme support
- Legacy color constants (deprecated)

**Usage:**
```dart
// Access Material ColorScheme
final colorScheme = Theme.of(context).colorScheme;
Container(color: colorScheme.primary)
```

### 5. AppTheme (`app_theme.dart`)
Main theme configuration combining all components.

**Features:**
- Complete Material 3 theme setup
- Light and dark theme support
- Component-specific theming (buttons, cards, inputs, etc.)
- Brand color integration

**Usage:**
```dart
MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.system,
  // ...
)
```

## Migration Guide

### From Legacy AppSpacing
```dart
// Old
padding: AppSpacing.lg

// New
padding: AppSizes.paddingLg
// or
padding: EdgeInsets.all(AppSizes.lg)
```

### From Legacy AppColors
```dart
// Old
color: AppColors.secondary

// New
color: context.brandColors.secondary
// or
color: Theme.of(context).colorScheme.secondary
```

## Best Practices

1. **Use AppSizes for all spacing and dimensions**
   - Consistent spacing across the app
   - Easy to maintain and update

2. **Use BrandColors for brand-specific colors**
   - Automatic light/dark theme support
   - Easy access via context extension

3. **Use Material ColorScheme for semantic colors**
   - Follows Material Design guidelines
   - Automatic theme adaptation

4. **Use AppTypography for text styling**
   - Consistent typography scale
   - Proper line heights and spacing

5. **Import from theme.dart**
   ```dart
   import 'package:your_app/core/theme/theme.dart';
   ```

## Example Usage

See `theme_usage_example.dart` for comprehensive examples of how to use all components of the theming system.

## File Structure

```
lib/core/theme/
├── app_theme.dart          # Main theme configuration
├── app_colors.dart         # ColorScheme generation
├── app_typography.dart     # Typography system
├── app_sizes.dart          # Sizing system
├── brand_colors.dart       # Brand color extension
├── app_spacing.dart        # Legacy spacing (deprecated)
├── theme.dart              # Export file
├── theme_usage_example.dart # Usage examples
└── README.md               # This file
```
