import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/product_widget/common_product_widget.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../core/string/string_utils.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
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
                        selectedValue: "All",
                      ),
                      FilterItem(
                        label: "Status",
                        options: ["All", "Active", "Draft"],
                        selectedValue: "All",
                      ),
                    ];
                    showCommonFilterDialog(
                      context: context,
                      title: "Filter Orders",
                      filters: filters,
                      onReset: () {
                        // reset all filters
                        for (var filter in filters) {
                          filter.selectedValue = "All";
                        }
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
                      padding: const EdgeInsets.all(12),
                      items: provider.filteredProducts,
                      itemBuilder: (context, index, data) {
                        final parts = data.inventory.split("for");
                        final left = "${parts[0]}for";
                        final right = parts.length > 1 ? parts[1].trim() : "";

                        return commonProductListView(
                          image: data.icon,
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
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                top: 0,
                bottom: 10,
                right: 20,
              ),
              child: commonButton(
                text: "ADD PRODUCT",
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.addProductScreen);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
