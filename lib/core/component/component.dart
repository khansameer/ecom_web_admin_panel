import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/core/string/string_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../feature/order_details/order_common_widget.dart';
import 'common_dropdown.dart';

String generateUniqueId() {
  final random = Random();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomNumber = random.nextInt(999999);
  return "$timestamp$randomNumber";
}

AppBar commonAppBar({
  required final String title,
  final bool? centerTitle,
  final List<Widget>? actions,
  final Widget? leading,
  final Color? backgroundColor,
  required final BuildContext context,
  final IconThemeData? iconTheme,
  final List<Color>? gradientColors,
}) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return AppBar(
    surfaceTintColor: Colors.transparent,
    iconTheme: iconTheme,
    title: Text(
      title.toUpperCase(),
      style: commonTextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    centerTitle: centerTitle,
    backgroundColor: backgroundColor,
    // important
    elevation: 0,
    actions: actions,
    leading:
        leading ??
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white),
        ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: themeProvider.isDark ? colorDarkBgColor : colorLogo,
        borderRadius: BorderRadius.circular(0),
      ),
    ),
  );
}

Column commonTextFieldView({
  String? text,
  String? hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? initialValue,
  TextInputType? keyboardType,
  bool readOnly = false,
  bool? obscureText,
  void Function()? onTap,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  TextEditingController? controller,
  int? maxLines,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      commonText(text: text ?? "Email Id", fontSize: 13),
      commonTextField(
        onTap: onTap,
        validator: validator,
        controller: controller,
        maxLines: maxLines ?? 1,
        readOnly: readOnly,
        textStyle: commonTextStyle(fontSize: 13),
        hintStyle: commonTextStyle(fontSize: 13),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType ?? TextInputType.text,
        initialValue: initialValue,
        obscureText: obscureText ?? false,
        hintText: '',
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    ],
  );
}

InkWell commonInkWell({Widget? child, void Function()? onTap}) {
  return InkWell(
    splashColor: Colors.transparent,
    focusNode: FocusNode(skipTraversal: true),
    highlightColor: Colors.transparent,

    onTap: onTap,
    child: child,
  );
}

Widget commonText({
  required String text,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  String? fontFamily,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
  TextStyle? style,
  TextDecoration? decoration,
}) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return Text(
        text,
        textAlign: textAlign,

        maxLines: maxLines,
        overflow: overflow,
        style:
            style ??
            commonTextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color ?? (themeProvider.isDark ? Colors.white : colorText),
              decoration: decoration,
            ),
      );
    },
  );
}

TextStyle commonTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? wordSpacing,
  double? letterSpacing,
  String? fontFamily,
  FontStyle? fontStyle,
  Color? decorationColor,
  TextOverflow? overflow,
  TextDecoration? decoration,
}) {
  return TextStyle(
    color: color ?? Colors.black,
    fontSize: fontSize ?? 14,
    wordSpacing: wordSpacing,
    decoration: decoration,
    overflow: overflow,
    fontFamily: fontFamily ?? fontPoppins,
    decorationColor: decorationColor,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle ?? FontStyle.normal,

    fontWeight: fontWeight ?? FontWeight.w400,
  );
}

BoxDecoration commonBoxDecoration({
  Color color = Colors.transparent,
  double borderRadius = 8.0,
  Color borderColor = Colors.transparent,
  double borderWidth = 1.0,
  List<BoxShadow>? boxShadow,
  Gradient? gradient,
  DecorationImage? image,
  BoxShape shape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: color,
    shape: shape,
    image: image,
    borderRadius: shape == BoxShape.rectangle
        ? BorderRadius.circular(borderRadius)
        : null,
    border: Border.all(color: borderColor, width: borderWidth),

    gradient: gradient,
  );
}

Widget commonButton({
  required final String text,
  required final VoidCallback onPressed,
  final Color? color,
  final Color? textColor,
  final Color? colorBorder,
  final double? radius,
  final double? height,
  final double? width,
  final double? fontSize,
  final FontWeight? fontWeight,
  final Widget? icon,
  final List<Color>? gradientColors,
  final EdgeInsetsGeometry? padding,
}) {
  return Consumer<ThemeProvider>(
    builder: (context, provider, child) {
      return SizedBox(
        height: height ?? 56,
        width: width ?? MediaQuery.sizeOf(navigatorKey.currentContext!).width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: provider.isDark ? Colors.white : colorLogo,

            borderRadius: BorderRadius.circular(radius ?? 15),
          ),
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
                  elevation: 0,
                  disabledIconColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  disabledForegroundColor: Colors.transparent,
                  backgroundColor: color ?? Colors.transparent,
                  foregroundColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                  // 👈 click effect hide
                  shadowColor: Colors.transparent,
                  // 👈 shadow bhi hide
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: colorBorder ?? Colors.transparent),
                    borderRadius: BorderRadius.circular(radius ?? 15),
                  ),
                  padding: padding,
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ), // 👈 pressed color hide
                ),
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText(
                  color:
                      textColor ??
                      (provider.isDark ? colorDarkBgColor : Colors.white),
                  text: text.toUpperCase(),
                  fontSize: fontSize,
                  // color: provider.isDark?colorDarkBgColor:Colors.white,
                  fontWeight: fontWeight ?? FontWeight.w600,
                ),
                icon ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget commonTextField({
  TextEditingController? controller,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  Widget? prefixIcon,
  bool? enabled,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  ),
  Color? borderColor,
  double borderRadius = 12.0,
  Color? fillColor,
  int? maxLines,
  bool filled = false,
  void Function()? onTap,
  bool readOnly = false,
  TextStyle? hintStyle,
  InputBorder? enabledBorder,
  String? initialValue,
  void Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatters,
  TextStyle? textStyle,
}) {
  return Consumer<ThemeProvider>(
    builder: (context, provider, child) {
      return TextFormField(
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        initialValue: controller != null ? null : initialValue ?? '',
        // initialValue: initialValue,-
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,

        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style:
            textStyle ??
            commonTextStyle(
              fontSize: 14,
              color: provider.isDark ? Colors.white : Colors.black,
            ),
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle:
              hintStyle ??
              commonTextStyle(
                color: provider.isDark
                    ? Colors.grey
                    : Colors.black.withValues(alpha: 0.5),
              ),
          contentPadding: contentPadding,

          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border:
              enabledBorder ??
              commonTextFiledBorder(borderRadius: borderRadius),
          enabledBorder:
              enabledBorder ??
              commonTextFiledBorder(borderRadius: borderRadius),
          focusedBorder:
              enabledBorder ??
              commonTextFiledBorder(borderRadius: borderRadius),
          filled: filled,
          fillColor: fillColor,
        ),
      );
    },
  );
}

OutlineInputBorder commonTextFiledBorder({
  double? borderRadius,
  Color? borderColor,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius ?? 15),
    borderSide: BorderSide(
      color: borderColor ?? Colors.grey.withValues(alpha: 0.5),
    ),
  );
}

Widget commonListTile({
  required String title,
  String? subtitle,
  Widget? leadingIcon,
  Widget? subtitleView,
  Widget? trailing,
  Widget? titleWidget,
  VoidCallback? onTap,
  Color? iconColor,
  FontWeight? titleFontWeight,
  Color? textColor,
  double borderRadius = 10,
  double titleFontSize = 14,
  Color? tileColor,
  TextOverflow? overflow,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 0,
  ),
}) {
  return ListTile(
    dense: true,
    splashColor: Colors.transparent,
    contentPadding: contentPadding,
    leading: leadingIcon,
    title:
        titleWidget ??
        Text(
          title,
          style: commonTextStyle(
            color: textColor ?? Colors.black,
            fontSize: titleFontSize,
            fontWeight: titleFontWeight ?? FontWeight.w600,
          ),
        ),
    subtitle: subtitle != null
        ? Text(
            subtitle,
            style: commonTextStyle(
              overflow: overflow,

              fontSize: 12,
              color: colorTextDesc,
            ),
          )
        : subtitleView,
    trailing: trailing,
    onTap: onTap,
  );
}

Widget commonListViewBuilder<T>({
  required List<T> items,
  ScrollController? controller,
  required Widget Function(BuildContext, int, T) itemBuilder,
  Axis scrollDirection = Axis.vertical,
  EdgeInsetsGeometry padding = const EdgeInsets.all(8),
  bool shrinkWrap = false,
  ScrollPhysics? physics,
}) {
  return ListView.builder(
    itemCount: items.length,
    shrinkWrap: shrinkWrap,
    controller: controller,
    padding: padding,
    scrollDirection: scrollDirection,
    physics: physics ?? const BouncingScrollPhysics(),
    itemBuilder: (context, index) => itemBuilder(context, index, items[index]),
  );
}

Widget commonListViewBuilderSeparated<T>({
  required List<T> items,
  required Widget Function(BuildContext, int, T) itemBuilder,
  Axis scrollDirection = Axis.vertical,
  EdgeInsetsGeometry padding = const EdgeInsets.all(0),
  bool shrinkWrap = false,
  ScrollPhysics? physics,
}) {
  return ListView.separated(
    itemCount: items.length,
    shrinkWrap: shrinkWrap,

    padding: padding,
    scrollDirection: scrollDirection,
    physics: physics ?? const BouncingScrollPhysics(),
    itemBuilder: (context, index) => itemBuilder(context, index, items[index]),
    separatorBuilder: (BuildContext context, int index) {
      return Divider(thickness: 0.5, height: 0);
    },
  );
}

Widget commonScaffold({
  required Widget body,
  String? title,
  PreferredSizeWidget? appBar,
  Widget? floatingActionButton,
  Widget? drawer,
  Widget? bottomNavigationBar,
  Color backgroundColor = Colors.white,
  bool resizeToAvoidBottomInset = true,
}) {
  return Scaffold(
    appBar:
        appBar ??
        (title != null
            ? AppBar(title: commonText(text: title), centerTitle: true)
            : null),
    body: body,
    backgroundColor: backgroundColor,
    floatingActionButton: floatingActionButton,
    drawer: drawer,
    bottomNavigationBar: bottomNavigationBar,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
  );
}

Widget commonAssetImage(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
  BorderRadius? borderRadius,
  Color? color,
}) {
  Widget image = Image.asset(
    path,
    width: width,
    height: height,
    fit: fit,
    color: color,
  );

  return borderRadius != null
      ? ClipRRect(borderRadius: borderRadius, child: image)
      : image;
}

Widget commonCircleAssetImage(
  String path, {
  double size = 60,
  BoxFit fit = BoxFit.cover,
  Color? backgroundColor = Colors.transparent,
  Color? borderColor,
  double borderWidth = 0,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor,
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
      image: DecorationImage(image: AssetImage(path), fit: fit),
    ),
  );
}

Widget showLoaderList1() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(100, 141, 219, 1), // base color
            Color.fromRGBO(70, 110, 210, 1), // medium shade
            Color.fromRGBO(40, 80, 180, 1), // darker shade
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(17),
      child: const CupertinoActivityIndicator(
        radius: 15,
        color: Colors.white,
        animating: true,
      ),
    ),
  );
}

List<TextInputFormatter> onlyNumberFormatter() {
  return [FilteringTextInputFormatter.digitsOnly];
}

PopScope<Object> commonPopScope({
  required final Widget child,
  final VoidCallback? onBack,
}) {
  return PopScope(
    canPop: true,
    onPopInvokedWithResult: (didPop, result) {
      if (didPop && onBack != null) {
        onBack();
      }
    },
    child: child,
  );
}

Center commonErrorView({String? text}) {
  return Center(
    child: commonText(
      textAlign: TextAlign.center,
      text: text ?? "No data Found",
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: Colors.black.withValues(alpha: 0.5),
    ),
  );
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

Map<String, Map<String, dynamic>> buildNotificationPayload({
  required String token,
  required String title,
  required String body,
  Map<String, dynamic>? data,
}) {
  return {
    "message": {
      "token": token,
      "notification": {"title": title, "body": body},
      "android": {
        "notification": {
          "channel_id": "high_importance_channel",
          "icon": "@mipmap/ic_launcher", // Optional: set launcher icon
        },
      },
      "data": data ?? {},
    },
  };
}

void showCommonBottomSheet({
  required BuildContext context,
  required Widget content,

  bool isDismissible = true,
}) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:themeProvider.isDark?colorDarkBgColor: Colors.white,
    isDismissible: isDismissible,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child:content,
      );
    },
  );
}

Future<bool?> showCommonDialog({
  required String title,
  required BuildContext context,
  String? content,
  String confirmText = 'OK',
  bool? barrierDismissible,
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  void Function()? onPressed,
  List<Widget>? actions,
  Widget? contentView,
  bool showCancel = true,
}) {
  return showCupertinoDialog<bool>(
    barrierDismissible: barrierDismissible ?? false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: commonText(
          text: title,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        content:
            contentView ??
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: commonText(
                text: content ?? '',
                textAlign: TextAlign.center,
                fontSize: 12,
              ),
            ),
        actions:
            actions ??
            <Widget>[
              if (showCancel)
                CupertinoDialogAction(
                  isDefaultAction: false,
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop(false); // return false
                  },
                  child: commonText(
                    text: cancelText.toUpperCase(),
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed:
                    onPressed ??
                    () {
                      onConfirm?.call();
                      Navigator.of(context).pop(true); // return true
                    },
                child: commonText(
                  text: confirmText.toUpperCase(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
      );
    },
  );
}

Widget showLoaderList() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(100, 141, 219, 1), // base color
            Color.fromRGBO(70, 110, 210, 1), // medium shade
            Color.fromRGBO(40, 80, 180, 1), // darker shade
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(17),
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    ),
  );
}

String cleanFirebaseError(String message) {
  return message.replaceAll(RegExp(r"\[.*?\]\s*"), "");
}

Container commonAppBackground({required Widget child}) {
  var size = MediaQuery.of(navigatorKey.currentContext!).size;
  final themeProvider = Provider.of<ThemeProvider>(
    navigatorKey.currentContext!,
  );
  return Container(
    width: size.width,
    height: size.height,
    decoration: commonBoxDecoration(
      borderRadius: 0,
      color: themeProvider.isDark ? colorDarkBgColor : Colors.white,
      //image: DecorationImage(fit: BoxFit.fill, image: AssetImage(icSa)),
    ),
    child: child,
  );
}

commonSvgWidget({
  required String path,
  double? width,
  double? height,
  Color? color,
}) {
  return SvgPicture.asset(
    path,
    width: width,
    height: height,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );
}

commonHeadingText({
  String? text,
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
}) {
  return commonText(
    text: text ?? '',
    color: color,
    fontWeight: fontWeight ?? FontWeight.w800,
    fontSize: fontSize ?? 18,
  );
}

commonTitleText({String? text}) {
  return commonText(
    text: text ?? '',
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
}

commonSubTitleText({String? text}) {
  return commonText(
    text: text ?? '',
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );
}

commonDescriptionText({String? text}) {
  return commonText(
    text: text ?? '',
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );
}

commonPrefixIcon({
  required String image,
  double? width,
  double? height,
  Color? colorIcon,
}) {
  return SizedBox(
    width: width ?? 24,
    height: height ?? 24,
    child: Center(
      child: commonAssetImage(
        image,
        width: width ?? 24,
        height: height ?? 24,
        color: colorIcon ?? Colors.grey,
      ),
    ),
  );
}

class BottomNavItems {
  static const List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icProductMenu)),
      label: 'Product',
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icOrderMenu)),
      label: 'Order',
    ),

    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icHomeMenu)),
      label: 'Home',
    ),

    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icTotalUser)),
      label: 'Customers',
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(icSetting)),
      label: 'Account',
    ),
  ];
}

void showCommonFilterDialog({
  required BuildContext context,
  required String title,
  required List<FilterItem> filters,
  required VoidCallback onReset,
  required VoidCallback onApply,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Container(
                color: themeProvider.isDark ? colorDarkBgColor : Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonText(
                          text: title,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.isDark
                              ? Colors.white
                              : colorLogo,
                        ),
                        commonInkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: commonBoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                size: 15,
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Dynamic Dropdowns
                    ...filters.map((filter) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonText(
                            text: filter.label,
                            color: themeProvider.isDark
                                ? Colors.white
                                : colorText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          const SizedBox(height: 5),
                          CommonDropdown(
                            initialValue: filter.selectedValue,
                            items: filter.options,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  filter.selectedValue = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                    }),

                    const SizedBox(height: 10),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: commonButton(
                            text: "Reset",
                            colorBorder: colorLogo,
                            textColor: colorLogo,
                            color: Colors.white,
                            onPressed: () {
                              onReset();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: commonButton(
                            textColor: themeProvider.isDark
                                ? Colors.white
                                : Colors.white,
                            color: themeProvider.isDark ? colorLogo : colorLogo,
                            text: "Apply",
                            onPressed: () {
                              onApply();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

/// Helper model for filter items
class FilterItem {
  String label;
  List<String> options;
  String selectedValue;

  FilterItem({
    required this.label,
    required this.options,
    required this.selectedValue,
  });
}

Widget commonCircleNetworkImage(
  String? imageUrl, {
  double size = 60,
  double borderWidth = 0,
  Color borderColor = Colors.white,
  BoxFit fit = BoxFit.cover,
  Widget? placeholder,
  Widget? errorWidget,
}) {
  final isValidUrl = imageUrl != null && imageUrl.trim().isNotEmpty;

  // Final URL with base path
  final fullUrl = isValidUrl ? imageUrl : null;

  return Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(borderWidth),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: borderColor, width: borderWidth),
    ),
    child: ClipOval(
      child: isValidUrl
          ? CachedNetworkImage(
              height: size,
              width: size,
              imageUrl: fullUrl!,
              fit: fit,
              placeholder: (context, url) =>
                  placeholder ??
                  Center(child: CircularProgressIndicator(strokeWidth: 2)),
              errorWidget: (context, url, error) =>
                  errorWidget ?? Center(child: commonAssetImage(icDummyUser)),
            )
          : (errorWidget ?? Center(child: commonAssetImage(icDummyUser))),
    ),
  );
}

Widget commonNetworkImage(
  String? imageUrl, {
  double size = 60,
  double borderWidth = 0,
  Color borderColor = Colors.white,
  BoxFit fit = BoxFit.cover,
  Widget? placeholder,
  Widget? errorWidget,
  BoxShape shape = BoxShape.circle, // 👈 Circle ya Rectangle
  double borderRadius = 8, // 👈 Rect ke liye radius
}) {
  final isValidUrl = imageUrl != null && imageUrl.trim().isNotEmpty;

  final fullUrl = isValidUrl ? imageUrl : null;

  return Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(borderWidth),
    decoration: BoxDecoration(
      shape: shape,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: shape == BoxShape.rectangle
          ? BorderRadius.circular(borderRadius)
          : null,
    ),
    child: ClipRRect(
      borderRadius: shape == BoxShape.rectangle
          ? BorderRadius.circular(borderRadius)
          : BorderRadius.zero,
      child: isValidUrl
          ? CachedNetworkImage(
              height: size,
              width: size,
              imageUrl: fullUrl!,
              fit: fit,
              placeholder: (context, url) =>
                  placeholder ??
                  Center(
                    child: SizedBox(
                      width: 20, // 👈 yahan size set kijiye
                      height: 20, // 👈 yahan size set kijiye
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget: (context, url, error) =>
                  errorWidget ?? Center(child: commonAssetImage(icDummyUser)),
            )
          : (errorWidget ?? Center(child: commonAssetImage(icDummyUser))),
    ),
  );
}
commonBoxView({required Widget contentView,required String title}){
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: title, isPayment: false),

        const Divider(height: 1),

        // Content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child:contentView ,
        ),



      ],
    ),
  );
}