import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../core/component/phone_number_field.dart';
import '../../core/validation/validation.dart';
import '../../main.dart';
import '../../provider/theme_provider.dart';

Widget commonLoginView({
  required LoginProvider provider,
  required void Function() onPressed,
  GestureRecognizer? onPressSignUp,
}) {
  final themeProvider = Provider.of<ThemeProvider>(navigatorKey.currentContext!);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      commonTextField(
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,

        prefixIcon: commonPrefixIcon(image: icEmail),
        controller: provider.tetEmail,
        hintText: "Email",
      ),
      const SizedBox(height: 20),
    /*  commonTextField(
        hintText: "Phone No",
        controller: provider.tetPhone,

        maxLines: 1,

        keyboardType: TextInputType.phone,
        validator: validateTenDigitPhone,
        prefixIcon: commonPrefixIcon(image: icPhone),
      ),*/
      PhoneNumberField(
        phoneController: provider.tetPhone,
        countryCodeController: provider.tetCountryCodeController,
        prefixIcon: commonPrefixIcon(image: icPhone),
        validator: (value) {
          if (value == null || value.length != 10) {
            return "Enter 10 digit phone number";
          }
          return null;
        },
        isCountryCodeEditable: true, // fixed +1
      ),
      const SizedBox(height: 50),
      commonButton(text: "Login", onPressed: onPressed),
      const SizedBox(height: 20),
      commonTextRich(
        onTap: onPressSignUp,
        text1: "Don't have an account? ",
        text2: "Setup Account",
        textStyle1: commonTextStyle(color: themeProvider.isDark?Colors.white:Colors.black),
        textStyle2: commonTextStyle(
          color: themeProvider.isDark?Colors.white:colorLogo,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
