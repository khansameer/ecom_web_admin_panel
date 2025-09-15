import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/CommonDropdown.dart'
    show CommonDropdown;
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

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
        ],
      ),
    ),
  );
}

void voidShowFilterDialog({required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Consumer<ProductProvider>(
        builder: (context, provider, _) {
          // Temporary variables initialized from provider or default "All"
          String tempCategory = provider.selectedCategory;
          String tempStatus = provider.selectedStatus;

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
                          text: "Filter Products",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorLogo,
                        ),
                        commonInkWell(
                          onTap: () {
                            setState(() {
                              provider.setCategory("All");
                              provider.setStatus("All");
                              tempCategory = "All";
                              tempStatus = "All";
                              Navigator.pop(context);
                            });
                          },
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

                    // Category Dropdown
                    commonText(
                      text: "Category",
                      color: colorText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    SizedBox(height: 5),
                    CommonDropdown(
                      initialValue: tempCategory,
                      items: ["All", "Dresses", "Tops", "Shirts"],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            tempCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // Status Dropdown
                    commonText(
                      text: "Status",
                      color: colorText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    SizedBox(height: 5),
                    CommonDropdown(
                      initialValue: tempStatus,
                      items: ["All", "Active", "Draft"],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            tempStatus = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 25),

                    // Row with Reset and Apply buttons
                    Row(
                      children: [
                        Expanded(
                          child: commonButton(
                            text: "Reset",
                            color: Colors.grey,
                            // Optional: gray color for Reset
                            onPressed: () {
                              setState(() {
                                provider.setCategory("All");
                                provider.setStatus("All");
                                tempCategory = "All";
                                tempStatus = "All";
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: commonButton(
                            text: "Apply",
                            onPressed: () {
                              // Apply filters to provider
                              provider.setCategory(tempCategory);
                              provider.setStatus(tempStatus);
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
