import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isTransparent;
  final double radius;

  const SubmitButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppTheme.buttonColor,
    this.textColor,
    this.isTransparent = false,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isTransparent
                ? const Color.fromRGBO(255, 255, 255, 1)
                : (backgroundColor ?? AppTheme.buttonColor),
        side:
            isTransparent
                ? const BorderSide(color: AppTheme.primaryColor, width: 1)
                : BorderSide.none,
        minimumSize: Size(double.infinity, 50 * SizeConfig.heightScale),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.whiteButtonStyle().copyWith(
          color:
              isTransparent
                  ? AppTheme.primaryColor
                  : (textColor ?? Colors.white),
        ),
      ),
    );
  }
}
