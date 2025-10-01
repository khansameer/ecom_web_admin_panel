import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/signup_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../core/color/color_utils.dart';
import '../../core/component/common_pin_code_field.dart';
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
  final TextEditingController _phoneOtpController = TextEditingController();
  @override
  void dispose() {
    _emailOtpController.dispose();
    _phoneOtpController.dispose();
    super.dispose();
  }
  Future<void> _validateOtp() async {
    String emailOtp = _emailOtpController.text.trim();
    String phoneOtp = _phoneOtpController.text.trim();

    // Email OTP validation
    if (emailOtp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter Email OTP")));
      return;
    } else if (emailOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email OTP must be 4 digits")),
      );
      return;
    }

    // Phone OTP validation

    if (phoneOtp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter Phone OTP")));
      return;
    } else if (phoneOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone OTP must be 4 digits")),
      );
      return;
    }
    final provider = Provider.of<SignupProvider>(context, listen: false);
    try {
      final data = await provider.verifyOtp(
        userID: widget.userData['uid'] ?? '',
        enteredOtp: _emailOtpController.text,
      );
      if (data?.isNotEmpty == true) {
        await AppConfigCache.saveUser(
          uid: widget.userData['uid'],
          name: widget.userData['name'] ?? '',
          email: widget.userData['email'] ?? '',
          photo: widget.userData['logo_url'] ?? '',
          mobile: widget.userData['mobile'] ?? '',
        );
        await AppConfigCache.saveConfig(
          accessToken: widget.userData['accessToken'] ?? '',
          storeName: widget.userData['store_name'] ?? '',
          versionCode: widget.userData['version_code'] ?? '',
          logoUrl: widget.userData['logo_url'] ?? '',
        );

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.dashboardScreen,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      String errorMessage = e.toString().split(": ").last;

      print('${e}');
      showCommonDialog(
        title: "Error",
        context: context,
        confirmText: "Close",
        showCancel: false,
        content: errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Verify OTP",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: Consumer2<ThemeProvider, SignupProvider>(
          builder: (context, themeProvider, provider, child) {
            return Stack(
              children: [
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(height: 0),
        
                          /*commonTextField(
                            controller: _emailOtpController,
                            hintText: "Email OTP",
                          ),
                          commonTextField(
                            controller: _mobileOtpController,
                            hintText: "Mobile OTP",
                          ),
        */
                          Container(
                            decoration: commonBoxDecoration(
                              borderColor: colorBorder,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
        
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 20,
                                    ),
                                    child: commonText(
                                      text: "Enter Email OTP",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
        
                                  CommonPinCodeField(
                                    controller: _emailOtpController,
                                    activeFillColor: colorLogo,
                                    inactiveFillColor: colorBorder,
                                    selectedFillColor: colorLogo.withValues(
                                      alpha: 0.2,
                                    ),
                                    onCompleted: (code) {
                                      print("Entered OTP: $code");
                                    },
                                    onChanged: (val) {
                                      print("Changed: $val");
                                    },
                                  ),
        
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 20,
                                    ),
                                    child: commonText(
                                      text: "Enter Phone OTP",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
        
                                  CommonPinCodeField(
                                    controller: _phoneOtpController,
                                    activeFillColor: colorLogo,
                                    inactiveFillColor: colorBorder,
                                    selectedFillColor: colorLogo.withValues(
                                      alpha: 0.2,
                                    ),
                                    onCompleted: (code) {
                                      print("Entered OTP: $code");
                                    },
                                    onChanged: (val) {
                                      print("Changed: $val");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 0),
                          commonTextRich(
                            text1: "If you didn’t receive a code! ",
                            text2: "Resend",
                            onTap: TapGestureRecognizer()..onTap = () {},

                            textStyle1: commonTextStyle(color: themeProvider.isDark?Colors.white:Colors.black),
                            textStyle2: commonTextStyle(
                              color: themeProvider.isDark?Colors.white:colorLogo,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
        
                          commonButton(text: "Verify", onPressed: _validateOtp),
                        ],
                      ),
                    ),
                  ],
                ),
                provider.isLoading ? showLoaderList() : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
