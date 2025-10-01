import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/admin/admin_dashboad.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formLoginKey = GlobalKey<FormState>();
    return commonScaffold(
      body: Consumer2<ThemeProvider, LoginProvider>(
        builder: (context, themeProvider, provider, child) {
          return commonAppBackground(
            child: Stack(
              children: [
                Center(
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
                                // commonButton(
                                //   text: "Admin",
                                //   onPressed: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) =>
                                //             AdminDashboardScreen(),
                                //       ),
                                //     );
                                //   },
                                // ),
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
                                  text: "Welcome back 👋 ",
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: themeProvider.isDark
                                      ? Colors.white
                                      : colorLogo,
                                ),
                                const SizedBox(height: 2),
                                commonDescriptionText(
                                  text: "Please auth to continue  ",
                                ),

                                const SizedBox(height: 20),
                                commonLoginView(
                                  provider: provider,
                                  onPressSignUp: TapGestureRecognizer()
                                    ..onTap = () {
                                      hideKeyboard(context);

                                      navigatorKey.currentState?.pushNamed(
                                        RouteName.signupScreen,
                                      );
                                    },

                                  onPressed: () async {
                                    hideKeyboard(context);
                                    String fullNumber =
                                        provider.tetCountryCodeController.text +
                                        provider.tetPhone.text;

                                    if (formLoginKey.currentState?.validate() ==
                                        true) {
                                      try {
                                        final userData = await provider.login(
                                          email: provider.tetEmail.text.trim(),
                                          mobile: fullNumber.trim(),
                                        );

                                        navigatorKey.currentState
                                            ?.pushNamedAndRemoveUntil(
                                              RouteName.otpVerificationScreen,
                                              arguments: userData,
                                              (Route<dynamic> route) => false,
                                            );
                                      } catch (e) {
                                        // 🔹 Extract readable error
                                        String errorMessage = e
                                            .toString()
                                            .split(": ")
                                            .last;

                                        // 🔹 Show popup
                                        showCommonDialog(
                                          title: "Error",
                                          context: context,
                                          confirmText: "Close",
                                          showCancel: false,
                                          content: errorMessage,
                                        );
                                      }
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
                provider.isLoading ? showLoaderList() : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
