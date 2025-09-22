import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../../models/customer_model.dart';
import 'common_customer_widget.dart';

class CustomerDetailPage extends StatefulWidget {
  const CustomerDetailPage({super.key,required this.customer});
  final Customer customer;

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {

  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  Future<void> init() async {
    try {
      final customerProvider = Provider.of<OrdersProvider>(context, listen: false);
      await customerProvider.getOrderBYID(orderID: widget.customer.lastOrderId);
    } catch (e) {
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    print('============${widget.customer.id}');
    return commonScaffold(
      appBar: commonAppBar(
        title: "Customer Detail",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: ListView(
          children: [
            customerDetailsInfo(customer: widget.customer),
          //  customerOrderDetailsInfo(customer: customer),
            customerProductInfo(customer: widget.customer),
          ],
        ),
      ),
    );
  }
}
