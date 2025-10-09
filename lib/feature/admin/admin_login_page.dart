import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/admin/admin_dashboad.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/core/validation/validation.dart';
import 'package:neeknots/feature/admin/admin_home_page.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../auth/login_widget.dart';
import 'admin_home_sameer.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

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
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double width = constraints.maxWidth;
                              double containerWidth;
                              double padding;
                              if (width >= 1200) {
                                // Desktop
                                containerWidth = width * 0.33;
                                padding = 36;
                              } else if (width >= 800) {
                                // Tablet
                                containerWidth = width * 0.5;
                                padding = 30;
                              } else {
                                // Mobile
                                containerWidth = width * 0.9;
                                padding = 24;
                              }
                              return Form(
                                key: formLoginKey,
                                child: Container(
                                  padding: EdgeInsets.all(padding),
                                  width: containerWidth,
                                  decoration: commonBoxDecoration(
                                    borderRadius: 12,
                                    borderColor: themeProvider.isDark
                                        ? Colors.white54
                                        : colorBorder,
                                    color: themeProvider.isDark
                                        ? colorBorder
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Align(
                                        alignment: AlignmentGeometry.center,
                                        child: commonAssetImage(
                                          icAppLogo,
                                          height: 72,
                                          width: size.width * 0.7,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
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
                                        text: "E-Commerce Admin Panel",
                                      ),
                                      const SizedBox(height: 24),
                                      commonTextField(
                                        hintText: "Email",
                                        controller: provider.tetEmail,
                                        validator: validateEmail,
                                        prefixIcon: commonPrefixIcon(
                                          image: icEmail,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      commonTextField(
                                        hintText: "Password",
                                        controller: provider.tetPassword,
                                        validator: validatePassword,
                                        obscureText: provider.obscurePassword,
                                        maxLines: 1,
                                        prefixIcon: commonPrefixIcon(
                                          image: icPassword,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            // provider.toggleCurrentPassword();
                                          },
                                          child: Icon(
                                            provider.obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      commonButton(
                                        text: "Continue",
                                        width: size.width,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminHomePage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
