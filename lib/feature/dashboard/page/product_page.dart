import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/CustomTabBar.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../product_widget/active_draft_view.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  Future<void> init() async {
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return commonRefreshIndicator(
      onRefresh: () async {
        init();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 0.0, left: 0, right: 0),
                  child: commonTextField(
                    hintText: "Search products by name...",
                    prefixIcon: commonPrefixIcon(
                      image: icProductSearch,
                      width: 16,
                      height: 16,
                    ),

                    /*  suffixIcon: IconButton(
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
                    ),*/
                    onChanged: (value) => provider.setSearchQuery(value),
                  ),
                );
              },
            ),
            SizedBox(height: 15),

            Expanded(
              child: CustomTabBar(
                isScrollable: false,
                tabAlignment: TabAlignment.fill,
                selectedColor: colorLogo,
                unselectedColor: Colors.grey[700]!,
                tabController: _tabController,
                tabTitles: ["Active", "Draft"],
                tabViews: [
                  ActiveDraftView(status: "active"),
                  ActiveDraftView(status: "draft"),
                ],
              ),
            ),
            /*Container(
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.grey[300], // background of unselected tabs
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                labelStyle: commonTextStyle(),
                unselectedLabelStyle: commonTextStyle(),
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                isScrollable: false,

                indicatorSize: TabBarIndicatorSize.tab,

                controller: _tabController,
                splashFactory: NoSplash.splashFactory,

                labelColor: Colors.white,

                unselectedLabelColor: Colors.grey[700],

                indicator: BoxDecoration(
                  color: colorLogo, // selected tab background color
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: const [
                  Tab(

                      text: "Active"),
                  Tab(text: "Draft"),
                ],
              ),
            ),

            SizedBox(height: 12,),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ActiveDraftView(status: "active"),
                  ActiveDraftView(status: "draft"),
                ],
              ),
            ),*/

            /*Padding(
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
                ),
                onChanged: (value) => provider.setSearchQuery(value),
              ),
            ),*/

            /* Expanded(
              child: provider.filteredProducts.isNotEmpty
                  ? ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
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
                        horizontal: 8,
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
            ),*/
          ],
        ),
      ),
    );
  }
}
