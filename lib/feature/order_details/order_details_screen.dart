import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';

import '../../models/order_model.dart';
import 'order_common_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Order Details",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: ListView(
          children: [
            orderInfo(order: widget.order),
            customerInfo(order: widget.order),
            productInfo(order: widget.order),
            paymentSummery(order: widget.order),
          ],
        ),
      ),
    );
  }
}
