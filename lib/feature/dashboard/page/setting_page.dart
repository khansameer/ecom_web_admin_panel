import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/provider/profile_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../core/component/CommonSwitch.dart';
import '../../../main.dart';
import '../../../provider/customer_provider.dart';
import '../../../provider/image_picker_provider.dart';
import '../../../provider/order_provider.dart';
import '../../../provider/product_provider.dart';
import '../setting_widget/common_setting_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(
      context,
      listen: false,
    );

    return Consumer2<ThemeProvider, ProfileProvider>(
      builder: (context, themeProvider, provider, child) {
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
              color: themeProvider.isDark ? Colors.white : colorLogo,
            ),
            SizedBox(height: 4),
            commonText(
              textAlign: TextAlign.center,
              text: "sameer@redefinesolutions.com",
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: themeProvider.isDark
                  ? Colors.white
                  : Colors.black.withValues(alpha: 0.8),
            ),
            SizedBox(height: 36),
            _commonView(
              onTap: () {
                navigatorKey.currentState?.pushNamed(
                  RouteName.editProfileScreen,
                );
              },
              provider: themeProvider,
              text: "Edit Information",
              image: icInfo,
            ),
            SizedBox(height: 24),
            _commonView(
              provider: themeProvider,
              text: "Notification",
              image: icNotification,
              trailing: CommonSwitch(
                value: themeProvider.isNotification,
                onChanged: (value) => themeProvider.setNotification(true),
                activeThumbColor: Colors.white,
                inactiveThumbColor: colorLogo,
                activeTrackColor: colorLogo,
                inactiveTrackColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            _commonView(
              text: themeProvider.isDark ? "Dark Theme" : "Light Theme ",
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
              onTap: () {
                navigatorKey.currentState?.pushNamed(
                  RouteName.changePasswordScreen,
                );
              },
              image: icPassword,
              provider: themeProvider,
              text: "Change Password",
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                commonInkWell(
                  onTap: () {
                    showCommonDialog(
                      confirmText: "Yes",
                      onPressed: () {

                        context.read<ProductProvider>().reset();
                        context.read<OrdersProvider>().resetFilters();
                        context.read<CustomerProvider>().reset();
                        context.read<ProfileProvider>().resetState();
                        context.read<LoginProvider>().resetState();

                        navigatorKey.currentState?.pushNamedAndRemoveUntil(
                          RouteName.loginScreen,
                          (Route<dynamic> route) => false,
                        );
                      },
                      cancelText: "No",
                      title: "Logout?",
                      context: context,
                      content: "Are you sure want to logout",
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 50),
                    decoration: commonBoxDecoration(color: themeProvider.isDark?Colors.white:colorLogo),
                    child: Center(
                      child: commonText(
                        text: "Logout".toUpperCase(),
                        color: themeProvider.isDark?Colors.black: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _commonView({
    String? text,
    Widget? trailing,
    String? image,
    void Function()? onTap,
    required ThemeProvider provider,
  }) {
    return Container(
      decoration: commonBoxDecoration(
        color: Colors.transparent,
        borderColor: colorBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: commonListTile(
          onTap: onTap,
          titleFontWeight: FontWeight.w500,
          titleFontSize: 14,
          textColor: provider.isDark ? Colors.white : colorLogo,
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
              color: provider.isDark
                  ? Colors.transparent
                  : colorLogo.withValues(alpha: 0.05),
              borderColor: provider.isDark
                  ? Colors.white
                  : colorLogo.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: commonPrefixIcon(
                width: 20,
                colorIcon: provider.isDark ? Colors.white : colorLogo,
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
