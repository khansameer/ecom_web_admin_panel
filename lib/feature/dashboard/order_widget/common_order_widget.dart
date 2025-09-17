import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

commonOrderView({
  required String image,
  String? date,
  String? orderID,
  Color? colorTextStatus,

  required String productName,
  required double price,
  Decoration? decoration,
  required String status,
}) {
  return Consumer<ThemeProvider>(
    builder: (context, provider, child) {
      return Container(
        decoration: commonBoxDecoration(borderColor: colorBorder),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: commonInkWell(
          onTap: () {
            navigatorKey.currentState?.pushNamed(RouteName.orderDetailsScreen);
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              spacing: 10,
              children: [
                Container(
                  width: 100,

                  height: 100,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: commonBoxDecoration(borderRadius: 8),
                  child: commonNetworkImage(fit: BoxFit.cover, image),
                ),
                Expanded(
                  child: Column(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonText(
                        text: '#$orderID',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: provider.isDark ? Colors.white : colorLogo,
                      ),
                      commonText(
                        text: productName,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      commonText(
                        text: '\$$price',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.blueAccent,
                      ),

                      commonText(
                        color: provider.isDark ? Colors.white : colorTextDesc,
                        text: date ?? '',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration:
                      decoration ??
                      commonBoxDecoration(
                        borderRadius: 8,
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 5,
                    bottom: 5,
                  ),
                  child: commonText(
                    text: status,
                    fontSize: 10,
                    color: colorTextStatus,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 1),
              ],
            ),
          ),
        ),
      );
    },
  );
}
