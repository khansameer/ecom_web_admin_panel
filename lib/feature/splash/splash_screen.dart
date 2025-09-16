import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    redirectToIntro();
  }

  redirectToIntro() {
    Timer(const Duration(seconds: 3), () async {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteName.loginScreen,
            (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: Consumer<ThemeProvider>(
        builder: (context,provider,child) {
          return commonAppBackground(

            child: Center(
              child: commonSvgWidget(
                color: provider.isDark?Colors.white: colorLogo,
                path: icLogo,
                width: size.width * 0.8,
              ),
            ),
          );
        }
      ),
    );
  }
}
