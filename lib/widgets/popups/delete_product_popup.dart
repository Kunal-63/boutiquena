import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/buttons/submit_button.dart';
import 'package:flutter/material.dart';

class DeletePopUp extends StatefulWidget {
  final String? message;
  final VoidCallback onPressed;
  const DeletePopUp({super.key, this.message, required this.onPressed});

  @override
  _DeletePopUpState createState() => _DeletePopUpState();
}

class _DeletePopUpState extends State<DeletePopUp> {
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
            Text(
              widget.message!,
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20 * SizeConfig.heightScale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SubmitButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    isTransparent: true,
                  ),
                ),
                SizedBox(width: 20 * SizeConfig.widthScale),
                Expanded(
                  child: SubmitButton(
                    text: 'Delete',
                    onPressed: widget.onPressed,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5 * SizeConfig.heightScale),
          ],
        ),
      ),
    );
  }
}
