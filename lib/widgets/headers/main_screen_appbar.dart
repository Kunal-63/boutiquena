import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/providers/language_provider.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String errorImage;
  final VoidCallback onBellPressed;
  final VoidCallback onSettingsPressed;

  const CustomAppBar({
    required this.title,
    required this.imageUrl,
    required this.errorImage,
    required this.onBellPressed,
    required this.onSettingsPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: AppTheme.primaryColor,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(0, 0, 0, 0.1),
              ),
              child: CustomNetworkImage(
                imageUrl: imageUrl,
                errorImage: errorImage,
                radius: 33,
                height: 33,
                width: 33,
              ),
            ),
            Text(
              title,
              style: AppTextStyles.whitew400Outfit().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<String>(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  elevation: 0,
                  onSelected: (value) {
                    context.read<LanguageProvider>().setLanguage(value);
                  },
                  offset: const Offset(0, 30),
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
                  child: Icon(Icons.translate, size: 27, color: Colors.white),
                ),

                IconButton(
                  icon: SvgPicture.asset('assets/icons/settings-icon.svg'),
                  onPressed: onSettingsPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
