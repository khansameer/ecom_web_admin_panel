import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';

import 'common_customer_widget.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Customer Detail",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: ListView(
          children: [
            customerDetailsInfo(),
            customerOrderDetailsInfo(),
            customerProductInfo(),
          ],
        ),
      ),
    );
  }
}
