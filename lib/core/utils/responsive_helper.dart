import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1100) return DeviceType.desktop;
    if (width >= 650) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  // Fluid font scaling
  static double fontSize(BuildContext context, double mobile,
      {double? tablet, double? desktop}) {
    switch (getDeviceType(context)) {
      case DeviceType.desktop:
        return desktop ?? (mobile * 1.3);
      case DeviceType.tablet:
        return tablet ?? (mobile * 1.15);
      case DeviceType.mobile:
        return mobile;
    }
  }

  // Fluid spacing
  static double spacing(BuildContext context, double mobile,
      {double? tablet, double? desktop}) {
    switch (getDeviceType(context)) {
      case DeviceType.desktop:
        return desktop ?? (mobile * 1.5);
      case DeviceType.tablet:
        return tablet ?? (mobile * 1.25);
      case DeviceType.mobile:
        return mobile;
    }
  }

  // Horizontal padding
  static double horizontalPadding(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.desktop:
        return 80;
      case DeviceType.tablet:
        return 40;
      case DeviceType.mobile:
        return 20;
    }
  }

  // Content max width for desktop
  static double maxContentWidth(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.desktop:
        return 1200;
      case DeviceType.tablet:
        return 800;
      case DeviceType.mobile:
        return double.infinity;
    }
  }

  // Grid column count
  static int gridColumns(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.desktop:
        return 4;
      case DeviceType.tablet:
        return 2;
      case DeviceType.mobile:
        return 1;
    }
  }

  // Chart height
  static double chartHeight(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.desktop:
        return 240;
      case DeviceType.tablet:
        return 200;
      case DeviceType.mobile:
        return 160;
    }
  }

  // Card height for swipeable stack
  static double swipeCardHeight(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.desktop:
        return 280;
      case DeviceType.tablet:
        return 240;
      case DeviceType.mobile:
        return 200;
    }
  }
}