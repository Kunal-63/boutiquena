import 'dart:convert';
import 'dart:io';

import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:customer_app/utils/secure_storage.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/buttons/checkbox.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/headers/signup_appbar.dart';
import 'package:customer_app/widgets/inputs/dropdown.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bussinessHoursController =
      TextEditingController();
  String? selectedCity;
  bool storeTypeOnline = false;
  bool storeTypeOffline = false;
  File? storeLogo;
  File? storeCover;
  List<String> cities = [];
  List<dynamic> storeTypes = [];
  Map<int, bool> selectedStoreTypes = {};
  Map<String, dynamic> storeData = {};

  String? storeLogoUrl = "";
  String? storeCoverUrl = "";

  String? storeLink = "";
  String? storeCategories = "";
  int? storePincode = 0;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load store types: $e')));
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
            cities = List<String>.from(
              data['data'].map((city) => city['name']),
            );
          });
        } else {
          throw Exception("Invalid data format");
        }
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      LogService.error("fetchCities() Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load cities: $e')));
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await ApiService.getWithAuth('store-details');
      print("FETCH DATA RESPONSE ${response!.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          setState(() {
            storeData = data['data'];
            nameController.text = storeData['name'] ?? "";
            addressController.text = storeData['detailed_address'] ?? "";
            descriptionController.text = storeData['description'] ?? "";
            bussinessHoursController.text = storeData['business_hours'] ?? "";
            selectedCity = storeData['address'] ?? "";
            storeLink = storeData['store_link'] ?? "";
            storeCategories = storeData['category_ids'] ?? "";
            storePincode = storeData['pincode'] ?? "";

            storeLogoUrl = (storeData['logo'] != null &&
                    storeData['logo'].isNotEmpty)
                ? (storeData['image_path'] != null &&
                        storeData['image_path'].isNotEmpty
                    ? "${storeData['image_path']}/${storeData['logo']}"
                    : "http://82.29.164.243/front/images/store/${storeData['logo']}")
                : null; // ✅ Set to null instead of an empty string

            storeCoverUrl = (storeData['cover_image'] != null &&
                    storeData['cover_image'].isNotEmpty)
                ? (storeData['image_path'] != null &&
                        storeData['image_path'].isNotEmpty
                    ? "${storeData['image_path']}/${storeData['cover_image']}"
                    : "http://82.29.164.243/front/images/store/${storeData['cover_image']}")
                : null; // ✅ Set to null instead of an empty string

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

  bool _validateInputs() {
    String? errorMessage;

    if (nameController.text.trim().isEmpty) {
      errorMessage = 'Name is required.';
    } else if (addressController.text.trim().isEmpty) {
      errorMessage = 'Address is required.';
    } else if (descriptionController.text.trim().isEmpty) {
      errorMessage = 'Description is required.';
    } else if (bussinessHoursController.text.trim().isEmpty) {
      errorMessage = 'Business hours are required.';
    }

    if (selectedCity == null) {
      errorMessage = 'City is required.';
    }

    // ✅ Show error message if any
    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return false;
    }

    return true; // ✅ Passed all validations
  }

  Future<void> _submit() async {
    if (!_validateInputs()) return;
    // Navigator.pushNamed(context, '/main_screen');

    // // Ensure storeData is not null before modifying it
    Map<String, dynamic> payload = {...storeData};

    // ✅ Update the dictionary with new values from controllers
    payload["name"] = nameController.text;
    payload["detailed_address"] = addressController.text;
    payload["address"] = selectedCity ?? "Ahmedabad";
    payload["store_type"] = selectedStoreTypes.entries
        .where((entry) => entry.value) // Filter selected ones
        .map((entry) => entry.key)
        .join(",");
    payload["description"] = descriptionController.text;
    payload["business_hours"] = bussinessHoursController.text;
    payload["store_link"] = storeLink;
    payload["category_ids"] = storeCategories;
    payload["pincode"] = storePincode;

    // ✅ Only update logo and cover image manually
    payload.remove("logo");
    payload.remove("cover_image");

    LogService.info("Payload for update Store : ${json.encode(payload)}");

    final response = await ApiService.postWithAuth(
      'update-store',
      payload,
      files: {'logo': storeLogo, 'cover': storeCover},
    );

    LogService.info("Response for update Store : ${json.encode(response)}");

    if (response == null) {
      throw Exception("No response from server");
    }

    if (response["status"] == true) {
      await LoginStatusUtil.setLoginStatus(true);
      Navigator.pushNamed(context, '/main_screen');
    } else {
      Map<String, dynamic> errors = response["message"];
      String errorMessage = "";

      errors.forEach((key, value) {
        if (value is List) {
          errorMessage += "${value.join("\n")}\n";
        } else {
          errorMessage += "$value\n";
        }
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.trim())));

      throw Exception("API Error: ${response["message"]}");
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
              padding: EdgeInsets.symmetric(
                horizontal: 30 * SizeConfig.widthScale,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25 * SizeConfig.heightScale),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * SizeConfig.widthScale,
                    ),
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
                              style: AppTextStyles.inputLabelStyle().copyWith(
                                color: Colors.red,
                              ),
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

                              image: storeLogo != null
                                  ? DecorationImage(
                                      image: FileImage(storeLogo!),
                                      fit: BoxFit.cover,
                                    )
                                  : (storeLogoUrl != null &&
                                          storeLogoUrl!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(storeLogoUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null), // ✅ No image if URL is null or empty
                            ),
                            child: storeLogo == null
                                ? Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/add-icon.svg',
                                    ),
                                  )
                                : null,
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
                              style: AppTextStyles.inputLabelStyle().copyWith(
                                color: Colors.red,
                              ),
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
                              image: storeCover != null
                                  ? DecorationImage(
                                      image: FileImage(storeCover!),
                                      fit: BoxFit.cover,
                                    )
                                  : (storeCoverUrl != null &&
                                          storeCoverUrl!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(storeCoverUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null), // ✅ No image if URL is null or empty

                              color: const Color.fromRGBO(0, 0, 0, 0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: storeCover == null
                                ? Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/add-icon.svg',
                                    ),
                                  )
                                : null,
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
                              style: AppTextStyles.inputLabelStyle().copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10 * SizeConfig.heightScale),
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
                                      selectedStoreTypes.updateAll(
                                        (key, value) => false,
                                      );

                                      selectedStoreTypes[type["id"]] =
                                          newValue ?? false;
                                    });
                                  },
                                  borderColor: const Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.5,
                                  ),
                                  fillColor: const Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.05,
                                  ),
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
                          controller: descriptionController,
                          maxLines: 4,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Select Business Hours',
                          hint: '9:00 AM - 9:00 PM',
                          isRequired: false,
                          controller: bussinessHoursController,
                          svgPath: 'assets/icons/clock-icon.svg',
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        SubmitButton(text: 'Submit', onPressed: _submit),
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
