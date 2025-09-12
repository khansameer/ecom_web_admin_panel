import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/login_provider.dart';

Widget commonLoginView({
  required LoginProvider provider,
  required void Function() onPressed,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      commonTextField(
        keyboardType: TextInputType.emailAddress,
        validator: provider.validateEmail,

        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
        controller: provider.tetEmail,
        hintText: "Email",
      ),
      const SizedBox(height: 20),
      commonTextField(
        hintText: "Password",
        controller: provider.tetPassword,
        obscureText: provider.obscurePassword,
        maxLines: 1,
        suffixIcon: IconButton(
          icon: Icon(
            color: Colors.grey,
            provider.obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: provider.togglePassword,
        ),
        keyboardType: TextInputType.visiblePassword,
        validator: provider.validatePassword,
        prefixIcon: Icon(Icons.lock_open_outlined, color: Colors.grey),
      ),
      const SizedBox(height: 50),
      commonButton(text: "Login", onPressed: onPressed),
    ],
  );
}
