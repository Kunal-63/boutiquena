import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/providers/vendor_profile_provider.dart';
import 'package:vendor_app/screens/subscription_plan.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subscriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();
  int? subscripitonID;

  String profileImageUrl = '';
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<VendorProfileProvider>(
            context,
            listen: false,
          ).fetchVendorProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<VendorProfileProvider>(context);
    if (profileProvider.isLoading) {
      _storeNameController.text = "Loading...";
      _phoneController.text = "Loading...";
      _emailController.text = "Loading...";
      _subscriptionController.text = "Loading...";
      _passwordController.text = "Loading...";
      _workingHoursController.text = "Loading...";
      userName = "Loading...";
    } else if (profileProvider.vendorProfile != null) {
      final profile = profileProvider.vendorProfile!;

      _storeNameController.text = profile.storeDetails?.name ?? "";
      _phoneController.text = profile.mobile ?? "";
      _emailController.text = profile.email ?? "";
      _subscriptionController.text = profile.subscriptionsName ?? "";
      _passwordController.text = ""; // Keeping password field empty
      _workingHoursController.text = profile.storeDetails?.businessHours ?? "";
      userName = profile.name ?? "No Name";
      profileImageUrl =
          '${profile.imagePath?.trim().replaceAll(RegExp(r'\/$'), '')}/${profile.image ?? ""}';
      print("Final Image URL: $profileImageUrl");

      subscripitonID = profile.subscriptionId;
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Profile",
          menuPressed: () {},
          backPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              'Edit',
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 15.0 * SizeConfig.heightScale,
          horizontal: 30 * SizeConfig.widthScale,
        ),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl:
                        profileImageUrl.isNotEmpty
                            ? profileImageUrl
                            : 'assets/icons/no-image.png',
                    errorImage: 'assets/icons/no-image.png',
                    height: 100 * SizeConfig.widthScale,
                    width: 100 * SizeConfig.widthScale,
                    radius: 100 * SizeConfig.widthScale,
                  ),
                  Positioned(
                    bottom: 5 * SizeConfig.widthScale,
                    right: 5 * SizeConfig.widthScale,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/edit_profile');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(27, 46, 64, 1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/edit-image-icon.svg',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            Text(
              userName,
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            Container(
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
                  ),
                ],
              ),
              child: Column(
                children: [
                  InputWidget(
                    hint: 'Trendy Fashions',
                    controller: _storeNameController,
                    label: 'Store Name',
                    isDisabled: true,
                  ),
                  SizedBox(height: 10 * SizeConfig.heightScale),
                  InputWidget(
                    hint: '+91 79901 87279',
                    controller: _phoneController,
                    label: 'Phone Number',
                    isDisabled: true,
                  ),
                  SizedBox(height: 10 * SizeConfig.heightScale),
                  InputWidget(
                    hint: 'kunaladwani@gmail.com',
                    controller: _emailController,
                    label: 'Email',
                    isDisabled: true,
                  ),
                  SizedBox(height: 10 * SizeConfig.heightScale),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InputWidget(
                        hint: '',
                        controller: _subscriptionController,
                        label: 'Change Subscription Plan',
                        isDisabled: true,
                      ),
                      Positioned(
                        right: 10 * SizeConfig.widthScale,
                        top: 35 * SizeConfig.heightScale,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SubscriptionScreen(
                                      initialPlanId: subscripitonID,
                                      isEdit: true,
                                    ),
                              ),
                            );
                          },

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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * SizeConfig.heightScale),
                  InputWidget(
                    hint: '9:00AM - 9:00PM',
                    controller: _workingHoursController,
                    label: 'Working Hour',
                    svgPath: 'assets/icons/clock-icon.svg',
                  ),
                  SizedBox(height: 10 * SizeConfig.heightScale),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
