import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/providers/vendor_profile_provider.dart';
import 'package:customer_app/screens/subscription_plan.dart';
import 'package:customer_app/utils/custom_network_image.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:customer_app/widgets/popups/custom_popup.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  int? subscripitonID;
  String profileImageUrl = '';
  // Controllers for input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subscriptionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController workingHoursController = TextEditingController();

  /// Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    nameController.dispose();
    storeNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    subscriptionController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    workingHoursController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<VendorProfileProvider>(
        context,
        listen: false,
      ).fetchVendorProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<VendorProfileProvider>(context);
    Future<void> submit() async {
      try {
        bool isSuccess = await profileProvider.updateVendorProfile(
          name: nameController.text,
          address: 'a',
          city: 'a',
          state: 'a',
          country: 'a',
          pincode: '123456',
          mobile: phoneController.text,
          password: passwordController.text,
        );

        // Ensure the dialog is shown inside `Future.delayed`
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (context) => CustomPopUp(
              title:
                  isSuccess ? 'Successfully Updated Profile' : 'Update Failed',
              message: isSuccess
                  ? 'All changes have been made to the profile'
                  : 'Something went wrong. Please try again.',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
      } catch (e, stacktrace) {
        print("Error updating profile: $e\n$stacktrace");
      }
    }

    if (profileProvider.isLoading) {
      storeNameController.text = "Loading...";
      phoneController.text = "Loading...";
      emailController.text = "Loading...";
      subscriptionController.text = "Loading...";
      passwordController.text = "Loading...";
      workingHoursController.text = "Loading...";
      nameController.text = "Loading...";
    } else if (profileProvider.vendorProfile != null) {
      final profile = profileProvider.vendorProfile!;
      storeNameController.text = profile.storeDetails?.name ?? "";
      phoneController.text = profile.mobile ?? "";
      emailController.text = profile.email ?? "";
      subscriptionController.text = profile.subscriptionsName ?? "";
      passwordController.text = ""; // Keeping password field empty
      workingHoursController.text = profile.storeDetails?.businessHours ?? "";
      nameController.text = profile.name ?? "No Name";
      profileImageUrl = profile.imagePath ?? "";
      subscripitonID = profile.subscriptionId;
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Profile",
          menuPressed: () {},
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
              ),
            ],
          ),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        100 * SizeConfig.widthScale,
                      ),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 100 * SizeConfig.widthScale,
                              width: 100 * SizeConfig.widthScale,
                              fit: BoxFit.cover,
                            )
                          : CustomNetworkImage(
                              imageUrl: profileImageUrl,
                              errorImage: 'assets/icons/no-image.png',
                              height: 100 * SizeConfig.widthScale,
                              width: 100 * SizeConfig.widthScale,
                              radius: 100 * SizeConfig.widthScale,
                            ),
                    ),
                    Positioned(
                      bottom: 5 * SizeConfig.widthScale,
                      right: 5 * SizeConfig.widthScale,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(27, 46, 64, 1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Kunal Adwani',
                controller: nameController,
                label: 'Name',
                isDisabled: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Trendy Fashions',
                controller: storeNameController,
                label: 'Store Name',
                isDisabled: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: '+91 79901 87279',
                controller: phoneController,
                label: 'Phone Number',
                isDisabled: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'kunaladwani@gmail.com',
                controller: emailController,
                label: 'Email',
                isDisabled: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InputWidget(
                    hint: 'Advance Plan',
                    controller: subscriptionController,
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
                            builder: (context) => SubscriptionScreen(
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
                hint: 'Password',
                controller: passwordController,
                label: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Password',
                controller: confirmPasswordController,
                label: 'Confirm Password',
                isPassword: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: '9:00AM - 9:00PM',
                controller: workingHoursController,
                label: 'Working Hour',
                svgPath: 'assets/icons/clock-icon.svg',
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              SubmitButton(text: 'Update Profile', onPressed: submit),
            ],
          ),
        ),
      ),
    );
  }
}
