import 'package:flutter/material.dart';

class AppSizes {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
  
  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusRound = 50.0;
  
  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 40.0;
  static const double iconXxxl = 48.0;
  
  // Elevation levels
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 12.0;
  static const double elevationXxl = 16.0;
  static const double elevationXxxl = 24.0;
  
  // Component heights
  static const double buttonHeight = 48.0;
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightLg = 56.0;
  static const double inputHeight = 48.0;
  static const double inputHeightSm = 40.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;
  static const double tabBarHeight = 48.0;
  
  // Component widths
  static const double buttonMinWidth = 88.0;
  static const double cardMinWidth = 280.0;
  static const double dialogMaxWidth = 400.0;
  static const double sheetMaxWidth = 600.0;
  
  // Border widths
  static const double borderWidthNone = 0.0;
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 4.0;
  
  // Common EdgeInsets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);
  
  // Horizontal padding
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHorizontalXxl = EdgeInsets.symmetric(horizontal: xxl);
  
  // Vertical padding
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets paddingVerticalXxl = EdgeInsets.symmetric(vertical: xxl);
  
  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: lg);
  
  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(xl);
  
  // Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets buttonPaddingSm = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets buttonPaddingLg = EdgeInsets.symmetric(horizontal: xl, vertical: lg);
  
  // Input padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets inputPaddingLg = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  
  // BorderRadius
  static const BorderRadius radiusXsAll = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius radiusSmAll = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius radiusMdAll = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius radiusLgAll = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius radiusXlAll = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius radiusXxlAll = BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius radiusRoundAll = BorderRadius.all(Radius.circular(radiusRound));
  
  // Top border radius
  static const BorderRadius radiusTopXs = BorderRadius.vertical(top: Radius.circular(radiusXs));
  static const BorderRadius radiusTopSm = BorderRadius.vertical(top: Radius.circular(radiusSm));
  static const BorderRadius radiusTopMd = BorderRadius.vertical(top: Radius.circular(radiusMd));
  static const BorderRadius radiusTopLg = BorderRadius.vertical(top: Radius.circular(radiusLg));
  static const BorderRadius radiusTopXl = BorderRadius.vertical(top: Radius.circular(radiusXl));
  
  // Bottom border radius
  static const BorderRadius radiusBottomXs = BorderRadius.vertical(bottom: Radius.circular(radiusXs));
  static const BorderRadius radiusBottomSm = BorderRadius.vertical(bottom: Radius.circular(radiusSm));
  static const BorderRadius radiusBottomMd = BorderRadius.vertical(bottom: Radius.circular(radiusMd));
  static const BorderRadius radiusBottomLg = BorderRadius.vertical(bottom: Radius.circular(radiusLg));
  static const BorderRadius radiusBottomXl = BorderRadius.vertical(bottom: Radius.circular(radiusXl));
}
