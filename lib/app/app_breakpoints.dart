import 'package:flutter/widgets.dart';

class AppBreakpoints {
  const AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
}

extension AppBreakpointContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isMobile => screenWidth < AppBreakpoints.mobile;

  double get mobileScale => isMobile ? 0.82 : 1;

  double compactValue(double value) => isMobile ? value * mobileScale : value;

  bool get isTablet =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.tablet;

  bool get isDesktop => screenWidth >= AppBreakpoints.tablet;
}
