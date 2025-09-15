import 'package:flutter/material.dart';
import 'package:neeknots/feature/dashboard/home_widget/common_home_widget.dart';

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
        SizedBox(height: 24,),
        SizedBox(height: 300, child: homeGraphView()),
        SizedBox(height: 24,),
        commonTopProductListView(),
        SizedBox(height: 24,),
        commonTopOrderListView(),


      ],
    );
  }
}
