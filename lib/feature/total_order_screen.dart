import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';

import 'dashboard/page/order_page.dart';

class TotalOrderScreen extends StatelessWidget {
  const TotalOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
        appBar: commonAppBar(
          title: "Total Orders",
          context: context,
          centerTitle: true,
        ),
        body: commonAppBackground(child: OrderPage()));
  }
}
