import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/utils/size_config.dart';

class InputWidget extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isRequired;
  final String? svgPath;
  final int maxLines;
  final bool isDisabled;
  final String? prefix; // Prefix text
  final int? maxLength; // ✅ New optional character limit

  const InputWidget({
    super.key,
    this.label,
    this.hint = '',
    required this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    this.isRequired = false,
    this.svgPath,
    this.maxLines = 1,
    this.isDisabled = false,
    this.prefix,
    this.maxLength, // ✅ Added maxLength parameter
  });

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Text(widget.label!, style: AppTextStyles.inputLabelStyle()),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: AppTextStyles.inputLabelStyle().copyWith(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        SizedBox(height: 5 * SizeConfig.heightScale),
        TextFormField(
          controller: widget.controller,
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
          validator: widget.validator,
          obscureText: widget.isPassword ? _obscureText : false,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength, // ✅ Character limit applied
          readOnly: widget.isDisabled,
          autofocus: false,
          style: const TextStyle(fontSize: 16, color: Colors.black),
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: widget.hint,
            counterText:
                "", // ✅ Hides default character counter to keep UI clean
            prefixIcon:
                widget.prefix != null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.prefix!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                    : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      color: const Color.fromRGBO(128, 128, 128, 1),
                      icon:
                          _obscureText
                              ? SvgPicture.asset(
                                'assets/icons/password-eye-close-icon.svg',
                              )
                              : SvgPicture.asset(
                                'assets/icons/password-eye-open-icon.svg',
                                height: 12,
                                width: 14,
                              ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }, // ✅ Always allow toggling the eye icon
                    )
                    : widget.svgPath != null
                    ? Container(
                      height: 20,
                      width: 20,
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        widget.svgPath!,
                        fit: BoxFit.contain,
                      ),
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
