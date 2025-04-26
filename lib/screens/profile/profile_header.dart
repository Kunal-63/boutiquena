import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String profileImageUrl;
  final VoidCallback? onSettingsTap;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top row with profile pic, name and settings
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              CustomNetworkImage(
                imageUrl: '$profileImageUrl',
                errorImage: 'assets/icons/no-image.png',
                height: 40 * SizeConfig.widthScale,
                width: 40 * SizeConfig.widthScale,
                radius: 40 * SizeConfig.widthScale,
              ),
              SizedBox(width: 10 * SizeConfig.widthScale),
              Expanded(
                child: Text(
                  'Hello, $userName',
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontSize: 14 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSettingsTap,
                child: SvgPicture.asset(
                  'assets/icons/settings-icon.svg',
                  height: 20 * SizeConfig.widthScale,
                  colorFilter: ColorFilter.mode(
                    Color.fromRGBO(112, 112, 112, 1),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 38 * SizeConfig.widthScale,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _profileActionButton('Wishlist'),
              _profileActionButton('Order'),
              _profileActionButton('Recently viewed'),
              _profileActionButton('Your rewards'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileActionButton(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Color.fromRGBO(112, 112, 112, 1), width: 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 13),
        ),
      ),
    );
  }
}
