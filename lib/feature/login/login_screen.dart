import 'package:flutter/material.dart';
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
                        key: formLoginKey,
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
                              text: "Welcome back 👋 ",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : colorLogo,
                            ),
                            const SizedBox(height: 2),
                            commonDescriptionText(
                              text: "Please login to continue  ",
                            ),
                            const SizedBox(height: 20),
                            commonLoginView(
                              provider: provider,
                              onPressed: () {
                                hideKeyboard(context);
                                if (formLoginKey.currentState?.validate() ==
                                    true) {
                                  //put valid logic

                                  navigatorKey.currentState
                                      ?.pushNamedAndRemoveUntil(
                                        RouteName.dashboardScreen,
                                        (Route<dynamic> route) => false,
                                      );
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
          );
        },
      ),
    );
  }
}
