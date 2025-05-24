// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/screens/main_screen.dart';
import 'package:vendor_app/screens/store_setup.dart';
import 'package:vendor_app/screens/subscription_plan.dart';
import 'package:vendor_app/services/api_service.dart';
import 'package:vendor_app/services/log_service.dart';
import 'package:vendor_app/utils/secure_storage.dart';
import 'package:vendor_app/utils/size_config.dart';
import 'package:vendor_app/utils/validator.dart';
import 'package:vendor_app/widgets/buttons/submit_button.dart';
import 'package:vendor_app/widgets/inputs/input_widgets.dart';
import 'package:vendor_app/widgets/popups/custom_popup.dart';
import 'package:vendor_app/widgets/popups/otp_popup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _navigateToSubscription = false;
  bool _navigateToStore = false;
  late BuildContext rootContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submitLogin(BuildContext context) async {
    String input = emailController.text.trim();
    String password = passwordController.text.trim();
    bool isMobile = Validators.isValidMobile(input);
    bool isEmail = Validators.isValidEmail(input);

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email or mobile number')),
      );
      return;
    }

    if (!isEmail && !isMobile) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or mobile number format')),
      );
      return;
    }

    if (isEmail && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is required for email login')),
      );
      return;
    }

    var requestData =
        isMobile
            ? {"mobile": input} // Send as 'mobile' if it's a phone number
            : {
              "email": input,
              "password": password,
            }; // Send email & password for email login

    var response = await ApiService.post("login-vendor", requestData);

    if (response == null) {
      LogService.error("Login Failed", null);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No response from server")));
      return;
    }

    // ✅ Remove statusCode and directly work with response map
    LogService.info("Response: ${jsonEncode(response)}");

    if (response.containsKey("error")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["error"] ?? "Something went wrong!")),
      );
      return;
    }
    if (response["status"] == false) {
      dynamic message = response["message"];
      if (message is Map) {
        message = message.values.expand((value) => value).join("\n");
      }

      message ??= "Something went wrong!";
      showDialog(
        context: context,
        builder:
            (context) => CustomPopUp(
              onPressed: () => Navigator.pop(context),
              title:
                  message == 'Your account is not approved by admin!'
                      ? 'Error'
                      : '',
              message: message,
              imagePath:
                  message == 'Your account is not approved by admin!'
                      ? 'assets/icons/wait.png'
                      : 'assets/icons/error.jpg',
            ),
      );

      return;
    }
    if (response["status"] == true) {
      LogService.info("Login Successful!");
      showDialog(
        context: context,
        builder:
            (context) => OtpPopup(
              mobile: input,
              onSubmit: (String otp) async {
                try {
                  final otpResponse = await ApiService.post(
                    'verify-vendor-otp',
                    isMobile
                        ? {"mobile": input, "otp": otp}
                        : {"email": input, "otp": otp},
                  );

                  if (otpResponse == null) {
                    throw Exception("No response from server");
                  }

                  if (otpResponse['status'] == true) {
                    await AuthTokenUtil.saveToken(otpResponse['token']);
                    if (!mounted) return;

                    Navigator.of(context, rootNavigator: true).pop();

                    Future.delayed(Duration(milliseconds: 100), () {
                      print(
                        "Navigating to: ${otpResponse['is_store']} ${otpResponse['is_subscription']}",
                      );

                      ScaffoldMessenger.of(rootContext).showSnackBar(
                        const SnackBar(content: Text("Login Successfully!")),
                      );

                      if (otpResponse['is_store'] == true &&
                          otpResponse['is_subscription'] == true) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                          (route) => false,
                        );
                      } else if (otpResponse['is_store'] == false &&
                          otpResponse['is_subscription'] == true) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoreSetupScreen(),
                          ),
                          (route) => false,
                        );
                      } else if (otpResponse['is_subscription'] == false) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubscriptionScreen(),
                          ),
                          (route) => false,
                        );
                      } else {
                        Navigator.pushReplacement(
                          rootContext,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      }
                    });
                  } else if (otpResponse.containsKey("error")) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(otpResponse['error'] ?? "Error")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid OTP!")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              },
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    rootContext = context;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 110 * SizeConfig.heightScale),
                    child: SizedBox(
                      width: 200 * SizeConfig.widthScale,
                      height: 130 * SizeConfig.widthScale,
                      child: Image.asset(
                        'assets/logo/login_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 40 * SizeConfig.heightScale),
                  Text('Log In', style: AppTextStyles.blackHeadingStyle()),
                  SizedBox(height: 40 * SizeConfig.heightScale),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40 * SizeConfig.widthScale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputWidget(
                          label: 'Email / Phone Number',
                          hint: 'Enter your email or phone number..',
                          controller: emailController,
                          isRequired: true,
                        ),
                        SizedBox(height: 20 * SizeConfig.heightScale),
                        InputWidget(
                          label: 'Password',
                          hint: 'Enter your password..',
                          controller: passwordController,
                          isPassword: true,
                        ),
                        SizedBox(height: 30 * SizeConfig.heightScale),
                        SubmitButton(
                          text: 'Log In',
                          onPressed: () => submitLogin(context),
                        ),
                        SizedBox(height: 15 * SizeConfig.heightScale),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account?",
                              style: AppTextStyles.greySubHeadingStyle(),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Sign Up',
                                  style: AppTextStyles.signupSubHeadingStyle(),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/signup',
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
              Padding(
                padding: EdgeInsets.only(
                  bottom: 20 * SizeConfig.heightScale,
                  left: 40 * SizeConfig.heightScale,
                  right: 40 * SizeConfig.heightScale,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By logging in, you agree to the\n",
                    style: AppTextStyles.greySubHeadingStyle().copyWith(
                      fontSize: 14 * SizeConfig.widthScale,
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: AppTextStyles.signupSubHeadingStyle().copyWith(
                          fontSize: 14 * SizeConfig.widthScale,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                print("Terms & Conditions tapped");
                              },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: AppTextStyles.greySubHeadingStyle(),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: AppTextStyles.signupSubHeadingStyle(),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                print("Privacy Policy tapped");
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
