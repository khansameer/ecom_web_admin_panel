import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/provider/signup_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../core/color/color_utils.dart';
import '../../core/component/common_pin_code_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const OtpVerificationScreen({super.key, required this.userData});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

 /* @override
  void dispose() {
    // Stop any running timer from provider before screen destroys
    Provider.of<LoginProvider>(context, listen: false).cancelResendTimer();

    // Dispose controller safely
    otpController.dispose();

    super.dispose();
  }*/
  LoginProvider? _loginProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save the provider reference safely while widget is active
    _loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // Use the saved reference instead of context
    _loginProvider?.cancelResendTimer();

    otpController.dispose();
    super.dispose();
  }
  Future<void> _validateOtp() async {
    final provider = Provider.of<LoginProvider>(context, listen: false);

    String emailOtp =otpController.text.trim();
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

    try {
      Map<String, dynamic> body = {
        "email": widget.userData['email'],
        "mobile": widget.userData['mobile'],
        "otp": emailOtp,
      };
      await provider.verifyOtp(body: body);
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
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LoginProvider>(context, listen: false).startResendTimer();
    });
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
        child: Consumer3<ThemeProvider, SignupProvider, LoginProvider>(
          builder: (context, themeProvider, provider, loginProvider, child) {
            return commonPopScope(
              onBack: () {
                loginProvider.resetState();
              },
              child: Stack(
                children: [
                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 16,
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

                                const SizedBox(height: 16),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 30,
                                      ),
                                      child: commonText(
                                        text: "Enter Email OTP",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    Align(
                                      alignment: AlignmentGeometry.center,
                                      child: CommonPinCodeField(
                                        controller:otpController,
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
                                    ),

                                    /*    Padding(
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
                      */
                                    /*CommonPinCodeField(
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
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 0),
                            /*commonTextRich(
                              text1: "If you didn’t receive a code! ",
                              text2: "Resend",
                              onTap: TapGestureRecognizer()..onTap = () {},

                              textStyle1: commonTextStyle(color: themeProvider.isDark?Colors.white:Colors.black),
                              textStyle2: commonTextStyle(
                                color: themeProvider.isDark?Colors.white:colorLogo,
                                fontWeight: FontWeight.w600,
                              ),
                            ),*/
                            Consumer<LoginProvider>(
                              builder: (context, provider, _) {
                                return commonTextRich(
                                  text1: provider.canResend
                                      ? "Didn’t receive a code? "
                                      : "Resend available in ${provider.secondsRemaining}s ",
                                  text2: provider.canResend ? "Resend" : "",
                                  onTap: provider.canResend
                                      ? (TapGestureRecognizer()
                                          ..onTap = () async {
                                            Map<String, dynamic> body = {
                                              "email": widget.userData['email'],
                                              "mobile":
                                                  widget.userData['mobile'],
                                            };
                                            await provider.resendOtp(
                                              body: body,
                                            );
                                            // await provider.resendOtp(userId: widget.userData['uid'],email: "pathansameerahmed@gmail.com");
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "OTP resent successfully!",
                                                ),
                                              ),
                                            );
                                          })
                                      : (TapGestureRecognizer()..onTap = null),
                                  textStyle1: commonTextStyle(
                                    color: themeProvider.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textStyle2: commonTextStyle(
                                    color: provider.canResend
                                        ? (themeProvider.isDark
                                              ? Colors.white
                                              : colorLogo)
                                        : Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),

                            commonButton(
                              text: "Verify",
                              onPressed: _validateOtp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  provider.isLoading || loginProvider.isLoading
                      ? showLoaderList()
                      : SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
