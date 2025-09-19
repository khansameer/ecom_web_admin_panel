import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/product_widget/common_product_widget.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/string/string_utils.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 18.0,
                    left: 18,
                    right: 18,
                  ),
                  child: commonTextField(
                    hintText: "Search products by name...",
                    prefixIcon: commonPrefixIcon(
                      image: icProductSearch,
                      width: 16,
                      height: 16,
                    ),

                    suffixIcon: IconButton(
                      icon: commonPrefixIcon(
                        image: icProductFilter,
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () {
                        final filters = [
                          FilterItem(
                            label: "Category",
                            options: ["All", "Dresses", "Tops", "Shirts"],
                            selectedValue:
                                provider.selectedCategory, // 👈 provider से लो
                          ),
                          FilterItem(
                            label: "Status",
                            options: ["All", "Active", "Draft"],
                            selectedValue:
                                provider.selectedStatus, // 👈 provider से लो
                          ),
                        ];
                        showCommonFilterDialog(
                          context: context,
                          title: "Filter Orders",
                          filters: filters,
                          onReset: () {
                            provider.setCategory("All");
                            provider.setStatus("All");
                          },
                          onApply: () {
                            final selectedStatus = filters
                                .firstWhere((f) => f.label == "Category")
                                .selectedValue;

                            final selectedDate = filters
                                .firstWhere((f) => f.label == "Status")
                                .selectedValue;

                            provider.setCategory(selectedStatus);
                            provider.setStatus(selectedDate);
                          },
                        );
                      },
                    ),
                    onChanged: (value) => provider.setSearchQuery(value),
                  ),
                ),

                Expanded(
                  child: provider.filteredProducts.isNotEmpty
                      ? commonListViewBuilder(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 12,
                            bottom: 12,
                          ),
                          items: provider.filteredProducts,
                          itemBuilder: (context, index, data) {
                            final parts = data.inventory.split("for");
                            final left = "${parts[0]}for";
                            final right = parts.length > 1
                                ? parts[1].trim()
                                : "";

                            return commonProductListView(
                              image: data.icon,
                              onTap: () {
                                navigatorKey.currentState?.pushNamed(
                                  RouteName.productDetailsScreen,
                                  arguments: data,
                                );
                              },
                              price: '$rupeeIcon${data.price}',
                              textInventory1: left,
                              textInventory2: right,
                              productName: data.name,
                              status: data.status,
                              colorStatusColor: provider.getStatusColor(
                                data.status,
                              ),
                              decoration: commonBoxDecoration(
                                borderRadius: 8,
                                borderWidth: 0.5,
                                /* color: provider
                              .getStatusColor(data.status)
                              .withValues(alpha: 0.01),
                          borderColor: provider
                              .getStatusColor(data.status)
                              .withValues(alpha: 1),*/
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.white12,
                          child: Center(
                            child: commonText(text: "Product not found..."),
                          ),
                        ),
                ),
              ],
            ),
            /*  Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    commonInkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.addProductScreen,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: commonBoxDecoration(color: colorLogo),
                        child: Center(
                          child: commonText(
                            color: Colors.white,
                            text: "Add Product".toUpperCase(),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
          ],
        );
      },
    );
  }
}
