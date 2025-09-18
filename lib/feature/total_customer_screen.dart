import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/feature/dashboard/page/product_page.dart';

import 'dashboard/page/customer_page.dart';

class TotalCustomerScreen extends StatelessWidget {
  const TotalCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Total Customers",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(child: CustomersPage()),
    );
  }
}
