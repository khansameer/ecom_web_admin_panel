import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';

import '../../../core/component/CommonDropdown.dart';

commonOrderView({
  required String image,
  String? date,
  String? orderID,
  Color ? colorTextStatus,

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(text: '#$orderID'??'', fontWeight: FontWeight.w600,fontSize: 14,color: colorLogo),
                commonText(text: productName, fontWeight: FontWeight.w600,fontSize: 12),

                commonText(
                    color: colorTextDesc,
                    text: date??'', fontWeight: FontWeight.w500,fontSize: 12),


              ],
            ),
          ),
          Container(
            decoration: decoration??commonBoxDecoration(
              borderRadius: 8,
              color: Colors.grey
                  .withValues(alpha: 0.5),
            ),
            padding: EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
            child: commonText(
              text: status,
              fontSize: 10,
              color: colorTextStatus,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 1,)

        ],
      ),
    ),
  );
}
