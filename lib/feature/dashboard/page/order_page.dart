import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../core/component/date_utils.dart';
import '../../../core/image/image_utils.dart';
import '../../../core/string/string_utils.dart';
import '../../../main.dart';
import '../order_widget/common_order_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    Future.microtask(
      () => Provider.of<OrdersProvider>(context, listen: false).getOrderList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, provider, _) {
        return commonRefreshIndicator(
          onRefresh: () async {
            init();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 12, right: 12),
                child: commonTextField(
                  hintText: "Search by Order ID",
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
                          options: [
                            "All",
                            "Authorized",
                            "Paid",
                            "Partially Paid",
                            "Refunded",
                            "Voided",
                          ],
                          selectedValue: provider.selectedStatus
                              .toString()
                              .toCapitalize(), // 👈 provider से लो
                        ),
                      ];

                      showCommonFilterDialog(
                        context: context,
                        title: "Filter Orders",
                        filters: filters,
                        onReset: () {
                          provider.getOrderList(
                            loadMore: false,
                            financialStatus: null,
                          );
                        },
                        onApply: () {
                          final selectedStatus = filters.first.selectedValue
                              .toLowerCase();

                          provider.filterByStatus(selectedStatus);
                        },
                      );
                    },
                  ),
                  onChanged: (value) => provider.setSearchQuery(value),
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    // Load more only when not searching
                    if (provider.searchQuery.isEmpty &&
                        !provider.isFetching &&
                        provider.hasMore &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      provider.getOrderList(loadMore: true);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
                    itemCount:
                        provider.filterOrderList.length +
                        (provider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < provider.filterOrderList.length) {
                        final data = provider.filterOrderList[index];
                        return commonOrderView(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          onTap: () {
                            navigatorKey.currentState?.pushNamed(
                              RouteName.orderDetailsScreen,
                              arguments: data.id,
                            );
                          },
                          colorTextStatus: provider.getPaymentStatusColor(
                            data.financialStatus.toString().toCapitalize(),
                          ),
                          decoration: commonBoxDecoration(
                            borderRadius: 4,

                            color: provider
                                .getPaymentStatusColor(
                                  data.financialStatus
                                      .toString()
                                      .toCapitalize(),
                                )
                                .withValues(alpha: 0.1),
                          ),
                          orderID: data.customer?.firstName != null
                              ? '${data.customer?.firstName}  ${data.customer?.lastName}'
                              : noCustomer,
                          image: data.name ?? '',
                          productName: '${data.lineItems?.length} Items',
                          status:
                              '${data.financialStatus.toString().toCapitalize()} | ${data.fulfillmentStatus?.toCapitalize() ?? 'Unfulfilled'}',
                          price: double.parse(
                            data.subtotalPrice?.toString() ?? '0',
                          ),
                          date: formatDateTime(data.createdAt ?? ''),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }
                    },
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
