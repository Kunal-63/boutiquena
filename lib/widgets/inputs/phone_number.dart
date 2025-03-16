import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/config/theme.dart';
import 'package:boutiquena_vendor/screens/country_picker.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController phoneController;
  final Function(String) onSaved;
  final String? label;
  final bool isRequired;
  final String? hintText;

  const PhoneNumberInput({
    this.label,
    required this.phoneController,
    required this.onSaved,
    this.isRequired = false,
    this.hintText,
    super.key,
  });

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  CountryCode selectedCountry = CountryCode(
      code: "IL", name: "Israel", dialCode: "+972", flagUri: "flags/il.png");

  @override
  Widget build(BuildContext context) {
    final double widthScale = MediaQuery.of(context).size.width / 375;

    return Column(
      children: [
        if (widget.label != null)
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTextStyles.inputLabelStyle(),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: AppTextStyles.inputLabelStyle()
                      .copyWith(color: Colors.red),
                ),
            ],
          ),
        SizedBox(
          height: 5 * SizeConfig.heightScale,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8 * widthScale,
            vertical: 2,
          ),
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(219, 233, 233, 1),
              width: 0.94,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final CountryCode? newSelectedCountry = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountryPickerScreen(
                        lastSelectedCountry: selectedCountry,
                      ),
                    ),
                  );
                  if (newSelectedCountry != null && mounted) {
                    setState(() {
                      selectedCountry = newSelectedCountry;
                    });
                  }
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        selectedCountry.flagUri ?? '',
                        package: 'country_list_pick',
                        width: 34,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedCountry.dialCode ?? '+91',
                      style: AppTextStyles.blackSubHeadingStyle().copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14 * SizeConfig.widthScale,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down,
                        size: 20, color: Colors.black),
                  ],
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: TextFormField(
                  maxLength: 10,
                  maxLines: 1,
                  controller: widget.phoneController,
                  onSaved: (val) => widget.onSaved(val ?? ''),
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.blackSubHeadingStyle().copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14 * SizeConfig.widthScale,
                  ),
                  decoration: AppTheme.inputDecoration.copyWith(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: widget.hintText,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
