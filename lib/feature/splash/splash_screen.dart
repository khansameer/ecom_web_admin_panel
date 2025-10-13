import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/admin/admin_dashboad.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/admin/admin_login_page.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../core/firebase/auth_service.dart';
import '../../core/hive/app_config_cache.dart';
import '../../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  Future<void> init() async {
    //String? storedEmailOrMobile = await AppConfigCache.getStoredEmailOrMobile();
    UserModel? user = await AppConfigCache.getUserModel(); // await the future
    if (kIsWeb) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteName.adminLoginPage,
        (Route<dynamic> route) => false,
      );
    } else {
      if (user?.id != null) {
        checkStatus();
      } else {
        redirectToIntro();
      }
    }
  }

  void checkStatus() async {
    try {
      UserModel? user = await AppConfigCache.getUserModel(); // await the future
      if (user?.id == null) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.loginScreen,
          (Route<dynamic> route) => false,
        );
        return;
      } else {
        final provider = Provider.of<LoginProvider>(context, listen: false);
        await provider.checkStatus(id: user?.id);
      }
    } catch (e) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteName.loginScreen,
            (Route<dynamic> route) => false,
      );
    }
  }

  void redirectToIntro() {
    Timer(const Duration(seconds: 5), () async {
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
      body: Consumer2<ThemeProvider,LoginProvider >(
        builder: (context, provider,loginProvider, child) {
          return commonAppBackground(
            child: Center(
              child: commonNetworkImage(
                decoration: BoxDecoration(),
                errorWidget: Center(
                  child: commonAssetImage(
                    icAppLogo,
                    width: size.width * 0.7,

                    height: 72,
                  ),
                ),
                fit: BoxFit.scaleDown,
                loginProvider.logoUrl ?? '',
                size: size.width * 0.7,
              ),
            ),
          );
        },
      ),
    );
  }
}
