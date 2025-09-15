import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/common_bottom_navbar.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/page/home_page.dart';
import 'package:neeknots/feature/dashboard/page/order_page.dart';
import 'package:neeknots/feature/dashboard/page/product_page.dart';
import 'package:neeknots/feature/dashboard/page/customer_page.dart';
import 'package:neeknots/feature/dashboard/page/setting_page.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'dashboard_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return ProductPage();
      case 1:
        return OrderPage();
      case 2:
        return HomePage();
      case 3:
        return CustomersPage();
      case 4:
        return SettingPage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider,ThemeProvider>(
      builder: (context, provider, themeProvider, child) {
        return commonScaffold(
          backgroundColor:themeProvider.isDark?colorDarkBgColor:Colors.white ,
          appBar: commonAppBar(
            backgroundColor: themeProvider.isDark?colorDarkBgColor:colorLogo,
            
            centerTitle: true,
            actions: [notificationWidget(), SizedBox(width: 10)],
            title: provider.appbarTitle ?? "Home",
            context: context,
            leading:Container(
              padding: EdgeInsets.only(left: 10),

                child: Center(child: commonCircleAssetImage(
                    borderColor: Colors.white,
                    borderWidth: 2,
                    icDummyUser,size: 40))),
          ),

          body: getPage(provider.currentIndex),

          // 👈 only current page
          bottomNavigationBar: CommonBottomNavBar(
            currentIndex: provider.currentIndex,
            onTap: (index) {
              provider.setIndex(index);
              if (index == 0) provider.setAppBarTitle("Product");
              if (index == 1) provider.setAppBarTitle("Order");
              if (index == 2) provider.setAppBarTitle("Home");
              if (index == 3) provider.setAppBarTitle("Customers");
              if (index == 4) provider.setAppBarTitle("Account");
            },
            items: BottomNavItems.items,
          ),
        );
      },
    );
  }
}
