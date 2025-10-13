import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';
import 'package:neeknots/core/component/component.dart';

class CommonPhoneField extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController countryCodeController;

  final String hintText;

  const CommonPhoneField({
    super.key,
    required this.phoneController,
    required this.countryCodeController,
    this.hintText = "Phone Number",
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: phoneController,
      initialCountryCode: 'US',
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: commonTextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: commonTextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: commonTextFiledBorder(),
        enabledBorder: commonTextFiledBorder(),
        focusedBorder:commonTextFiledBorder(),
      ),
      validator: (phone) {
        if (phone == null || phone.number.isEmpty) {
          return "Please enter phone number";
        } else if (phone.number.length < 6) {
          return "Enter a valid phone number";
        }
        return null;
      },
      onChanged: (phone) {
        countryCodeController.text = phone.countryCode;
      },
      onCountryChanged: (value) {
        countryCodeController.text = value.dialCode;
      },
    );
  }
}
