import 'dart:io';
import 'package:customer_app/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:customer_app/providers/customer_profile_provider.dart';
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
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
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

    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<CustomerProfileProvider>(
            context,
            listen: false,
          ).fetchCustomerProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<CustomerProfileProvider>(context);
    Future<void> submit() async {
      if ((Validators.isPasswordMatching(
            passwordController.text,
            confirmPasswordController.text,
          )) &&
          passwordController.text.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }
      try {
        bool isSuccess = await profileProvider.updateCustomerProfile(
          name: nameController.text,
          address: addressController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text,
          pincode: pincodeController.text,
          mobile: phoneController.text,
          password: passwordController.text,
          profileImage: _selectedImage,
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

      passwordController.text = "Loading...";

      nameController.text = "Loading...";
    } else if (profileProvider.vendorProfile != null) {
      final profile = profileProvider.vendorProfile!;

      phoneController.text = profile.mobile ?? "";

      passwordController.text = "";
      confirmPasswordController.text = "";
      addressController.text = profile.address ?? "No Address";
      cityController.text = profile.city ?? "No City";
      stateController.text = profile.state ?? "No State";
      countryController.text = profile.country ?? "No Country";
      pincodeController.text = profile.pincode ?? "No Pincode";
      nameController.text = profile.name ?? "No Name";
      profileImageUrl = '${profile.imagePath}/${profile.image}';
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
                            color: Color.fromRGBO(31, 88, 84, 1),
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
                hint: 'Enter your name',
                controller: nameController,
                label: 'Name',
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Enter your city',
                controller: cityController,
                label: 'City',
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Enter your state',
                controller: stateController,
                label: 'State',
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Enter your country',
                controller: countryController,
                label: 'Country',
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Enter your pincode',
                controller: pincodeController,
                label: 'Pincode',
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),

              InputWidget(
                hint: 'Enter your address',
                controller: addressController,
                label: 'Address',
                maxLines: 3,
              ),
              SizedBox(height: 10 * SizeConfig.heightScale),
              InputWidget(
                hint: 'Enter your phone number',
                controller: phoneController,
                label: 'Phone Number',
                isDisabled: true,
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

              SubmitButton(text: 'Update Profile', onPressed: submit),
            ],
          ),
        ),
      ),
    );
  }
}
