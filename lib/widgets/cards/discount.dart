import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:flutter/material.dart';

class DiscountCouponWidget extends StatelessWidget {
  final String discountText;
  final String discount;
  final String productType;
  final String productName;
  final String oldPrice;
  final String newPrice;

  const DiscountCouponWidget({
    super.key,
    required this.discountText,
    required this.discount,
    required this.productType,
    required this.productName,
    required this.oldPrice,
    required this.newPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80 * SizeConfig.heightScale,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10.37),
      ),
      child: Row(
        children: [
          ClipPath(
            clipper: ZigZagClipper(),
            child: Container(
              width: 100 * SizeConfig.widthScale,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.37),
                  bottomLeft: Radius.circular(10.37),
                ),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: discountText,
                    style: AppTextStyles.whitew400Outfit().copyWith(
                      fontSize: 14 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' $discount',
                        style: AppTextStyles.whitew400Outfit().copyWith(
                          fontSize: 14 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '\nOFF',
                        style: AppTextStyles.whitew400Outfit().copyWith(
                          fontSize: 14 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  productType,
                  style: AppTextStyles.greySubHeadingStyle().copyWith(
                    fontSize: 12 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  productName,
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontSize: 14 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                oldPrice,
                style: AppTextStyles.greySubHeadingStyle().copyWith(
                  fontSize: 12 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                newPrice,
                style: AppTextStyles.redw400Outfit().copyWith(
                  fontSize: 14 * SizeConfig.widthScale,
                  fontWeight: FontWeight.w600,
                  // decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double zigzagHeight = size.height / 12;
    double zigzagWidth = 10;
    bool up = true;
    path.lineTo(size.width, 0);

    for (double i = 0; i <= size.height; i += zigzagHeight) {
      if (up) {
        path.lineTo(size.width - zigzagWidth, i);
      } else {
        path.lineTo(size.width, i);
      }
      up = !up;
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
