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
      padding: const EdgeInsets.all(8.0),
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
          )

        ],
      ),
    ),
  );
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
          return Container(
            color: Colors.white,
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
                      color: colorLogo,
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
                        color: colorText,
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
                        color: Colors.grey,
                        onPressed: () {
                          onReset();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: commonButton(
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
