import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
        appBar: commonAppBar(title: "Order Details", context: context,centerTitle: true),
        body: ListView());
  }
}
