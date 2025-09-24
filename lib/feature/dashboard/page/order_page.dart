import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/string/string_utils.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/component/date_utils.dart';
import '../../../core/image/image_utils.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../order_widget/common_order_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final postMdl = Provider.of<OrdersProvider>(
        navigatorKey.currentContext!,
        listen: false,
      );

      postMdl.resetData();
      postMdl.getOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, provider, child) {
        return commonRefreshIndicator(
          onRefresh: () async {
            init();
          },
          child: Stack(
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
                              provider.getOrderList(status: null);
                              // provider.filterByStatus("All"); // reset
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
                    child:  provider.isFetching
                        ?SizedBox.shrink()
                        :provider.filterOrderList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,

                            padding: const EdgeInsets.all(12),
                            itemCount: provider.filterOrderList.length,
                            // null to [] convert
                            itemBuilder: (context, index) {
                              if (index < provider.filterOrderList.length) {
                                var data = provider.filterOrderList[index];
                                return commonOrderView(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  onTap: () {
                                    navigatorKey.currentState?.pushNamed(
                                      RouteName.orderDetailsScreen,
                                      arguments: data,
                                    );
                                  },
                                  colorTextStatus: provider
                                      .getPaymentStatusColor(
                                        data.financialStatus
                                            .toString()
                                            .toCapitalize(),
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
                                  //productName:'${ data?.customer?.firstName}  ${ data?.customer?.lastName}',
                                  productName:
                                      '${data.lineItems?.length} Items',
                                  status: data.financialStatus
                                      .toString()
                                      .toCapitalize(),
                                  price: double.parse(
                                    data.subtotalPrice?.toString() ?? '0',
                                  ),
                                  date: formatDateTime(
                                    data.createdAt ?? '',
                                  ), //data.date.toLocal().toString(),
                                );
                              } else {
                                // 🔹 Loader sirf infinite scroll (search off) me
                                if (provider.searchQuery.isEmpty &&
                                    provider.hasMore) {
                                  // Trigger next page
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    provider.getOrderList();
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
                        : commonErrorView(text: "Order not found"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
