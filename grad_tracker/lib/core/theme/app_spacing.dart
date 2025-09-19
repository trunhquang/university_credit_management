import 'package:flutter/widgets.dart';
import 'app_sizes.dart';

/// Legacy spacing class - use AppSizes instead
@Deprecated('Use AppSizes instead for consistent spacing')
class AppSpacing {
  @Deprecated('Use AppSizes.xs instead')
  static const double xs = AppSizes.xs;
  @Deprecated('Use AppSizes.sm instead')
  static const double sm = AppSizes.sm;
  @Deprecated('Use AppSizes.md instead')
  static const double md = AppSizes.md;
  @Deprecated('Use AppSizes.lg instead')
  static const double lg = AppSizes.lg;
  @Deprecated('Use AppSizes.xl instead')
  static const double xl = AppSizes.xl;
  @Deprecated('Use AppSizes.xxl instead')
  static const double xxl = AppSizes.xxl;

  @Deprecated('Use AppSizes.screenPadding instead')
  static const EdgeInsets screen = AppSizes.screenPadding;
  @Deprecated('Use AppSizes.cardPadding instead')
  static const EdgeInsets card = AppSizes.cardPadding;
}


