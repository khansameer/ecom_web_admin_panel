import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/feature/dashboard/home_widget/common_home_widget.dart';
import 'package:neeknots/provider/customer_provider.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../provider/product_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
      //final customerProvider = Provider.of<CustomerProvider>(context, listen: false);

      await Future.wait([
        productProvider.getProductList(),
        orderProvider.getOrderList(),
        //  customerProvider.getCustomerList(),
      ]);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer3<OrdersProvider,ProductProvider,CustomerProvider>(
      builder: (context,orderProvider,productProvider,customerProvider,child) {
        return Stack(
          children: [
            ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(12),
              children: [
                homeTopView(totalOrder: orderProvider.filterOrderList?.length??0,totalProduct: productProvider.filteredProducts?.length??0),
                SizedBox(height: 24),
                SizedBox(height: 300, child: homeGraphView()),
                SizedBox(height: 24),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    return commonTopProductListView(
                      onTap: () {
                        provider.setIndex(0);
                      },
                    );
                  },
                ),

                SizedBox(height: 24),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    return commonTopOrderListView(
                      onTap: () {
                        provider.setIndex(1);
                      },
                    );
                  },
                ),
              ],
            ),
            orderProvider.isFetching || productProvider.isFetching?showLoaderList():SizedBox.shrink()
          ],
        );
      }
    );
  }
}
