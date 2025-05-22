import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/providers/language_provider.dart';
import 'package:customer_app/utils/secure_storage.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
                PopupMenuButton<String>(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  elevation: 0,
                  onSelected: (value) {
                    context.read<LanguageProvider>().setLanguage(value);
                  },

                  offset: const Offset(0, 30), // Positioning the popup
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'en',
                          child: Text('English'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'ar',
                          child: Text('Arabic'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'he',
                          child: Text('Hebrew'),
                        ),
                      ],
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
