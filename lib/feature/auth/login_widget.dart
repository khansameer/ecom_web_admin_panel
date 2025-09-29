import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/login_provider.dart';

import '../../core/validation/validation.dart';

Widget commonLoginView({
  required LoginProvider provider,
  required void Function() onPressed,
  GestureRecognizer? onPressSignUp,
}) {
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
      commonTextField(
        hintText: "Phone No",
        controller: provider.tetPhone,

        maxLines: 1,

        keyboardType: TextInputType.phone,
        validator: validatePhoneNumber,
        prefixIcon: commonPrefixIcon(image: icPhone),
      ),
      const SizedBox(height: 50),
      commonButton(text: "Login", onPressed: onPressed),
      const SizedBox(height: 20),
      commonTextRich(
        onTap: onPressSignUp,
        text1: "Don't have an account? ",
        text2: "Setup Account",
        textStyle1: commonTextStyle(),
        textStyle2: commonTextStyle(
          color: colorLogo,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
