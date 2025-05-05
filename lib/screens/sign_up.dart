import 'dart:convert';
import 'dart:io';

import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/utils/validator.dart';
import 'package:customer_app/widgets/buttons/submit_button.dart';
import 'package:customer_app/widgets/inputs/input_widgets.dart';
import 'package:customer_app/widgets/popups/custom_popup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  File? storeLogo;

  @override
  void initState() {
    super.initState();
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
    } else if (passwordController.text.isEmpty) {
      errorMessage = 'Password is required.';
    } else if (confirmPasswordController.text.isEmpty) {
      errorMessage = 'Confirm Password is required.';
    } else if (passwordController.text != confirmPasswordController.text) {
      errorMessage = 'Passwords do not match.';
    }

    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
          content: Text('Please enter a valid 10-digit phone number.'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _submit() async {
    if (!_validateInputs()) return;

    final Map<String, dynamic> payload = {
      "email": emailController.text,
      "password": passwordController.text,
      "name": nameController.text,
      "address": addressController.text,
      "mobile": phoneController.text,
    };

    LogService.info("Payload for store register : ${json.encode(payload)}");

    final response = await ApiService.post('register-user', payload);

    if (response == null) {
      throw Exception("No response from server");
    }

    if (response["status"] == true) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder:
            (context) => CustomPopUp(
              title: 'Successfully Submitted',
              customMessageWidget: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Thank you for your time!",
                  style: AppTextStyles.greySubHeadingStyle().copyWith(
                    fontSize: 16 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
      );
    } else {
      final message = response["message"];
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message.toString())));
      throw Exception("API Error: $message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30 * SizeConfig.widthScale,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            'Create Account',
                            style: AppTextStyles.blackHeadingStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * SizeConfig.heightScale),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * SizeConfig.widthScale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InputWidget(
                          label: 'Name',
                          hint: 'Enter your name..',
                          isRequired: true,
                          controller: nameController,
                        ),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Email',
                          hint: 'Enter your email..',
                          isRequired: true,
                          controller: emailController,
                        ),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Phone Number',
                          hint: 'Enter your phone number..',
                          controller: phoneController,
                          prefix: '+972',
                          isRequired: true,
                          maxLength: 10,
                        ),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Address',
                          hint: 'Enter your address..',
                          isRequired: true,
                          controller: addressController,
                          maxLines: 3,
                        ),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Password',
                          hint: 'Enter your password..',
                          isRequired: true,
                          isPassword: true,
                          controller: passwordController,
                        ),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Confirm Password',
                          hint: 'Re-enter your password..',
                          isRequired: true,
                          isPassword: true,
                          controller: confirmPasswordController,
                        ),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        SubmitButton(text: 'Register', onPressed: _submit),
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
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/login',
                                          );
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
