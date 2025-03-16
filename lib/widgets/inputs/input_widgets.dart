import 'package:boutiquena_vendor/config/text_styles.dart';
import 'package:boutiquena_vendor/config/theme.dart';
import 'package:boutiquena_vendor/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputWidget extends StatefulWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isRequired;
  final String? svgPath;
  final int maxLines; // New maxLines parameter
  final bool isDisabled; // New isDisabled parameter

  const InputWidget({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    this.isRequired = false,
    this.svgPath,
    this.maxLines = 1, // Default value
    this.isDisabled = false, // Default value
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
        TextFormField(
          controller: widget.controller,
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
          validator: widget.validator,
          obscureText: widget.isPassword ? _obscureText : false,

          maxLines:
              widget.isPassword ? 1 : widget.maxLines, // Hide password text
          enabled: !widget.isDisabled, // Apply isDisabled
          autofocus: false, // Ensure autofocus is disabled
          decoration: AppTheme.inputDecoration.copyWith(
            hintText: widget.hint,
            suffixIcon: widget.isPassword
                ? IconButton(
                    color: const Color.fromRGBO(128, 128, 128, 1),
                    icon: _obscureText
                        ? SvgPicture.asset(
                            'assets/icons/password-eye-close-icon.svg')
                        : SvgPicture.asset(
                            'assets/icons/password-eye-open-icon.svg',
                            height: 12,
                            width: 14,
                          ),
                    onPressed: widget.isDisabled
                        ? null
                        : () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
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
