import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/product_widget/common_product_widget.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

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
                prefixIcon: commonPrefixIcon(image: icProductSearch,width: 16,height: 16),

                suffixIcon: IconButton(
                  icon: commonPrefixIcon(image: icProductFilter,width: 20,height: 20),
                  onPressed: () {
                    voidShowFilterDialog(context: context);
                  },
                ),
                onChanged: (value) => provider.setSearchQuery(value),
              ),
            ),

            Expanded(
              child: commonListViewBuilder(
                items: provider.filteredProducts,
                itemBuilder: (context, index, data) {
                  final parts = data.inventory.split("for");
                  final left = "${parts[0]}for";
                  final right = parts.length > 1 ? parts[1].trim() : "";

                  return commonProductListView(
                    image: data.icon,
                    textInventory1: left,
                    textInventory2: right,
                    productName: data.name,
                    status: data.status,
                    colorStatusColor: provider
                        .getStatusColor(data.status),
                    decoration: commonBoxDecoration(
                      borderRadius: 8,
                      borderWidth: 0.5,
                      color: provider
                          .getStatusColor(data.status)
                          .withValues(alpha: 0.01),
                      borderColor: provider
                          .getStatusColor(data.status)
                          .withValues(alpha: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
