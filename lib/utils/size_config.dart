import 'package:flutter/widgets.dart';

class SizeConfig {
  static double widthScale = 1.0;
  static double heightScale = 1.0;
  static double screenHeight = 0.0;
  static double screenWidth = 0.0;

  static void init(BuildContext context) {
    double baseWidth = 390.0;
    double baseHeight = 850.0; // Your base design height

    widthScale = MediaQuery.of(context).size.width / baseWidth;
    heightScale = MediaQuery.of(context).size.height / baseHeight;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}
