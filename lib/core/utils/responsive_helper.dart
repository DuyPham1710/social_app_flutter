import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// - Mobile: width < 768
/// - Tablet: 768 ≤ width < 1200
/// - Desktop: width ≥ 1200
class ResponsiveHelper {
  static const double mobileBreakpoint = 768;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static bool shouldShowSidebar(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }

  /// Max width for the feed content area on web/desktop.
  static const double feedMaxWidth = 630;

  /// Width of the collapsed sidebar (icon only).
  static const double sidebarCollapsedWidth = 72;

  /// Width of the expanded sidebar (icon + text label).
  static const double sidebarExpandedWidth = 240;
}

extension ResponsiveNum on num {
  /// Responsive size (width/general scaling)
  double rs(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return w;
    }
    return toDouble();
  }

  /// Responsive height
  double rsh(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return h;
    }
    return toDouble();
  }

  /// Responsive font size (sp)
  double rsp(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return sp;
    }
    return toDouble();
  }

  /// Responsive radius (r)
  double rsr(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return r;
    }
    return toDouble();
  }
}
