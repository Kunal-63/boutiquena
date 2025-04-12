import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/config/text_styles.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color borderColor;
  final Color fillColor;
  final String tickAsset;

  const CustomCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.borderColor,
    required this.fillColor,
    required this.tickAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 20 * SizeConfig.widthScale,
            height: 20 * SizeConfig.widthScale,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: value ? fillColor : Colors.transparent,
              border: Border.all(color: borderColor, width: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Center(
                    child: SvgPicture.asset(
                      tickAsset,
                      width: 14 * SizeConfig.widthScale,
                      height: 14 * SizeConfig.widthScale,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 10 * SizeConfig.widthScale),
          Text(
            label,
            style: AppTextStyles.greySubHeadingStyle().copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
