import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/hive/app_config_cache.dart';
import '../../../models/user_model.dart';
import '../../../provider/admin_dashboard_provider.dart';
import '../../../provider/order_provider.dart';
import '../order_widget/common_order_view.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrderPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),

        Expanded(child: CommonOrderView()),
      ],
    );
  }
}
