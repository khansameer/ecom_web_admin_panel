import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';

homeTopView() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: _commonDashboardView(
              color: colorSale,

              icon: icTotalSale,
              title: "Total Sales",
              subtitle: "+50% Incomes",
              value: "\$278m",
            ),
          ),
          Expanded(
            child: _commonDashboardView(
              color: colorProduct,

              icon: icProductMenu,
              title: "Total Product",
              subtitle: "+25% New Product",
              value: "548",
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _commonDashboardView(
              color: Colors.blue.shade400,
              icon: icOrderMenu,
              title: "Total  Order",
              subtitle: "+25 New Order",
              value: "845",
            ),
          ),
          Expanded(
            child: _commonDashboardView(
              color: colorUser,

              icon: icTotalUser,
              title: "Total Customer",
              subtitle: "+48% New User",
              value: "4215",
            ),
          ),
        ],
      ),
    ],
  );
}

_commonDashboardView({
  Color? color,

  required String icon,
  required String title,
  subtitle,
  required String value,
}) {
  return Container(
    width: 140,
    margin: EdgeInsets.all(5),
    padding: const EdgeInsets.all(16),
    decoration: commonBoxDecoration(
      color: color?.withValues(alpha: 0.05) ?? colorLogo.withValues(alpha: 0.1),

      borderColor:
          color?.withValues(alpha: 0.3) ?? colorLogo.withValues(alpha: 0.3),
      borderRadius: 10,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(2), // border thickness
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color ?? Colors.transparent, // border color
              width: 1.5, // border width
            ),
          ),
          child: CircleAvatar(
            radius: 28,

            backgroundColor: Colors.white,
            child: Center(
              child: commonAssetImage(
                icon,
                width: 24,
                height: 24,
                color: color ?? Colors.transparent,
              ),
            ) /*Icon(
              icon,
              color: startColor ?? Colors.transparent,
              size: 28,
            )*/,
          ),
        ),
        const SizedBox(height: 12),
        commonText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorText,
        ),
        commonText(text: subtitle, fontSize: 12, color: colorTextDesc),
        const SizedBox(height: 8),
        commonText(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorText,
        ),
      ],
    ),
  );
}
