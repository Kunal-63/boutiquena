import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:flutter/material.dart';

class CustomPopUp extends StatefulWidget {
  final String title;
  final String? message;
  final VoidCallback onPressed;
  final Widget? customMessageWidget;
  final String imagePath;

  const CustomPopUp({
    super.key,
    required this.title,
    this.message,
    required this.onPressed,
    this.customMessageWidget,
    this.imagePath = 'assets/icons/confetti.png',
  });

  @override
  _CustomPopUpState createState() => _CustomPopUpState();
}

class _CustomPopUpState extends State<CustomPopUp> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(248, 248, 248, 1),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(5 * SizeConfig.widthScale),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 15 * SizeConfig.widthScale),
                ),
              ),
            ),
            Image.asset(
              widget.imagePath,
              height: 100 * SizeConfig.widthScale,
              width: 100 * SizeConfig.widthScale,
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            Text(
              widget.title,
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5 * SizeConfig.heightScale),
            widget.customMessageWidget ??
                (widget.message != null
                    ? Text(
                        widget.message!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.blackSubHeadingStyle().copyWith(
                          fontSize: 16 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    : const SizedBox.shrink()),
            SizedBox(height: 20 * SizeConfig.heightScale),
            SubmitButton(text: 'Ok', onPressed: widget.onPressed),
            SizedBox(height: 5 * SizeConfig.heightScale),
          ],
        ),
      ),
    );
  }
}
