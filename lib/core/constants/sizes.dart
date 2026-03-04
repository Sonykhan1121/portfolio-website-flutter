import 'package:flutter/material.dart';

import 'break_points.dart';


enum ScreenType { mobile, tablet, desktop }

class Sizes {
  // Determine screen type from width.
  static ScreenType screenTypeFromWidth(double width) {
    if (width < Breakpoints.mobile) return ScreenType.mobile;
    if (width < Breakpoints.tablet) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  // Determine screen type from BuildContext using MediaQuery.
  static ScreenType screenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return screenTypeFromWidth(width);
  }

  // Generic helper that returns the appropriate value for the current width.
  // Provide mobile/tablet/desktop values; desktop will default to tablet if null.
  static double responsiveValue({
    required double width,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final type = screenTypeFromWidth(width);
    switch (type) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  // Same as above but accepts BuildContext for convenience.
  static double responsive({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    return responsiveValue(width: width, mobile: mobile, tablet: tablet, desktop: desktop);
  }

  // -- Specific helpers requested by the user --
  // These replicate the example values you provided.

  // descriptionFontSize = isMobile ? 14.0 : isTablet ? 15.0 : 16.0;
  static double descriptionFontSize(BuildContext context) =>
      responsive(context: context, mobile: 14.0, tablet: 15.0, desktop: 16.0);

  // sectionTitleFontSize = isMobile ? 11.0 : 12.0;
  // (we'll use 12.0 for tablet and desktop by default)
  static double sectionTitleFontSize(BuildContext context) =>
      responsive(context: context, mobile: 11.0, tablet: 12.0, desktop: 12.0);

  // platformLabelFontSize = isMobile ? 13.0 : 15.0;
  static double platformLabelFontSize(BuildContext context) =>
      responsive(context: context, mobile: 13.0, tablet: 15.0, desktop: 15.0);

  // competencyFontSize = isMobile ? 12.0 : 13.0;
  static double competencyFontSize(BuildContext context) =>
      responsive(context: context, mobile: 12.0, tablet: 13.0, desktop: 13.0);

  // -- Spacing/Padding --
  // horizontalPadding = isMobile ? 16.0 : 20.0;
  static double horizontalPadding(BuildContext context) =>
      responsive(context: context, mobile: 16.0, tablet: 20.0, desktop: 24.0);

  // verticalPadding = isMobile ? 40.0 : 60.0;
  static double verticalPadding(BuildContext context) =>
      responsive(context: context, mobile: 40.0, tablet: 60.0, desktop: 80.0);

  // sectionSpacing = isMobile ? 30.0 : 40.0;
  static double sectionSpacing(BuildContext context) =>
      responsive(context: context, mobile: 30.0, tablet: 40.0, desktop: 56.0);

  // elementSpacing = isMobile ? 20.0 : 24.0;
  static double elementSpacing(BuildContext context) =>
      responsive(context: context, mobile: 20.0, tablet: 24.0, desktop: 32.0);

  // -- Grid / component sizes --
  // platformButtonHeight = isMobile ? 100.0 : 120.0;
  static double platformButtonHeight(BuildContext context) =>
      responsive(context: context, mobile: 100.0, tablet: 120.0, desktop: 140.0);

  // platformSpacing = isMobile ? 12.0 : 16.0;
  static double platformSpacing(BuildContext context) =>
      responsive(context: context, mobile: 12.0, tablet: 16.0, desktop: 20.0);

  // -- Common typography helpers (mapped by category) --
  static double h1(BuildContext context) =>
      responsive(context: context, mobile: 24.0, tablet: 28.0, desktop: 32.0);
  static double h2(BuildContext context) =>
      responsive(context: context, mobile: 20.0, tablet: 24.0, desktop: 28.0);
  static double h3(BuildContext context) =>
      responsive(context: context, mobile: 18.0, tablet: 20.0, desktop: 24.0);
  static double h4(BuildContext context) =>
      responsive(context: context, mobile: 16.0, tablet: 18.0, desktop: 20.0);
  static double body(BuildContext context) =>
      responsive(context: context, mobile: 14.0, tablet: 16.0, desktop: 16.0);
  static double small(BuildContext context) =>
      responsive(context: context, mobile: 12.0, tablet: 13.0, desktop: 14.0);
  static double caption(BuildContext context) =>
      responsive(context: context, mobile: 10.0, tablet: 12.0, desktop: 12.0);
}

/// BuildContext extensions for convenient usage in widgets.
extension SizeExtensions on BuildContext {
  ScreenType get screenType => Sizes.screenType(this);

  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;
  bool get isDesktop => screenType == ScreenType.desktop;

  double get descriptionFontSize => Sizes.descriptionFontSize(this);
  double get sectionTitleFontSize => Sizes.sectionTitleFontSize(this);
  double get platformLabelFontSize => Sizes.platformLabelFontSize(this);
  double get competencyFontSize => Sizes.competencyFontSize(this);

  double get horizontalPadding => Sizes.horizontalPadding(this);
  double get verticalPadding => Sizes.verticalPadding(this);
  double get sectionSpacing => Sizes.sectionSpacing(this);
  double get elementSpacing => Sizes.elementSpacing(this);
  double get platformButtonHeight => Sizes.platformButtonHeight(this);
  double get platformSpacing => Sizes.platformSpacing(this);

  // Typography getters
  double get h1 => Sizes.h1(this);
  double get h2 => Sizes.h2(this);
  double get h3 => Sizes.h3(this);
  double get h4 => Sizes.h4(this);
  double get body => Sizes.body(this);
  double get small => Sizes.small(this);
  double get caption => Sizes.caption(this);

  TextStyle textStyle(double mobile, {double? tablet, double? desktop, FontWeight weight = FontWeight.normal, Color? color}) {
    final val = Sizes.responsive(context: this, mobile: mobile, tablet: tablet, desktop: desktop);
    return TextStyle(fontSize: val, fontWeight: weight, color: color);
  }
}

/// Usage example (inside a widget build):
/// final isMobile = context.isMobile;
/// final titleSize = context.sectionTitleFontSize;
/// Text('Title', style: context.textStyle(11, tablet: 12));
