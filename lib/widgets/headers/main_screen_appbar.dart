import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String errorImage;
  final VoidCallback onBellPressed;
  final VoidCallback onHeartPressed;
  final VoidCallback onMenuPressed;

  const CustomAppBar({
    required this.title,
    required this.imageUrl,
    required this.errorImage,
    required this.onBellPressed,
    required this.onHeartPressed,
    required this.onMenuPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(154, 174, 170, 1),
            Color.fromRGBO(104, 160, 155, 1),
            Color.fromRGBO(59, 141, 134, 1),
            Color.fromRGBO(31, 88, 84, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   padding: const EdgeInsets.all(5),
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Color.fromRGBO(0, 0, 0, 0.1),
            //   ),
            //   child: CustomNetworkImage(
            //     imageUrl: imageUrl,
            //     errorImage: errorImage,
            //     radius: 33,
            //     height: 33,
            //     width: 33,
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "BOUTIQUE",
                      style: AppTextStyles.whitew400Outfit().copyWith(
                        fontSize: 18 * SizeConfig.widthScale,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'NA',
                      style: AppTextStyles.whitew400Outfit().copyWith(
                        fontSize: 18 * SizeConfig.widthScale,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Handle tap on the title
                  },
                  child: Row(
                    children: [
                      Text(
                        'Change Language',
                        style: AppTextStyles.whitew400Outfit().copyWith(
                          fontSize: 12 * SizeConfig.widthScale,

                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset('assets/icons/arrow-down-icon.svg'),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/notification-icon.svg',
                      ),
                      onPressed: onBellPressed,
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/heart-icon.svg'),
                      onPressed: onHeartPressed,
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/icons/menu-icon.svg'),
                      onPressed: onMenuPressed,
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
