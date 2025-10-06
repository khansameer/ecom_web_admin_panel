import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/component/component.dart';
import '../../../core/component/context_extension.dart';
import '../../../core/image/image_utils.dart';
import '../../../core/string/string_utils.dart';
import '../../../main.dart';
import '../../../provider/product_provider.dart';
import '../../../routes/app_routes.dart';
import 'common_product_widget.dart';

class ActiveDraftView extends StatefulWidget {
  const ActiveDraftView({super.key,this.status});
final String ?status;

  @override
  State<ActiveDraftView> createState() => _ActiveDraftViewState();
}

class _ActiveDraftViewState extends State<ActiveDraftView> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    init();

  }
  @override
  void dispose() {

    _scrollController.dispose();
    super.dispose();
  }

  Future<void> init() async {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      provider.resetProducts();
      provider.getProductListPagination(context: context,status:widget.status?? "active");
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
          provider.getProductListPagination(context: context,);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<ProductProvider>(
      builder: (context,provider,child) {
        return Column(
          children: [
      /*      Padding(
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

            *//*  suffixIcon: IconButton(
                icon: commonPrefixIcon(
                  image: icProductFilter,
                  width: 20,
                  height: 20,
                ),
                onPressed: () {
                  final filters = [
                    FilterItem(
                      label: "Status",
                      options: ["All", "Active", "Draft",],
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
                      provider.resetProducts();
                      provider.getProductListPagination(
                        context: navigatorKey.currentContext!,
                      );
                    },
                    onApply: () {
                      final selectedStatus = filters
                          .firstWhere((f) => f.label == "Status")
                          .selectedValue;

                      provider.setStatus(selectedStatus.toLowerCase());
                    },
                  );
                },
              ),*//*
              onChanged: (value) => provider.setSearchQuery(value),
            ),
          ),*/
            Expanded(
              child: provider.filteredProducts.isNotEmpty
                  ? ListView.builder(

                controller: _scrollController,
                padding: const EdgeInsets.only(left: 0,right: 0),
                itemCount: provider.hasMore && provider.searchQuery.isEmpty
                    ? provider.filteredProducts.length + 1
                    : provider.filteredProducts.length,
                itemBuilder: (context, index) {
                  if (index < provider.filteredProducts.length) {
                    final data = provider.filteredProducts[index];
                    final totalVariants = data.variants?.length ?? 0;
                    num? totalInventory =
                    data.variants?.isNotEmpty == true
                        ? data.variants?.fold(
                      0,
                          (sum, variant) =>
                      sum! +
                          (variant.inventoryQuantity ?? 0),
                    )
                        : 0;

                    return commonProductListView(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 0,
                      ),
                      image: data.image?.src ?? '',
                      onTap: () {
                        if (data.id != null) {
                          navigatorKey.currentState?.pushNamed(
                            RouteName.productDetailsScreen,
                            arguments: data.id.toString(),
                          );
                        }
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
                    // 🔹 Bottom loader for infinite scroll only
                    if (provider.searchQuery.isEmpty && provider.hasMore) {
                      // Trigger next page load
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        provider.getProductListPagination(context: context);
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
                      return const SizedBox.shrink();
                    }
                  }
                },
              )
                  :provider.isFetching?SizedBox.shrink(): commonErrorView(text: "Product Not Found."),
            ),
          ],
        );
      }
    );
  }
}
