import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';


commonProductListView({
  required String image,
  String? textInventory1,
  String? textInventory2,
  Color ? colorStatusColor,
  required String productName,
  Decoration? decoration,
  required String status,
}) {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder),
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 100,
            height: 80,

            clipBehavior: Clip.antiAlias,
            decoration: commonBoxDecoration(borderRadius: 10),
            child: Image.network(fit: BoxFit.cover, image),
          ),
          Expanded(
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(text: productName, fontWeight: FontWeight.w600),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$textInventory1 ", // first part
                        style: commonTextStyle(fontSize: 12, color: colorSale),
                      ),
                      TextSpan(
                        text: textInventory2, // second part
                        style: commonTextStyle(fontSize: 12, color: colorText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: decoration /*decoration: commonBoxDecoration(
              color: provider
                  .getStatusColor(data.status)
                  .withValues(alpha: 0.5),
            )*/,
            child: commonText(
              text: status,
              color: colorStatusColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 1,)
        ],
      ),
    ),
  );
}

