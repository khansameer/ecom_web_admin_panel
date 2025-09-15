import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';

notificationWidget() {
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
              text: "0",
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
