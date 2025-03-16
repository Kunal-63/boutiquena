import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/config/theme.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isTransparent;

  const SubmitButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppTheme.buttonColor,
    this.textColor,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isTransparent
            ? const Color.fromRGBO(255, 255, 255, 1)
            : (backgroundColor ?? AppTheme.buttonColor),
        side: isTransparent
            ? const BorderSide(color: AppTheme.primaryColor, width: 1)
            : BorderSide.none,
        minimumSize: Size(double.infinity, 50 * SizeConfig.heightScale),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.whiteButtonStyle().copyWith(
          color: isTransparent
              ? AppTheme.primaryColor
              : (textColor ?? Colors.white),
        ),
      ),
    );
  }
}
