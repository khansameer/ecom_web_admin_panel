import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

notificationWidget() {

  return commonInkWell(
    onTap: (){
      navigatorKey.currentState?.pushNamed(RouteName.notificationScreen);
    },
    child: Consumer<DashboardProvider>(
      builder: (context,provider,child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            commonPrefixIcon(
              image: icNotification,
              width: 24,
              height: 24,
              colorIcon: Colors.white,
            ),

            Positioned(
              right: -4,
              top: -9,
              child: Container(
                width: 20,
                height: 20,
                decoration: commonBoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: commonText(
                    text:  provider.notifications.isNotEmpty?'${provider.notifications.length}':"0",
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    ),
  );
}
