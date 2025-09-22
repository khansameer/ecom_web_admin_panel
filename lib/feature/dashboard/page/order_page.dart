import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
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

      postMdl.getOrderList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
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
                            options: ["All", "Paid", "Shipped", "Delivered"],
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
                            provider.filterByStatus("All"); // reset
                          },
                          onApply: () {
                            final selectedStatus = filters.first.selectedValue
                                .toLowerCase();
                            print('-=----$selectedStatus');
                            provider.filterByStatus(selectedStatus);
                          },
                        );
                      },
                    ),
                    onChanged: (value) => provider.setSearchQuery(value),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,

                    padding: const EdgeInsets.all(12),
                    itemCount: provider.filterOrderList?.length ?? 0,
                    // null to [] convert
                    itemBuilder: (context, index) {
                      var data = provider.filterOrderList?[index];
                      return commonOrderView(
                        errorImageView: Container(
                          margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                          child: commonErrorBoxView(text: data?.name ?? ''),
                        ),

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
                        colorTextStatus: provider.getPaymentStatusColor(
                          '${data?.financialStatus.toString().toCapitalize()}',
                        ),
                        decoration: commonBoxDecoration(
                          borderRadius: 4,

                          color: provider
                              .getPaymentStatusColor(
                                '${data?.financialStatus.toString().toCapitalize()}',
                              )
                              .withValues(alpha: 0.1),
                        ),

                        orderID:
                            '${data?.customer?.firstName}  ${data?.customer?.lastName}',
                        image: 'sdsasas',
                        //productName:'${ data?.customer?.firstName}  ${ data?.customer?.lastName}',
                        productName: 'Items:${data?.lineItems?.length}',
                        status:
                            '${data?.financialStatus.toString().toCapitalize()}',
                        price: double.parse(
                          data?.subtotalPrice?.toString() ?? '0',
                        ),
                        date: formatDateTime(
                          data?.createdAt ?? '',
                        ), //data.date.toLocal().toString(),
                      );
                    },
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
