import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import 'theme.dart';

class AppTextStyles {
  static TextStyle customStyle({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = Colors.black,
    String fontFamily = 'Outfit',
  }) {
    return TextStyle(
      fontSize: size * SizeConfig.widthScale,
      fontWeight: weight,
      color: color,
      fontFamily: fontFamily,
    );
  }

  // 🔵 Heading Styles
  static TextStyle loginHeadingStyle({Color color = AppTheme.primaryColor}) {
    return customStyle(
      size: 24 * SizeConfig.widthScale,
      weight: FontWeight.w400,
      color: color,
      fontFamily: 'Overlock',
    );
  }

  static TextStyle blackHeadingStyle({Color color = Colors.black}) {
    return customStyle(
      size: 24 * SizeConfig.widthScale,
      weight: FontWeight.w500,
      color: color,
    );
  }

  // 🟢 SubHeading Styles
  static TextStyle loginSubHeadingStyle({Color color = Colors.black}) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle greySubHeadingStyle({
    Color color = const Color.fromRGBO(112, 112, 112, 1),
  }) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle signupSubHeadingStyle({
    Color color = AppTheme.primaryColor,
  }) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle blackSubHeadingStyle({
    Color color = const Color.fromRGBO(37, 38, 38, 1),
  }) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle whitew400Outfit({
    Color color = const Color.fromRGBO(255, 255, 255, 1),
  }) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle redw400Outfit({
    Color color = const Color.fromRGBO(243, 120, 102, 1),
  }) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w500,
      color: color,
    );
  }

  // 🟠 Input Text Styles
  static TextStyle inputHintStyle({Color color = AppTheme.inputHintColor}) {
    return customStyle(
      size: 14 * SizeConfig.widthScale,
      weight: FontWeight.w300,
      color: color,
    );
  }

  static TextStyle inputLabelStyle({
    Color color = const Color.fromRGBO(37, 38, 38, 1),
  }) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w400,
      color: color,
    );
  }

  // 🔴 Button Text Styles
  static TextStyle whiteButtonStyle({Color color = Colors.white}) {
    return customStyle(
      size: 16 * SizeConfig.widthScale,
      weight: FontWeight.w500,
      color: color,
    );
  }
}
