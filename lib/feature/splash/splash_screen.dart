import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../core/firebase/auth_service.dart';
import '../../core/hive/app_config_cache.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  Future<void> init() async {
    String? storedEmailOrMobile = await AppConfigCache.getStoredEmailOrMobile();


    if (storedEmailOrMobile?.isNotEmpty == true) {
      checkStatus();
    } else {
      redirectToIntro();
    }


  }

  void checkStatus() async {
    try {
      String? storedEmailOrMobile =
          await AppConfigCache.getStoredEmailOrMobile();
      print('======${storedEmailOrMobile}');

      if (storedEmailOrMobile == null || storedEmailOrMobile.isEmpty) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.loginScreen,
          (Route<dynamic> route) => false,
        );
        return;
      }

      final userData = await AuthService().checkUserStatus(
        emailOrMobile: storedEmailOrMobile,
      );
      setState(() {
        _logoUrl = userData['logo_url'];
      });
      print('=====${userData}');
      if (userData.isNotEmpty == true && userData['active_status']==true) {
        await AppConfigCache.saveUser(
          uid:userData['uid'],
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          photo: userData['logo_url'] ?? '',
          mobile: userData['mobile'] ?? '',
        );
        await AppConfigCache.saveConfig(
          accessToken: userData['accessToken'] ?? '',
          storeName: userData['store_name'] ?? '',
          versionCode: userData['version_code'] ?? '',
          logoUrl: userData['logo_url'] ?? '',
        );

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.dashboardScreen,
              (Route<dynamic> route) => false,
        );
      }else
        {
          Timer(const Duration(seconds: 3), () {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              RouteName.inactiveAccountScreen,
                  (Route<dynamic> route) => false,
            );
          });
        }


    /*  Timer(const Duration(seconds: 3), () {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.dashboardScreen,
          (Route<dynamic> route) => false,
        );
      });*/
    } catch (e) {
      print('-----e$e');
      String errorMessage = e
          .toString()
          .split(": ")
          .last;
      if (e.toString() == "User not found") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.inactiveAccountScreen,
          (Route<dynamic> route) => false,
        );
      }
       if(errorMessage=="Account inactive"){
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.inactiveAccountScreen,
              (Route<dynamic> route) => false,
        );
      }
      else {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.loginScreen,
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  redirectToIntro() {
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
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return commonAppBackground(
            child: Center(
              child: commonNetworkImage(
                errorWidget: SizedBox(
                  width: size.width * 0.8,
                  height: 100,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(15),
                      child: commonAssetImage(
                        icAppLogo,
                        width: size.width * 0.7,
                        height: 100,
                      ),
                    ),
                  ),
                ),
                fit: BoxFit.scaleDown,
                _logoUrl ?? '',
                size: size.width * 0.8,
              ),
            ),
          );
        },
      ),
    );
  }
}
