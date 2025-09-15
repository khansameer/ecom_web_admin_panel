import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/image/image_utils.dart';
import '../order_widget/common_order_widget.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
              child: commonTextField(
                hintText: "Search by Order ID, Name, or Date",
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
                        options: ["All", "Pending", "Shipped", "Delivered"],
                        selectedValue: "All",
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
                        final selectedStatus = filters.first.selectedValue;
                        provider.filterByStatus(selectedStatus);
                      },
                    );
                  },
                ),
                onChanged: (value) => provider.searchOrders(value),
              ),
            ),
            Expanded(
              child: commonListViewBuilder(
                padding: const EdgeInsets.all(12),
                items: provider.orders,

                itemBuilder: (context, index, data) {
                  return commonOrderView(
                    colorTextStatus: provider.getStatusColor(data.status),
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

                    orderID: data.orderId,
                    image: data.products.first.icon,
                    productName: data.customerName,
                    status: data.status,
                    date: data.date.toLocal().toString().split(' ')[0],
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
