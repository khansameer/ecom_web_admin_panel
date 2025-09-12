import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formLoginKey = GlobalKey<FormState>();
    return commonScaffold(
      body: commonAppBackground(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Consumer<LoginProvider>(
              builder: (context, provider, child) {
                return commonPopScope(
                  onBack: () {
                    provider.resetState();
                  },
                  child: Form(
                    key: formLoginKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: commonSvgWidget(
                            color: colorLogo,
                            path: icLogo,
                            width: size.width * 0.6,
                          ),
                        ),
                        SizedBox(height: size.height * 0.08),
                        commonHeadingText(
                          text: "Welcome back 👋 ",
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 2),
                        commonDescriptionText(
                          text: "Please login to continue  ",
                        ),
                        const SizedBox(height: 20),
                        _commonLoginView(
                          provider: provider,
                          onPressed: () {
                            hideKeyboard(context);
                            if (formLoginKey.currentState?.validate() == true) {
                              //put valid logic
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _commonLoginView({
    required LoginProvider provider,
    required void Function() onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        commonTextField(
          keyboardType: TextInputType.emailAddress,
          validator: provider.validateEmail,

          prefixIcon: commonPrefixIcon(image: icEmail),
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
            icon: provider.obscurePassword
                ? commonPrefixIcon(image: icPasswordHide)
                : commonPrefixIcon(image: icPasswordShow),
            onPressed: provider.togglePassword,
          ),
          keyboardType: TextInputType.visiblePassword,
          validator: provider.validatePassword,
          prefixIcon: commonPrefixIcon(image: icPassword),
        ),
        const SizedBox(height: 50),
        commonButton(text: "Login", onPressed: onPressed),
      ],
    );
  }
}
