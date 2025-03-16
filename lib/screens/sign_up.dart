import 'dart:convert';
import 'dart:io';

import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/config/theme.dart';
import 'package:boutiquena_vendor/services/api_service.dart';
import 'package:boutiquena_vendor/services/log_service.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:boutiquena_vendor/utils/validator.dart';
import 'package:boutiquena_vendor/widgets/buttons/checkbox.dart';
import 'package:boutiquena_vendor/widgets/buttons/submit_button.dart';
import 'package:boutiquena_vendor/widgets/headers/signup_appbar.dart';
import 'package:boutiquena_vendor/widgets/inputs/dropdown.dart';
import 'package:boutiquena_vendor/widgets/inputs/input_widgets.dart';
import 'package:boutiquena_vendor/widgets/inputs/phone_number.dart';
import 'package:boutiquena_vendor/widgets/popups/custom_popup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController additionalPhoneController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController storeLinkController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  List<dynamic> storeTypes = [];
  Map<int, bool> selectedStoreTypes = {};
  final FocusNode blankFocusNode = FocusNode();

  // Store Type Checkboxes
  bool storeTypeOnline = false;
  bool storeTypeOffline = false;

  File? storeLogo;

  List<Map<String, String>> countryList = [];
  List<Map<String, String>> stateList = [];
  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  String? selectedCountry;
  String? selectedCountryCode;
  String? selectedState;
  String? selectedStateCode;
  String? selectedCity;

  // Store Category Selection
  List<Map<String, dynamic>> storeCategories = [];
  dynamic selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchStoreType();
    fetchCategories();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final response = await csc.getAllCountries();
    setState(() {
      countryList =
          response.map((e) => {"name": e.name, "code": e.isoCode}).toList();
      countries = countryList.map((e) => e["name"]!).toList();
      selectedCountry = countries.isNotEmpty ? countries[0] : null;
      selectedCountryCode =
          countryList.isNotEmpty ? countryList[0]["code"] : null;
      // if (selectedCountry != null) fet(selectedCountry!);
    });
  }

  Future<void> fetchStates(String countryCode) async {
    final response = await csc.getStatesOfCountry(countryCode);
    setState(() {
      // states = response.map((e) => e.name).toList();
      // selectedState = states.isNotEmpty ? states[0] : null;
      stateList =
          response.map((e) => {"name": e.name, "code": e.isoCode}).toList();
      states = stateList.map((e) => e["name"]!).toList();
      selectedState = states.isNotEmpty ? states[0] : null;
      selectedStateCode = stateList.isNotEmpty ? stateList[0]["code"] : null;
    });
  }

  Future<void> fetchCities(String stateCode, String countryCode) async {
    final response = await csc.getStateCities(countryCode, stateCode);
    setState(() {
      cities = response.map((e) => e.name).toList();
    });
  }

  Future<void> fetchCategories() async {
    try {
      final response = await ApiService.get('store-category');

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['store_categories'] is List) {
          setState(() {
            storeCategories = List<Map<String, dynamic>>.from(
                (data['store_categories'] as List).map((category) => {
                      "id": category["id"].toString(),
                      "name": category["name"] ?? "Unknown"
                    }));
          });
        } else {
          throw Exception("Invalid data format");
        }
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      LogService.error("fetchCategories() Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
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
              selectedStoreTypes[type["id"]] = false; // Initialize as unchecked
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

  bool _validateInputs() {
    String errorMessage = '';

    if (nameController.text.isEmpty) {
      errorMessage = 'Name is required.';
    } else if (addressController.text.isEmpty) {
      errorMessage = 'Address is required.';
    } else if (phoneController.text.isEmpty) {
      errorMessage = 'Phone number is required.';
    } else if (emailController.text.isEmpty) {
      errorMessage = 'Email is required.';
    } else if (pincodeController.text.isEmpty) {
      errorMessage = 'Pincode is required.';
    } else if (passwordController.text.isEmpty) {
      errorMessage = 'Password is required.';
    } else if (confirmPasswordController.text.isEmpty) {
      errorMessage = 'Confirm Password is required.';
    } else if (passwordController.text != confirmPasswordController.text) {
      errorMessage = 'Passwords do not match.';
    } else if (storeNameController.text.isEmpty) {
      errorMessage = 'Store name is required.';
    } else if (selectedCategory == null) {
      errorMessage = 'Please select a category.';
    } else if (selectedCountry == null) {
      errorMessage = 'Please select a country.';
    } else if (selectedState == null) {
      errorMessage = 'Please select a state.';
    } else if (selectedCity == null) {
      errorMessage = 'Please select a city.';
    } else if (selectedStoreTypes.values.every((isSelected) => !isSelected)) {
      errorMessage = 'Please select at least one store type.';
    } else if (storeLogo == null) {
      errorMessage = 'Store logo is required.';
    }

    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return false;
    }

    if (!Validators.isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return false;
    }

    if (!Validators.isValidMobile(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid 10-digit phone number.')),
      );
      return false;
    }

    if (!Validators.isPasswordMatching(
        passwordController.text, confirmPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return false;
    }
    if (storeLinkController.text.isNotEmpty &&
        !Validators.isValidURL(storeLinkController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid store link.')),
      );
      return false;
    }
    if (storeLogo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a store logo!")),
      );
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_validateInputs()) return;

    String categoryIds = selectedCategory.join(",");

    // Extract selected store type IDs
    List<int> selectedStoreTypeIds = selectedStoreTypes.entries
        .where((entry) => entry.value) // Filter selected ones
        .map((entry) => entry.key) // Get IDs
        .toList();

    final Map<String, dynamic> payload = {
      "email": emailController.text,
      "password": passwordController.text,
      "name": nameController.text,
      "address": addressController.text,
      "city": selectedCity ?? "Ahmedabad",
      "state": selectedState ?? "Gujarat",
      "country": selectedCountry ?? "India",
      "pincode": pincodeController.text,
      "mobile": phoneController.text,
      "category_ids": categoryIds,
      "store_type": selectedStoreTypeIds
          .join(","), // Convert list to comma-separated string
      "store_link": storeLinkController.text,
      "store_name": storeNameController.text,
    };

    LogService.info("Payload for store register : " + json.encode(payload));

    final response =
        await ApiService.post('register-vendor', payload, file: storeLogo!);

    if (response == null) {
      throw Exception("No response from server");
    }

    if (response["status"] == true) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CustomPopUp(
          title: 'Successfully Submitted',
          customMessageWidget: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  "Your details have been successfully submitted. Now, you have to wait till",
              style: AppTextStyles.greySubHeadingStyle().copyWith(
                fontSize: 16 * SizeConfig.widthScale,
                fontWeight: FontWeight.w300,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' admin approves ',
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontSize: 16 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "your request.\nThank you for your time!",
                  style: AppTextStyles.greySubHeadingStyle().copyWith(
                    fontSize: 16 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ).then((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage.trim())),
      );

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
            const SignUpAppBar(),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 30 * SizeConfig.widthScale),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25 * SizeConfig.heightScale),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: SvgPicture.asset('assets/icons/back-icon.svg'),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Register your Store',
                            style: AppTextStyles.blackHeadingStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25 * SizeConfig.heightScale),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10 * SizeConfig.widthScale),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputWidget(
                          label: 'Name',
                          hint: 'Enter your name..',
                          isRequired: true,
                          controller: nameController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Address',
                          hint: 'Enter your address..',
                          isRequired: true,
                          controller: addressController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        CustomDropdown(
                          isRequired: true,
                          label: 'Country',
                          items: countries,
                          selectedItem: selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                              selectedCountryCode = countryList.firstWhere(
                                  (e) => e["name"] == value)["code"];
                              fetchStates(selectedCountryCode!);
                              FocusScope.of(context)
                                  .requestFocus(blankFocusNode);
                            });
                          },
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        CustomDropdown(
                          isRequired: true,
                          items: states,
                          label: 'State',
                          selectedItem: selectedState,
                          onChanged: (value) {
                            setState(() {
                              selectedState = value;
                              selectedStateCode = stateList.firstWhere(
                                  (e) => e["name"] == value)["code"];
                              fetchCities(
                                  selectedStateCode!, selectedCountryCode!);
                              FocusScope.of(context)
                                  .requestFocus(blankFocusNode);
                            });
                          },
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        CustomDropdown(
                          isRequired: true,
                          items: cities,
                          label: 'City',
                          selectedItem: selectedCity,
                          onChanged: (value) => setState(() {
                            selectedCity = value;
                            FocusScope.of(context).requestFocus(blankFocusNode);
                          }),
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Pincode',
                          hint: 'Enter your pincode..',
                          isRequired: true,
                          controller: pincodeController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        PhoneNumberInput(
                          phoneController: phoneController,
                          onSaved: (String value) {},
                          label: 'Phone Number',
                          hintText: 'Enter phone number...',
                          isRequired: true,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        PhoneNumberInput(
                          phoneController: additionalPhoneController,
                          onSaved: (String value) {},
                          label: 'Additional Phone Number',
                          hintText: 'Enter additional phone number...',
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Email',
                          hint: 'Enter your email..',
                          isRequired: true,
                          controller: emailController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Password',
                          hint: 'Enter your password..',
                          isRequired: true,
                          isPassword: true,
                          controller: passwordController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Confirm Password',
                          hint: 'Enter your password..',
                          isRequired: true,
                          isPassword: true,
                          controller: confirmPasswordController,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Store Name',
                          hint: 'Enter your store name..',
                          isRequired: true,
                          controller: storeNameController,
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
                        CustomDropdown(
                          isRequired: true,
                          label: 'Store Category',
                          items: storeCategories
                              .map((category) => category["name"] as String)
                              .toList(),
                          selectedItem: selectedCategory != null
                              ? storeCategories.firstWhere(
                                  (c) => c["id"] == selectedCategory,
                                  orElse: () => {})["name"]
                              : null,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              print("New value: $newValue");

                              if (newValue is List) {
                                selectedCategory = newValue.map((name) {
                                  var selected = storeCategories.firstWhere(
                                    (c) => c["name"] == name,
                                    orElse: () => {"id": null},
                                  );
                                  return selected["id"];
                                }).toList(); // Store IDs as a list
                              } else {
                                var selected = storeCategories.firstWhere(
                                  (c) => c["name"] == newValue,
                                  orElse: () => {"id": null},
                                );
                                selectedCategory = selected["id"];
                              }

                              print("Selected IDs: $selectedCategory");
                              FocusScope.of(context)
                                  .requestFocus(blankFocusNode);
                            });
                          },
                          isMultiSelect: true,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        Row(
                          children: [
                            Text(
                              'Store Image/Logo',
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
                        InputWidget(
                          label: 'Store Page Link',
                          hint: 'Enter your page url here..',
                          isRequired: false,
                          controller: storeLinkController,
                          svgPath: 'assets/icons/link-icon.svg',
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        SubmitButton(
                          text: 'Register',
                          onPressed: _submit,
                        ),
                        SizedBox(height: 10 * SizeConfig.heightScale),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account?",
                              style: AppTextStyles.greySubHeadingStyle(),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Sign In',
                                  style: AppTextStyles.signupSubHeadingStyle(),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    },
                                ),
                              ],
                            ),
                          ),
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
