import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/theme_provider.dart';

import '../../../core/image_picker/image_pick_and_crop_widget.dart';
import '../../../provider/image_picker_provider.dart';
import '../../../provider/profile_provider.dart';

Widget buildAvatar({
  required ProfileProvider provider,
  required ThemeProvider themeProvider,
  required ImagePickerProvider imageProvider,
}) {
  final path = imageProvider.imagePath;

  print('=====path======${path}');
  final fileExists = path != null && File(path).existsSync();

  return Container(
    width: 120,
    height: 120,
    decoration: commonBoxDecoration(
      shape: BoxShape.circle,
      borderColor: themeProvider.isDark ? Colors.white : colorLogo,
      borderWidth: 2,
      color: Colors.white, // prevent gray fallback
    ),
    child: fileExists
        ? ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              width: 120,
              height: 120,
              errorBuilder: (_, _, _) => Image.asset(icDummyUser),
            ),
          )
        : CircleAvatar(
            radius: 100,
            backgroundColor: Colors.white,
            child: commonCircleNetworkImage(
              errorWidget: Image.asset(icDummyUser),
              icDummyUser,
              fit: BoxFit.cover,
              size: 120,
            ),
          ),
  );
}

profileView({
  required ProfileProvider provider,
  required ImagePickerProvider imageProvider,
  required ThemeProvider themeProvider,
  required BuildContext context,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        children: [
          buildAvatar(
            themeProvider: themeProvider,
            provider: provider,
            imageProvider: imageProvider,
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: commonInkWell(
              onTap: () async {
                final path = await CommonImagePicker.pickImage(
                  context,
                  themeProvider,
                );
                if (path != null) {
                  print('=======$path');
                  imageProvider.setImagePath(path);

                  provider.setImageFilePath(
                    img: File(imageProvider.imagePath!),
                  );
                }
              },
              child: Container(
                decoration: commonBoxDecoration(
                  shape: BoxShape.circle,
                  color: colorLogo,
                ),
                width: 35,
                height: 35,
                child: Center(
                  child: commonAssetImage(
                    icPen,
                    color: Colors.white,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
