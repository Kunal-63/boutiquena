import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopupMenuHelper {
  static PopupMenuItem<int> buildPopupMenuItem(
    int value,
    String svgPath,
    String text,
  ) {
    return PopupMenuItem<int>(
      onTap: () async {},
      value: value,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              color: const Color.fromRGBO(237, 127, 50, 1),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 16 * SizeConfig.widthScale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
