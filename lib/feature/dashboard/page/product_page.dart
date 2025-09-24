import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/product_widget/common_product_widget.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../core/string/string_utils.dart';
import '../../../main.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      provider.resetProducts();
      provider.getProductList(context: context);
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
          provider.getProductList(context: context);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Column(
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
                          label: "Status",
                          options: ["All", "Active", "Draft","Archived"],
                          selectedValue: provider.selectedStatus
                              .toString()
                              .toCapitalize(), // 👈 provider से लो
                        ),
                      ];
                      showCommonFilterDialog(
                        context: context,
                        title: "Filter Product",
                        filters: filters,
                        onReset: () {
                          provider.setCategory("All");
                          provider.setStatus("All");
                        },
                        onApply: () {
                          final selectedStatus = filters
                              .firstWhere((f) => f.label == "Status")
                              .selectedValue;

                          provider.setStatus(selectedStatus.toLowerCase());
                        },
                      );
                    },
                  ),
                  onChanged: (value) => provider.setSearchQuery(value),
                ),
              ),

              Expanded(
                child: provider.filteredProducts.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount:
                            provider.hasMore && provider.searchQuery.isEmpty
                            ? provider.filteredProducts.length + 1
                            : provider.filteredProducts.length,
                        itemBuilder: (context, index) {
                          if (index < provider.filteredProducts.length) {
                            var data = provider.filteredProducts[index];
                            final totalVariants = data.variants?.length ?? 0;
                            num? totalInventory =
                                data.variants?.isNotEmpty == true
                                ? data.variants?.fold(
                                    0,
                                    (sum, variant) =>
                                        sum! + (variant.inventoryQuantity ?? 0),
                                  )
                                : 0;

                            return commonProductListView(
                              image: data.image?.src ?? '',
                              onTap: () {
                                navigatorKey.currentState?.pushNamed(
                                  RouteName.productDetailsScreen,
                                  arguments: data,
                                );
                              },
                              price: data.variants?.isNotEmpty == true
                                  ? '$rupeeIcon${data.variants?.first.price}'
                                  : '$rupeeIcon 0',
                              textInventory1: "$totalInventory in stock",
                              textInventory2: ' for $totalVariants variants',
                              productName: data.title ?? '',
                              status: data.status.toString().toCapitalize(),
                              colorStatusColor: data.status?.isNotEmpty == true
                                  ? provider.getStatusColor(
                                      data.status.toString().toCapitalize(),
                                    )
                                  : Colors.grey,
                              decoration: commonBoxDecoration(
                                borderRadius: 8,
                                borderWidth: 0.5,
                              ),
                            );
                          } else {
                            // 🔹 Loader sirf infinite scroll (search off) me
                            if (provider.searchQuery.isEmpty &&
                                provider.hasMore) {
                              // Trigger next page
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                provider.getProductList(context: context);
                              });

                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            } else {
                              // 🔹 Agar search ya no more data
                              return const SizedBox.shrink();
                            }
                          }
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
        );
      },
    );
  }
}
