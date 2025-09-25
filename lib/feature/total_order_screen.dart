import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/component/date_utils.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/order_widget/common_order_widget.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../core/color/color_utils.dart';
import '../core/component/animated_counter.dart';
import '../core/string/string_utils.dart';
import '../provider/theme_provider.dart';

class TotalOrderScreen extends StatefulWidget {
  const TotalOrderScreen({super.key});

  @override
  State<TotalOrderScreen> createState() => _TotalOrderScreenState();
}

class _TotalOrderScreenState extends State<TotalOrderScreen> {
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
      postMdl.orderCountStatusValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context, listen: true);

    return commonScaffold(
      appBar: commonAppBar(
        title: "Total Orders",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Dashboard Tabs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _commonDashboardView(
                              provider: provider,
                              onTap: () {
                                orderProvider.setSelectedTab("Paid");
                                // orderProvider.getOrderList(financialStatus: "paid");
                              },
                              value: orderProvider.totalPaid,
                              icon: icLogo,
                              title: "Paid",
                              color: orderProvider.selectedTab == "Paid"
                                  ? Colors.green
                                  : Colors.grey, // highlight active
                            ),
                          ),
                          Expanded(
                            child: _commonDashboardView(
                              provider: provider,
                              onTap: () {
                                orderProvider.setSelectedTab("Pending");

                                /*orderProvider.getOrderList(
                                  financialStatus: "pending",
                                );*/
                              },
                              value: orderProvider.totalPending,
                              icon: icLogo,
                              title: "Pending",
                              color: orderProvider.selectedTab == "Pending"
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),

                          Expanded(
                            child: _commonDashboardView(
                              provider: provider,
                              onTap: () {
                                orderProvider.setSelectedTab("Shipping");
                                /* orderProvider.getOrderList(
                                  financialStatus: "shipping",
                                );*/
                              },
                              value: orderProvider.totalShipping,
                              icon: icLogo,
                              title: "Shipping",
                              color: orderProvider.selectedTab == "Shipping"
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),

                          Expanded(
                            child: _commonDashboardView(
                              provider: provider,
                              onTap: () {
                                orderProvider.setSelectedTab("Refunded");
                                /* orderProvider.getOrderList(
                                  financialStatus: "refunded",
                                );*/
                              },
                              value: orderProvider.totalRefunded,
                              icon: icLogo,
                              title: "Refunded",
                              color: orderProvider.selectedTab == "Refunded"
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      // List Show According to Selected Tab
                      // List Show According to Selected Tab
                      if (orderProvider.selectedTab == "Paid")
                        _paidListWidget(orderProvider),
                      if (orderProvider.selectedTab == "Pending")
                        _paidListWidget(orderProvider),
                      if (orderProvider.selectedTab == "Cancel")
                        _paidListWidget(orderProvider),
                      if (orderProvider.selectedTab == "Shipping")
                        _paidListWidget(orderProvider),
                      if (orderProvider.selectedTab == "Refunded")
                        _paidListWidget(orderProvider),
                    ],
                  ),
                ),
                orderProvider.isFetching?showLoaderList():SizedBox.shrink()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _paidListWidget(OrdersProvider provider) {
    final orders = provider.selectedOrders; // ✅ selectedTab ki list aayegi

    return Expanded(
      child: orders.isEmpty?commonErrorView():ListView.builder(
        shrinkWrap: true,

        padding: const EdgeInsets.all(0),
        itemCount: orders.length,
        // null to [] convert
        itemBuilder: (context, index) {
          if (index < orders.length) {
            var data = orders[index];
            return commonOrderView(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              onTap: () {
                navigatorKey.currentState?.pushNamed(
                  RouteName.orderDetailsScreen,
                  arguments: data,
                );
              },
              colorTextStatus: provider.getPaymentStatusColor(
                data.financialStatus.toString().toCapitalize(),
              ),
              decoration: commonBoxDecoration(
                borderRadius: 4,

                color: provider
                    .getPaymentStatusColor(
                      data.financialStatus.toString().toCapitalize(),
                    )
                    .withValues(alpha: 0.1),
              ),

              orderID: data.customer?.firstName != null
                  ? '${data.customer?.firstName}  ${data.customer?.lastName}'
                  : noCustomer,
              image: data.name ?? '',
              //productName:'${ data?.customer?.firstName}  ${ data?.customer?.lastName}',
              productName: '${data.lineItems?.length} Items',
              status: data.financialStatus.toString().toCapitalize(),
              price: double.parse(data.subtotalPrice?.toString() ?? '0'),
              date: formatDateTime(
                data.createdAt ?? '',
              ), //data.date.toLocal().toString(),
            );
          } else {
            // 🔹 Loader sirf infinite scroll (search off) me
            if (provider.searchQuery.isEmpty && provider.hasMore) {
              // Trigger next page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                provider.getOrderList();
              });

              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CupertinoActivityIndicator(color: Colors.black),
                ),
              );
            } else {
              // 🔹 Agar search ya no more data
              return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }

  _commonDashboardView({
    Color? color,
    required ThemeProvider provider,
    required String icon,
    String? title,
    required int value,

    void Function()? onTap,
  }) {
    return commonInkWell(
      onTap: onTap,
      child: Container(

        margin: EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: commonBoxDecoration(
          color:
              color?.withValues(alpha: 0.05) ??
              Colors.green.withValues(alpha: 0.1),

          borderColor:
              color?.withValues(alpha: 0.2) ??
              Colors.green.withValues(alpha: 0.2),
          borderRadius: 10,
        ),
        child: Center(
          child: Column(
            spacing: 6,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(2), // border thickness
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color ?? Colors.transparent, // border color
                    width: 1, // border width
                  ),
                ),
                child: Center(
                  child: AnimatedCounter(
                    leftText: '',
                    rightText: '',
                    endValue: value,
                    duration: Duration(seconds: 2),
                    style: commonTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ),
              commonText(
                color: provider.isDark ? Colors.white : colorLogo,
                text: title?.toCapitalize() ?? "Paid".toCapitalize(),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
