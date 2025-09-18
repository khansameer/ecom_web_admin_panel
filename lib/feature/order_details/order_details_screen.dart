import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/order_provider.dart';

import 'order_common_widget.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key,required this.order});

final   Order order;
  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Order Details",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(child: ListView(children: [
        orderInfo(order: order),
        customerInfo(),
        productInfo(),

        paymentSummery(),
      ])),
    );
  }
}
