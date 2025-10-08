import 'package:flutter/material.dart';

class ResponsiveWidget {
  final BuildContext context;
  late double _screenWidth;
  late double _screenHeight;

  ResponsiveWidget(this.context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  bool get isTablet => _screenWidth >= 600;
  bool get isPhone => _screenWidth < 600;

  /// Width as per screen size
  double width(double percentage) => _screenWidth * percentage;

  /// Height as per screen size
  double height(double percentage) => _screenHeight * percentage;

  /// Responsive text size
  double text(double size) => isTablet ? size * 1.5 : size;

  /// Responsive padding
  EdgeInsetsGeometry paddingAll(double value) =>
      EdgeInsets.all(isTablet ? value * 1.5 : value);

  EdgeInsetsGeometry paddingSymmetric({double vertical = 0, double horizontal = 0}) =>
      EdgeInsets.symmetric(
          vertical: isTablet ? vertical * 1.5 : vertical,
          horizontal: isTablet ? horizontal * 1.5 : horizontal);  

  /// Responsive radius
  double radius(double value) => isTablet ? value * 1.5 : value;
}
