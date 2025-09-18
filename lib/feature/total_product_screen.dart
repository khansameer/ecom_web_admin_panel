import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/feature/dashboard/page/product_page.dart';

class TotalProductScreen extends StatelessWidget {
  const TotalProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return commonScaffold(
      appBar: commonAppBar(
        title: "Total Products",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(child: ProductPage()),
    );
  }
}
