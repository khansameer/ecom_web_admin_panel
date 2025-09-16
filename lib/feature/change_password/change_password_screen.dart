import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../core/validation/validation.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formChangePasswordKey = GlobalKey<FormState>();
    return commonScaffold(
      appBar: commonAppBar(title: "Change Password", context: context,centerTitle: true),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return commonAppBackground(
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
                        key: formChangePasswordKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentGeometry.center,
                              child: commonSvgWidget(
                                color: themeProvider.isDark
                                    ? Colors.white
                                    : colorLogo,
                                path: icLogo,
                                width: size.width * 0.6,
                              ),
                            ),
                            SizedBox(height: size.height * 0.08),
                            commonHeadingText(
                              text: "Change Password",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : colorLogo,
                            ),
                            const SizedBox(height: 2),
                            commonDescriptionText(
                              text: "Keep your account safe by updating your password.",
                            ),
                            const SizedBox(height: 30),
                            Column(
                              spacing: 24,
                              children: [
                                commonTextField(
                                  hintText: "Current Password",
                                  controller: provider.tetCurrentPassword,
                                  obscureText: provider.obscureCurrentPassword,
                                  maxLines: 1,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      color: Colors.grey,
                                      provider.obscureCurrentPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: provider.toggleCurrentPassword,
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: validatePassword,

                                  prefixIcon: commonPrefixIcon(image: icPassword),
                                ),
                                commonTextField(
                                  hintText: "New Password",
                                  controller: provider.tetNewPassword,
                                  obscureText: provider.obscureNewPassword,
                                  maxLines: 1,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      color: Colors.grey,
                                      provider.obscureNewPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: provider.toggleNewPassword,
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: validatePassword,
                                  prefixIcon: commonPrefixIcon(image: icPassword),
                                ),
                                commonTextField(
                                  hintText: "Confirm Password",
                                  controller: provider.tetConfirmPassword,
                                  obscureText: provider.obscureConfirmPassword,
                                  maxLines: 1,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      color: Colors.grey,
                                      provider.obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: provider.toggleConfirmPassword,
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) => validateConfirmPassword(value, provider.tetNewPassword.text),
                                  prefixIcon: commonPrefixIcon(image: icPassword),
                                ),

                              ],
                            ),

                            const SizedBox(height: 50),
                            commonButton(text: "Change Password", onPressed: (){

                              hideKeyboard(context);
                              if (formChangePasswordKey.currentState?.validate() ==
                                  true) {
                                showCommonDialog(
                                  showCancel: false,
                                  confirmText: "Login Again",
                                  onPressed: () {
                                    navigatorKey.currentState?.pushNamedAndRemoveUntil(
                                      RouteName.loginScreen,
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  cancelText: "No",
                                  title: "Success",
                                  context: context,
                                  content: "Password change successfully!",
                                );


                              }


                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
