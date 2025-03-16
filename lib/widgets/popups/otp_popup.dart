import 'dart:async';

import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:boutiquena_vendor/widgets/buttons/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPopup extends StatefulWidget {
  final String mobile;
  final Function(String) onSubmit;

  const OtpPopup({super.key, required this.mobile, required this.onSubmit});

  @override
  _OtpPopupState createState() => _OtpPopupState();
}

class _OtpPopupState extends State<OtpPopup> {
  final TextEditingController _otpController = TextEditingController();
  int _start = 30;
  late Timer _timer;
  bool _disabledResendOTP = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _disabledResendOTP = false;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _onSubmit() async {
    String enteredOtp = _otpController.text.trim();

    if (enteredOtp.length == 6) {
      setState(() {});

      try {
        await widget.onSubmit(enteredOtp);

        if (!mounted) return; // Prevents calling setState on disposed widget
        setState(() {});

        if (mounted) {
          Navigator.of(context).pop(); // Close the dialog safely
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(248, 248, 248, 1),
                    shape: BoxShape.circle),
                padding: EdgeInsets.all(5 * SizeConfig.widthScale),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: 15 * SizeConfig.widthScale,
                  ),
                ),
              ),
            ),
            Text(
              'Enter OTP',
              style: AppTextStyles.loginHeadingStyle(),
            ),
            SizedBox(height: 10 * SizeConfig.heightScale),
            OTPInputWidget(
              controller: _otpController, // Pass controller
              onCompleted: (otp) {},
              onChanged: (String a) {},
            ),
            SubmitButton(text: 'Submit', onPressed: _onSubmit),
            SizedBox(height: 5 * SizeConfig.heightScale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '00:${_start.toString().padLeft(2, '0')}s',
                  style: AppTextStyles.greySubHeadingStyle(),
                ),
                TextButton(
                  onPressed: _disabledResendOTP
                      ? null
                      : () {
                          setState(() {
                            _disabledResendOTP = true;
                            _start = 30;
                            startTimer();
                          });
                        },
                  child: Text('Resend OTP',
                      style: AppTextStyles.greySubHeadingStyle(
                          color:
                              _disabledResendOTP ? Colors.grey : Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OTPInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;
  final Function(String) onChanged;

  const OTPInputWidget({
    super.key,
    required this.controller,
    required this.onCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: PinCodeTextField(
        appContext: context,
        controller: controller, // Use the passed controller
        length: 6,
        obscureText: false,
        autoFocus: true,
        keyboardType: TextInputType.number,
        textStyle: AppTextStyles.blackHeadingStyle()
            .copyWith(fontSize: 14 * SizeConfig.widthScale),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(3),
          fieldHeight: 45,
          fieldWidth: 37,
          activeColor: const Color.fromRGBO(219, 223, 233, 1),
          selectedColor: const Color.fromRGBO(37, 37, 38, 1),
          inactiveColor: const Color.fromRGBO(219, 223, 233, 1),
          activeBorderWidth: 1,
          selectedBorderWidth: 1,
          inactiveBorderWidth: 1,
        ),
        cursorColor: const Color.fromRGBO(37, 37, 38, 1),
        animationType: AnimationType.fade,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
        onCompleted: onCompleted,
      ),
    );
  }
}
