import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../core/image/image_utils.dart';

class InactiveAccountScreen extends StatelessWidget {
  const InactiveAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: commonAppBackground(
        child: Consumer<ThemeProvider>(
          builder: (context,themeProvider,child) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo (Optional)
                      // Block Icon
                      commonAssetImage(
                        icAppLogo,
                        color: themeProvider.isDark ? Colors.white : colorLogo,
                        width: size.width * 0.6,
                      ),
                      const SizedBox(height: 40),

                      // Title
                      commonHeadingText(
                        text: "Account Inactive",
                        fontSize: 24,
                        color: themeProvider.isDark
                            ? Colors.white
                            : colorLogo,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 16),

                      // Long Description
                      commonText(
                        text:
                            "Your account has been deactivated due to policy or security reasons.\n"
                            "You cannot continue using this app until your account is reactivated.\n"
                            "Please contact our support team for more details and assistance.\n"
                            "We are here to help you restore your access as quickly as possible.",
                        textAlign: TextAlign.center,
                        style: commonTextStyle(
                          fontSize: 14,

                          color:colorTextDesc1,
                        ),
                      ),

                      const SizedBox(height: 80),
                      commonButton(text: "Contact to Admin", onPressed: (){
                        if (Platform.isAndroid) {
                          SystemNavigator.pop(); // recommended
                          // OR: exit(0); // force kill
                        } else if (Platform.isIOS) {
                          exit(0); // works, but App Store may reject
                        }

                      }),
                      // Contact Support Button




                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
