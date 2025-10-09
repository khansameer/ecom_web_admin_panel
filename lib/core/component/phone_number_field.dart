import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neeknots/core/component/component.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController? countryCodeController;
  final String countryCode;
  final String hintText;
  final Color? fillColor;
  final bool? filled;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool isCountryCodeEditable;
  final bool isPhoneEditable;

  const PhoneNumberField({
    super.key,
    required this.phoneController,
    this.countryCodeController,
    this.countryCode = "+1",
    this.hintText = "Mobile No",
    this.validator,
    this.fillColor,
    this.filled = false,
    this.prefixIcon,
    this.isCountryCodeEditable = false,
    this.isPhoneEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: commonTextField(
            fillColor: fillColor,
            filled: filled ?? false,

            controller: countryCodeController,
            keyboardType: TextInputType.phone,
            maxLines: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            enabled: isCountryCodeEditable,
            hintText: '',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: commonTextField(
            controller: phoneController,
            maxLines: 1,
            fillColor: fillColor,
            enabled: isCountryCodeEditable,
            filled: filled ?? false,
            keyboardType: TextInputType.phone,
            validator: validator,
            hintText: hintText,
            prefixIcon: prefixIcon,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ],
    );
  }

  /// Helper function to get full number
  String getFullNumber() {
    return "${countryCodeController?.text ?? countryCode}${phoneController.text}";
  }
}
