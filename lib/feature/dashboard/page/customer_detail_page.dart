import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(title: "Customer Detail", context: context),
      body: Center(child: Text("Customer Details")),
    );
  }
}
