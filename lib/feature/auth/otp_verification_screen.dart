import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/signup_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../core/color/color_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';

class OtpVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const OtpVerificationScreen({super.key, required this.userData});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _emailOtpController = TextEditingController();
  final TextEditingController _mobileOtpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Verify OTP",
        context: context,
        centerTitle: true,
      ),
      body: Consumer2<ThemeProvider, SignupProvider>(
        builder: (context, themeProvider, provider, child) {
          return Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
                      children: [
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            commonHeadingText(
                              text: "OTP Verification",
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : colorLogo,
                            ),

                            const SizedBox(height: 10),
                            commonDescriptionText(
                              textAlign: TextAlign.center,
                              text:
                                  "We have sent OTPs to your registered email (${widget.userData["email"]}) "
                                  "and mobile number (${widget.userData["mobile"]}).\n"
                                  "Please enter them below to verify your account.",
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        commonTextField(
                          controller: _emailOtpController,
                          hintText: "Email OTP",
                        ),
                        commonTextField(
                          controller: _mobileOtpController,
                          hintText: "Mobile OTP",
                        ),

                        SizedBox(height: 10),
                        commonButton(
                          text: "Verify",
                          onPressed: () async {
                            try {
                              final data = await provider.verifyOtp(
                                userID: widget.userData['uid'],
                                enteredOtp: _emailOtpController.text,
                              );
                              if (data?.isNotEmpty == true) {
                                await AppConfigCache.saveUser(
                                  uid: widget.userData['uid'],
                                  name: widget.userData['name'],
                                  email: widget.userData['email'],
                                  photo: widget.userData['logo_url'],
                                  mobile: widget.userData['mobile'],
                                );
                                await AppConfigCache.saveConfig(
                                  accessToken: widget.userData['accessToken'] ?? '',
                                  storeName: widget.userData['store_name'] ?? '',
                                  versionCode:
                                      widget.userData['version_code'] ?? '',
                                  logoUrl: widget.userData['logo_url'] ?? '',
                                );

                                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                                  RouteName.dashboardScreen,
                                  (Route<dynamic> route) => false,
                                );
                              }
                            } catch (e) {
                              String errorMessage = e.toString().split(": ").last;

                              // 🔹 Show popup
                              showCommonDialog(
                                title: "Error",
                                context: context,
                                confirmText: "Close",
                                showCancel: false,
                                content: errorMessage,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              provider.isLoading?showLoaderList():SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }
}
