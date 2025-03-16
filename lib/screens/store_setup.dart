import 'dart:convert';
import 'dart:io';

import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/config/theme.dart';
import 'package:boutiquena_vendor/services/api_service.dart';
import 'package:boutiquena_vendor/services/log_service.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:boutiquena_vendor/widgets/buttons/checkbox.dart';
import 'package:boutiquena_vendor/widgets/buttons/submit_button.dart';
import 'package:boutiquena_vendor/widgets/headers/signup_appbar.dart';
import 'package:boutiquena_vendor/widgets/inputs/dropdown.dart';
import 'package:boutiquena_vendor/widgets/inputs/input_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  _StoreSetupScreenState createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController additionalPhoneController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedCity;
  bool storeTypeOnline = false;
  bool storeTypeOffline = false;
  File? storeLogo;
  File? storeCover;
  List<String> cities = [];
  List<dynamic> storeTypes = [];
  Map<int, bool> selectedStoreTypes = {};

  @override
  void initState() {
    super.initState();
    fetchCities();
    fetchStoreType().then((_) => fetchData());
  }

  Future<void> pickImage() async {
    var status = await Permission.photos.request();

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          storeLogo = File(image.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission Denied to access Gallery')),
      );
    }
  }

  Future<void> pickCoverImage() async {
    var status = await Permission.photos.request();

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          storeCover = File(image.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission Denied to access Gallery')),
      );
    }
  }

  Future<void> fetchStoreType() async {
    try {
      final response = await ApiService.get('get-store-type');

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == true && data["data"] != null) {
          setState(() {
            storeTypes = List.from(data["data"]);
            for (var type in storeTypes) {
              selectedStoreTypes[type["id"]] = false;
            }
          });
        } else {
          throw Exception("Failed to fetch store types");
        }
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      LogService.error("fetchCategories() Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load store types: $e')),
      );
    }
  }

  Future<void> fetchCities() async {
    try {
      final response = await ApiService.get('get-city');

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] is List) {
          setState(() {
            cities =
                List<String>.from(data['data'].map((city) => city['name']));
          });
        } else {
          throw Exception("Invalid data format");
        }
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      LogService.error("fetchCities() Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cities: $e')),
      );
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await ApiService.getWithAuth('store-details');
      print("FETCH DATA RESPONSE " + response!.body);
      if (response == null) {
        throw Exception("No response from server");
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final storeData = data['data'];

          setState(() {
            nameController.text = storeData['name'] ?? "";
            addressController.text = storeData['detailed_address'] ?? "";
            phoneController.text = storeData['store_link'] ?? "";
            emailController.text = storeData['description'] ?? "";
            selectedCity = storeData['address'] ?? "";

            int? storeTypeId = storeData['store_type'];
            if (storeTypeId != null &&
                selectedStoreTypes.containsKey(storeTypeId)) {
              selectedStoreTypes.forEach((key, value) {
                selectedStoreTypes[key] = (key == storeTypeId);
              });
            }
          });
        } else {
          throw Exception("Invalid data format");
        }
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      LogService.error("fetchData() Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load store details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SignUpAppBar(title: 'Set-up Your Store'),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 30 * SizeConfig.widthScale),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25 * SizeConfig.heightScale),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10 * SizeConfig.widthScale),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputWidget(
                          label: 'Store Name',
                          hint: 'Enter your name..',
                          isRequired: true,
                          controller: nameController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        Row(
                          children: [
                            Text(
                              'Store Logo',
                              style: AppTextStyles.inputLabelStyle(),
                            ),
                            Text(
                              ' *',
                              style: AppTextStyles.inputLabelStyle()
                                  .copyWith(color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: 10 * SizeConfig.heightScale),
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 120 * SizeConfig.heightScale,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0, 0, 0, 0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: storeLogo == null
                                ? Center(
                                    child: SvgPicture.asset(
                                        'assets/icons/add-icon.svg'),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(storeLogo!,
                                        fit: BoxFit.cover)),
                          ),
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        Row(
                          children: [
                            Text(
                              'Store Cover Image',
                              style: AppTextStyles.inputLabelStyle(),
                            ),
                            Text(
                              ' *',
                              style: AppTextStyles.inputLabelStyle()
                                  .copyWith(color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: 10 * SizeConfig.heightScale),
                        GestureDetector(
                          onTap: pickCoverImage,
                          child: Container(
                            width: double.infinity,
                            height: 120 * SizeConfig.heightScale,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0, 0, 0, 0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: storeCover == null
                                ? Center(
                                    child: SvgPicture.asset(
                                        'assets/icons/add-icon.svg'),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(storeCover!,
                                        fit: BoxFit.cover)),
                          ),
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        CustomDropdown(
                          isRequired: true,
                          label: 'City',
                          items: cities,
                          selectedItem: selectedCity,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              selectedCity = newValue as String?;
                            });
                          },
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Full Address',
                          hint: 'Block no, street, area, pincode',
                          isRequired: true,
                          controller: addressController,
                          maxLines: 3,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        Row(
                          children: [
                            Text(
                              'Store Type',
                              style: AppTextStyles.inputLabelStyle(),
                            ),
                            Text(
                              ' *',
                              style: AppTextStyles.inputLabelStyle()
                                  .copyWith(color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10 * SizeConfig.heightScale,
                        ),
                        if (storeTypes.isEmpty)
                          const CircularProgressIndicator()
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: storeTypes.map((type) {
                              return Expanded(
                                child: CustomCheckbox(
                                  label: type["name"], // Dynamically set label
                                  value:
                                      selectedStoreTypes[type["id"]] ?? false,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      selectedStoreTypes
                                          .updateAll((key, value) => false);

                                      selectedStoreTypes[type["id"]] =
                                          newValue ?? false;
                                    });
                                  },
                                  borderColor:
                                      const Color.fromRGBO(0, 0, 0, 0.5),
                                  fillColor:
                                      const Color.fromRGBO(0, 0, 0, 0.05),
                                  tickAsset: 'assets/icons/tick-icon.svg',
                                ),
                              );
                            }).toList(),
                          ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Store Description',
                          hint: 'write more about your store..',
                          isRequired: true,
                          controller: phoneController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Select Business Hours',
                          hint: '9:00 AM - 9:00 PM',
                          isRequired: false,
                          controller: emailController,
                          svgPath: 'assets/icons/clock-icon.svg',
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        SubmitButton(
                          text: 'Submit',
                          onPressed: () {
                            Navigator.pushNamed(context, '/main_screen');
                          },
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
