import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/CommonDropdown.dart' show CommonDropdown;
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

commonProductListView({required String image,String ?textInventory1,String ?textInventory2,required String productName,Decoration? decoration,required String status}){
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(
                  text: productName,
                  fontWeight: FontWeight.w600,
                ),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$textInventory1 ", // first part
                        style: commonTextStyle(
                          fontSize: 12,
                          color: colorSale,
                        ),
                      ),
                      TextSpan(
                        text: textInventory2, // second part
                        style: commonTextStyle(
                          fontSize: 12,
                          color: colorText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            decoration: decoration/*decoration: commonBoxDecoration(
              color: provider
                  .getStatusColor(data.status)
                  .withValues(alpha: 0.5),
            )*/,
            child: commonText(
              text: status,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

voidShowFilterDialog({required BuildContext context}){
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) {
      return Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    commonText(
                      text: "Filter Products",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorLogo,
                    ),

                    commonInkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: commonBoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
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

                CommonDropdown(
                  label: "Category",
                  initialValue: "All",
                  items: ["All", "Dresses", "Tops", "Shirts"],
                  onChanged: (value) {
                    if (value != null) {
                      provider.setCategory(value);
                    }
                  },
                ),
                const SizedBox(height: 25),

                CommonDropdown(
                  label: "Status",
                  initialValue: "All",
                  items: ["All", "Active", "Draft"],
                  onChanged: (value) {
                    if (value != null) {
                      provider.setStatus(value);
                    }
                  },
                ),
                const SizedBox(height: 25),

                commonButton(
                  text: "Apply",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 50),

                // Apply button
              ],
            ),
          );
        },
      );
    },
  );
}