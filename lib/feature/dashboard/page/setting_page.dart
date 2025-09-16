import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/profile_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/component/CommonSwitch.dart';
import '../../../provider/image_picker_provider.dart';
import '../setting_widget/common_setting_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(
      context,
      listen: false,
    );

    return Consumer2<ThemeProvider,ProfileProvider>(
      builder: (context,themeProvider,provider,child) {
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 30),
            profileView(
              themeProvider: themeProvider,
              context: context,
              provider: provider,
              imageProvider: imageProvider,
            ),

            SizedBox(height: 36),
            commonText(
              textAlign: TextAlign.center,
              text: "Sameer Khan",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color:themeProvider.isDark?Colors.white: colorLogo,
            ),
            SizedBox(height: 4),
            commonText(
              textAlign: TextAlign.center,
              text: "sameer@redefinesolutions.com",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: themeProvider.isDark?Colors.white:Colors.black.withValues(alpha: 0.8),
            ),
            SizedBox(height: 36),
            _commonView(
                provider: themeProvider,
                text: "Edit Information", image: icInfo),
            SizedBox(height: 24),
            _commonView(
              provider: themeProvider,
              text: "Notification",
              image: icNotification,
              trailing: CommonSwitch(
                value: themeProvider.isNotification,
                onChanged: (value) => themeProvider.setNotification(),
                activeThumbColor: Colors.white,
                inactiveThumbColor: colorLogo,
                activeTrackColor: colorLogo,
                inactiveTrackColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            _commonView(
              text: themeProvider.isDark?"Dark Theme":"Light Theme ",
              provider: themeProvider,
              image: icTheme,
              trailing: CommonSwitch(
                value: themeProvider.isDark,
                onChanged: (value) => themeProvider.toggleTheme(),
                activeThumbColor: Colors.white,
                inactiveThumbColor: colorLogo,
                activeTrackColor: colorLogo,
                inactiveTrackColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            _commonView(
              image: icPassword,
                provider: themeProvider,
                text: "Change Password"),
          ],
        );
      }
    );
  }

  _commonView({String? text, Widget? trailing, String? image,required ThemeProvider provider}) {
    return Container(
        decoration: commonBoxDecoration(
            color: Colors.transparent,
            borderColor: colorBorder),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: commonListTile(
          titleFontWeight: FontWeight.w500,
          titleFontSize: 14,
          textColor:provider.isDark?Colors.white: colorLogo,
          contentPadding: EdgeInsetsGeometry.zero,
          trailing:
              trailing ??
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 15,
                ),
              ),
          leadingIcon: Container(
            width: 45,
            height: 45,
            decoration: commonBoxDecoration(
              color: provider.isDark?Colors.transparent:colorLogo.withValues(alpha: 0.05),
              borderColor: provider.isDark?Colors.white:colorLogo.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: commonPrefixIcon(
                width: 20,
                colorIcon: provider.isDark?Colors.white:colorLogo,
                height: 20,
                image: image ?? icTotalProduct,
              ),
            ),
          ),
          title: text ?? "Change Theme",
        ),
      ),
    );
  }
}
