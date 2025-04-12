import 'package:customer_app/config/theme.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/config/text_styles.dart';

class SignUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const SignUpAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 130.0 * SizeConfig.heightScale,
          padding: EdgeInsets.only(bottom: 30 * SizeConfig.heightScale),
          decoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(70.0),
              bottomRight: Radius.circular(70.0),
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: title ?? 'BOUTIQUE',
                style: title == null
                    ? AppTextStyles.loginHeadingStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 5.0,
                        color: Colors.white,
                      )
                    : AppTextStyles.loginHeadingStyle().copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 24 * SizeConfig.widthScale,
                        // letterSpacing: 5.0,
                        color: Colors.white,
                        fontFamily: 'Outfit',
                      ),
                children: <TextSpan>[
                  if (title == null)
                    TextSpan(
                      text: 'NA',
                      style: AppTextStyles.loginHeadingStyle().copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 5.0,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(130.0 * SizeConfig.heightScale);
}
