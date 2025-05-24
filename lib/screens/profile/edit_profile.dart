import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/providers/vendor_profile_provider.dart';
import 'package:vendor_app/screens/subscription_plan.dart';
import 'package:vendor_app/services/translate.dart';
import 'package:vendor_app/utils/custom_network_image.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/utils/validator.dart';
import 'package:vendor_app/widgets/buttons/submit_button.dart';
import 'package:vendor_app/widgets/headers/common_appbar.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popup_menu_item.dart';
import 'package:vendor_app/widgets/popups/custom_popup.dart';
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
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController subscriptionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
    addressController.dispose();
    phoneController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    subscriptionController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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

    // Function to handle form submission
    Future<void> submit() async {
      try {
        bool isPasswordSame = Validators.isPasswordMatching(
          passwordController.text,
          confirmPasswordController.text,
        );
        if (!isPasswordSame) {
          showDialog(
            context: context,
            builder:
                (context) => CustomPopUp(
                  title: 'Password Mismatch',
                  message: 'Please ensure both passwords match.',
                  imagePath: 'assets/icons/error.jpg',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
          );
          return;
        }
        bool isSuccess = await profileProvider.updateVendorProfile(
          name: nameController.text,
          address: addressController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text,
          pincode: pincodeController.text,
          mobile: phoneController.text,
          password: passwordController.text,
          image: _selectedImage,
        );

        // Ensure the dialog is shown inside `Future.delayed`
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder:
                (context) => CustomPopUp(
                  title:
                      isSuccess
                          ? 'Successfully Updated Profile'
                          : 'Update Failed',
                  message:
                      isSuccess
                          ? 'All changes have been made to the profile'
                          : 'Something went wrong. Please try again.',
                  onPressed: () {
                    Navigator.pop(context);
                    Future.microtask(
                      () =>
                          Provider.of<VendorProfileProvider>(
                            context,
                            listen: false,
                          ).fetchVendorProfile(),
                    );
                  },
                ),
          );
        });
      } catch (e, stacktrace) {
        print("Error updating profile: $e\n$stacktrace");
      }
    }

    if (profileProvider.isLoading) {
      addressController.text = "Loading...";
      phoneController.text = "Loading...";
      cityController.text = "Loading...";
      stateController.text = "Loading...";
      countryController.text = "Loading...";
      subscriptionController.text = "Loading...";
      pincodeController.text = "Loading...";
      passwordController.text = "Loading...";
      nameController.text = "Loading...";
    } else if (profileProvider.vendorProfile != null) {
      final profile = profileProvider.vendorProfile!;
      addressController.text = profile.address ?? "";
      phoneController.text = profile.mobile ?? "";
      cityController.text = profile.city ?? "";
      stateController.text = profile.state ?? "";
      countryController.text = profile.country ?? "";
      subscriptionController.text = profile.subscriptionsName ?? "";
      pincodeController.text = profile.pincode ?? "";
      passwordController.text = ""; // Keeping password field empty
      nameController.text = profile.name ?? "No Name";
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
          title: TranslationService.translate(context, 'profile'),
          menuPressed: () {},
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/edit-popup-icon.svg',
              TranslationService.translate(context, 'edit'),
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
                      child:
                          _selectedImage != null
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
                label: TranslationService.translate(context, 'name'),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Trendy Fashions',
                controller: addressController,
                label: TranslationService.translate(context, 'store_name'),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: '+91 79901 87279',
                controller: phoneController,
                label: TranslationService.translate(context, 'phone_number'),
                isDisabled: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'kunaladwani@gmail.com',
                controller: cityController,
                label: TranslationService.translate(context, 'email'),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Maharashtra',
                controller: stateController,
                label: TranslationService.translate(context, 'state'),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'India',
                controller: countryController,
                label: TranslationService.translate(context, 'country'),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InputWidget(
                    hint: 'Advance Plan',
                    controller: subscriptionController,
                    label: TranslationService.translate(
                      context,
                      'change_subscription_plan',
                    ),
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
                          TranslationService.translate(context, 'upgrade'),
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
                hint: '400001',
                controller: pincodeController,
                label: TranslationService.translate(context, 'pincode'),
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Password',
                controller: passwordController,
                label: TranslationService.translate(context, 'password'),
                isPassword: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Password',
                controller: confirmPasswordController,
                label: TranslationService.translate(
                  context,
                  'confirm_password',
                ),
                isPassword: true,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),

              SubmitButton(
                text: TranslationService.translate(context, 'update_profile'),
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
