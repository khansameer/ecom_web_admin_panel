import 'package:flutter/material.dart';
import 'package:neeknots/feature/dashboard/home_widget/common_home_widget.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(12),
      children: [
        homeTopView(),
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
    );
  }
}
