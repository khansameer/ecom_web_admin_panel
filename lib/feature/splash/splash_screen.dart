import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/routes/app_routes.dart';

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
      body: commonAppBackground(
        child: Center(
          child: commonSvgWidget(
            color: colorLogo,
            path: icLogo,
            width: size.width * 0.8,
          ),
        ),
      ),
    );
  }
}
