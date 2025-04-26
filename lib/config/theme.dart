import 'package:customer_app/config/text_styles.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class AppTheme {
  // 🎨 Color Palette
  static const primaryColor = Color.fromRGBO(31, 88, 84, 1);
  static const secondaryColor = Colors.green;
  static const accentColor = Colors.orange;
  static const backgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const borderColor = Color.fromRGBO(219, 233, 233, 1);
  static const inputHintColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const buttonColor = Color.fromRGBO(31, 88, 84, 1);

  // 🔲 Borders
  static const double borderWidth = 0.94;
  static const double borderRadius = 8.0;

  // 🛠️ Input Decoration
  static final InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: borderColor, width: borderWidth),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: borderColor, width: borderWidth),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: borderColor, width: borderWidth),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16 * SizeConfig.widthScale,
      vertical: 12 * SizeConfig.widthScale,
    ),
    hintStyle: AppTextStyles.inputHintStyle(),
    labelStyle: AppTextStyles.inputHintStyle(),
  );

  // 🌞 Light Theme
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
  );

  // 🌙 Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
  );
}
