import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController? countryCodeController;
  final String countryCode;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final bool isCountryCodeEditable;

  const PhoneNumberField({
    super.key,
    required this.phoneController,
    this.countryCodeController,
    this.countryCode = "+1",
    this.hintText = "Phone No",
    this.validator,
    this.prefixIcon,
    this.isCountryCodeEditable = false,
  });

  @override
  Widget build(BuildContext context) {
  /*  final countryController =
        countryCodeController ?? TextEditingController(text: countryCode);
*/
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: commonTextField(
            controller: countryCodeController,
            keyboardType: TextInputType.phone,
            enabled: isCountryCodeEditable, hintText: '',

          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: commonTextField(
            controller: phoneController,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            validator: validator,
            hintText: hintText,
            prefixIcon: prefixIcon,

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
