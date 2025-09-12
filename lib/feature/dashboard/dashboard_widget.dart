import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';

notificationWidget() {
  return Stack(
    children: [
      commonPrefixIcon(
        image: icNotification,
        width: 35,
        height: 35,
        colorIcon: Colors.white,
      ),

      Positioned(
        right: 0,
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
