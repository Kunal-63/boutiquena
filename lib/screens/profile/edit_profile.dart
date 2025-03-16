import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/config/theme.dart';
import 'package:boutiquena_vendor/utils/custom_network_image.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:boutiquena_vendor/widgets/buttons/submit_button.dart';
import 'package:boutiquena_vendor/widgets/headers/common_appbar.dart';
import 'package:boutiquena_vendor/widgets/inputs/input_widgets.dart';
import 'package:boutiquena_vendor/widgets/popup_menu_item.dart';
import 'package:boutiquena_vendor/widgets/popups/custom_popup.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Profile",
          menuPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
                0, 'assets/icons/edit-popup-icon.svg', 'Edit')
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 15.0 * SizeConfig.heightScale,
          horizontal: 30 * SizeConfig.widthScale,
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.37),
            color: const Color.fromRGBO(255, 255, 255, 1),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 1),
              )
            ],
          ),
          child: Column(children: [
            Center(
              child: Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl:
                        'https://i.pinimg.com/736x/07/33/ba/0733ba760b29378474dea0fdbcb97107.jpg',
                    errorImage: 'assets/icons/no-image.png',
                    height: 100 * SizeConfig.widthScale,
                    width: 100 * SizeConfig.widthScale,
                    radius: 100 * SizeConfig.widthScale,
                  ),
                  Positioned(
                    bottom: 5 * SizeConfig.widthScale,
                    right: 5 * SizeConfig.widthScale,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(27, 46, 64, 1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            InputWidget(
              hint: 'Kunal Adwani',
              controller: _controller,
              label: 'Name',
              isDisabled: true,
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            InputWidget(
              hint: 'Trendy Fashions',
              controller: _controller,
              label: 'Store Name',
              isDisabled: true,
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            InputWidget(
              hint: '+91 79901 87279',
              controller: _controller,
              label: 'Phone Number',
              isDisabled: true,
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            InputWidget(
              hint: 'kunaladwani@gmail.com',
              controller: _controller,
              label: 'Email',
              isDisabled: true,
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            Stack(clipBehavior: Clip.none, children: [
              InputWidget(
                hint: 'Advance Plan',
                controller: _controller,
                label: 'Change Subscription Plan',
                isDisabled: true,
              ),
              Positioned(
                  right: 10 * SizeConfig.widthScale,
                  top: 35 * SizeConfig.heightScale,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.68),
                        color: AppTheme.buttonColor,
                      ),
                      child: Text(
                        'Upgrade',
                        style: AppTextStyles.whiteButtonStyle().copyWith(
                          color: Colors.white,
                          fontSize: 8 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
            ]),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            InputWidget(
              hint: 'Password',
              controller: _controller,
              label: 'Password',
              isPassword: true,
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            InputWidget(
              hint: 'Password',
              controller: _controller,
              label: 'Confirm Password',
              isPassword: true,
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            InputWidget(
              hint: '9:00AM - 9:00PM',
              controller: _controller,
              label: 'Working Hour',
              svgPath: 'assets/icons/clock-icon.svg',
            ),
            SizedBox(
              height: 10 * SizeConfig.heightScale,
            ),
            SubmitButton(
              text: 'Update Profile',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomPopUp(
                    title: 'Successfully Updated Profile',
                    message: 'All changes have been made to the profile',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            )
          ]),
        ),
      ),
    );
  }
}
