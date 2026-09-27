import 'package:flutter/material.dart';
import 'package:follio/core/tokens/design_tokens.dart';

enum ScreenType { mobile, tablet, desktop }

abstract final class ResponsiveUtils {
  static ScreenType getScreenType(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < DesignTokens.breakpointMobile) {
      return ScreenType.mobile;
    } else if (width < DesignTokens.breakpointTablet) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < DesignTokens.breakpointMobile;

  static bool isTablet(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return width >= DesignTokens.breakpointMobile && width < DesignTokens.breakpointTablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= DesignTokens.breakpointTablet;

  static bool shouldCollapseNav(BuildContext context) =>
      MediaQuery.sizeOf(context).width < DesignTokens.breakpointNavCollapse;

  static double horizontalPadding(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < DesignTokens.breakpointMobile) {
      return DesignTokens.space16;
    } else if (width < DesignTokens.breakpointTablet) {
      return DesignTokens.space24;
    } else {
      return DesignTokens.space32;
    }
  }
}
