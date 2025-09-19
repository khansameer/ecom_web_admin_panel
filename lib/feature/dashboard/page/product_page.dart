import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/product_widget/common_product_widget.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/string/string_utils.dart';
import '../../../main.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final postMdl = Provider.of<ProductProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );

      postMdl.getProductList();
    });
  }

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
                          /*FilterItem(
                            label: "Category",
                            options: ["All", "Dresses", "Tops", "Shirts"],
                            selectedValue:
                                provider.selectedCategory, // 👈 provider से लो
                          ),*/
                          FilterItem(
                            label: "Status",
                            options: ["All", "Active", "Draft"],
                            selectedValue:
                                provider.selectedStatus.toString().toCapitalize(), // 👈 provider से लो
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
                  child: provider.filteredProducts?.isNotEmpty == true
                      ? ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 12,
                            bottom: 12,
                          ),
                          itemCount:
                              provider.filteredProducts?.length ?? 0,
                          itemBuilder: (context, index) {
                            var data = provider.filteredProducts?[index];
                            final totalVariants = data?.variants?.length;
                            //  final left = "${parts[0]}for";
                            num? totalInventory =
                                data?.variants?.isNotEmpty == true
                                ? data?.variants?.fold(
                                    0,
                                    (sum, variant) =>
                                        sum! + (variant.inventoryQuantity ?? 0),
                                  )
                                : 0;

                            return commonProductListView(
                              image: data?.image?.src ?? '',
                              onTap: () {
                                /*  navigatorKey.currentState?.pushNamed(
                                  RouteName.productDetailsScreen,
                                  arguments: data,
                                );*/
                              },
                              price: data?.variants?.isNotEmpty == true?'$rupeeIcon${data?.variants?.first.price}':'$rupeeIcon 0',
                              textInventory1: "$totalInventory in stock",
                              textInventory2: ' for $totalVariants variants',
                              productName: data?.title ?? '',
                              status:
                                  data?.status.toString().toCapitalize() ?? '',
                              colorStatusColor: data?.status?.isNotEmpty == true
                                  ? provider.getStatusColor(
                                      data!.status.toString().toCapitalize(),
                                    )
                                  : Colors.grey,
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
            provider.isFetching ? showLoaderList() : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
