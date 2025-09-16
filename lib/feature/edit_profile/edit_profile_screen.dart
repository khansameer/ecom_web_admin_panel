import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/core/validation/validation.dart';
import 'package:neeknots/provider/profile_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formProfileKey = GlobalKey<FormState>();
    return commonScaffold(
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return commonAppBackground(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Consumer<ProfileProvider>(
                  builder: (context, provider, child) {
                    return commonPopScope(
                      onBack: () {
                        provider.resetState();
                      },
                      child: Form(
                        key: formProfileKey,
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
                              text: "Update Information",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : colorLogo,
                            ),
                            const SizedBox(height: 2),
                            commonDescriptionText(
                              text:
                                  "Review and update your personal details to keep your account accurate.",
                            ),
                            const SizedBox(height: 30),
                            Column(
                              spacing: 24,
                              children: [
                                commonTextField(
                                  hintText: "First Name",
                                  validator: (value) => emptyError(value, errorMessage: "First Name is required"),

                                  controller: provider.tetFName,
                                  maxLines: 1,

                                  keyboardType: TextInputType.name,

                                  prefixIcon: commonPrefixIcon(
                                    image: icProfileMenu,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                commonTextField(
                                  hintText: "Last Name",
                                  maxLines: 1,
                                  validator: (value) => emptyError(value, errorMessage: "Last Name is required"),
                                  controller: provider.tetLName,
                                  keyboardType: TextInputType.name,
                                  prefixIcon: commonPrefixIcon(
                                    image: icProfileMenu,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                commonTextField(
                                  hintText: "Email Address",
                                  maxLines: 1,
                                  readOnly: true,
                                  validator: validateEmail,
                                  controller: provider.tetEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: commonPrefixIcon(
                                    image: icEmail,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),

                                commonTextField(
                                  hintText: "Phone Number",
                                  maxLines: 1,
                                  validator: validatePhoneNumber,
                                  controller: provider.tetPhoneNo,
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: commonPrefixIcon(
                                    image: icPhone,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 50),
                            commonButton(text: "Update", onPressed: () {
                              hideKeyboard(context);
                              if (formProfileKey.currentState?.validate() ==
                                  true) {
                                //put valid logic


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
