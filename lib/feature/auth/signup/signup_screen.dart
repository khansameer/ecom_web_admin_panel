import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/feature/auth/signup/signup_form_widget.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/provider/signup_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../core/image/image_utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    final formSignupKey = GlobalKey<FormState>();
    final signUpProvider = Provider.of<SignupProvider>(context);

    return commonScaffold(
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return commonPopScope(
            onBack: (){
              context.read<LoginProvider>().resetState();
            },
            child: Stack(
              children: [
                SafeArea(
                  child: commonAppBackground(
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
                              key: formSignupKey,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: size.height * 0.08),
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
                                  const SizedBox(height: 30),
                                  Center(
                                    child: Column(
                                      children: [


                                        commonHeadingText(
                                          text: "Create your Shopify Account",
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: themeProvider.isDark
                                              ? Colors.white
                                              : colorLogo,
                                        ),
                                        const SizedBox(height: 6),
                                        commonDescriptionText(
                                          textAlign: TextAlign.center,

                                          text:
                                              "Fill in the details below to register your store and start using the app.",
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                 /* GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                      _pickedImage != null ? FileImage(_pickedImage!) : null,
                                      child: _pickedImage == null
                                          ? const Icon(Icons.camera_alt, size: 40)
                                          : null,
                                    ),
                                  ),*/
            /*
                                  commonButton(text: "Otp", onPressed: ()  async {

                                    try {
                                      print('====');
                                      await signUpProvider.sendOtpBoth(
                                        email: "pathansameerahmed@gmail.com",
                                        phone: "+917984512507",
                                      );
                                      print("OTP send initiated ✅");
                                    } catch (e) {
                                      print('--e#$e');
                                    }
                                  }),*/
                                  SizedBox(height: 20,),
                                  commonSignUpView(
                                    provider: provider,
                                    onPressSignUp: TapGestureRecognizer()
                                      ..onTap = () {
                                        hideKeyboard(context);

                                        navigatorKey.currentState?.pushNamed(
                                          RouteName.loginScreen,
                                        );
                                      },

                                    onPressed: () async {
                                      hideKeyboard(context);
                                      try {
                                        await signUpProvider.signup(
                                          email: provider.tetEmail.text.trim(),

                                          storeName: provider.tetStoreName.text
                                              .trim(),
                                          websiteUrl: provider.tetWebsiteUrl.text
                                              .trim(),
                                          mobile: provider.tetPhone.text.trim(),
                                          name: provider.tetFullName.text.trim(),
                                          photo: _pickedImage,
                                        );


                                        showCommonDialog(
                                          title: "Success",
                                          onPressed: () {
                                            Timer(
                                              const Duration(milliseconds: 500),
                                              () async {
                                                navigatorKey.currentState
                                                    ?.pushNamedAndRemoveUntil(
                                                      RouteName.loginScreen,
                                                      (Route<dynamic> route) => false,
                                                    );
                                              },
                                            );
                                          },
                                          context: context,
                                          content:
                                              "Your account is successfully created. You can access it after 24 hours.",
                                        );
                                      } catch (e) {
                                        print('====$e');
                                        String errorMessage = e
                                            .toString()
                                            .split(": ")
                                            .last;

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
                          );
                        },
                      ),
                    ),
                  ),
                ),
                signUpProvider.isLoading?showLoaderList():SizedBox.shrink()
              ],
            ),
          );
        },
      ),
    );
  }
}
