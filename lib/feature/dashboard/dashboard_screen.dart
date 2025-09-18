import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/common_bottom_navbar.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/page/customer_page.dart';
import 'package:neeknots/feature/dashboard/page/home_page.dart';
import 'package:neeknots/feature/dashboard/page/order_page.dart';
import 'package:neeknots/feature/dashboard/page/product_page.dart';
import 'package:neeknots/feature/dashboard/page/setting_page.dart';
import 'package:neeknots/provider/customer_provider.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:neeknots/provider/profile_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider.dart';
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
    return Consumer2<DashboardProvider, ThemeProvider>(
      builder: (context, provider, themeProvider, child) {
        return commonScaffold(
          backgroundColor: themeProvider.isDark
              ? colorDarkBgColor
              : Colors.white,
          appBar: commonAppBar(
            backgroundColor: themeProvider.isDark
                ? colorDarkBgColor
                : colorLogo,

            centerTitle: true,
            actions: [notificationWidget(), SizedBox(width: 16)],
            title: provider.appbarTitle ?? "Home",
            context: context,
            leading: Container(
              padding: EdgeInsets.only(left: 16),

              child: commonInkWell(
                onTap: () => provider.setIndex(4),
                child: Center(
                  child: commonCircleAssetImage(
                    borderColor: Colors.white,
                    borderWidth: 2,
                    icDummyUser,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),

          body: getPage(provider.currentIndex),

          // 👈 only current page
          bottomNavigationBar: CommonBottomNavBar(
            currentIndex: provider.currentIndex,
            onTap: (index) {
              provider.setIndex(index);

              switch (index) {
                case 0: // Product
                  context.read<OrdersProvider>().resetFilters();
                  context.read<CustomerProvider>().reset();
                  context.read<ProfileProvider>().resetState();
                  break;
                case 1: // Order
                  context.read<ProductProvider>().reset();
                  context.read<CustomerProvider>().reset();
                  context.read<ProfileProvider>().resetState();
                  break;
                case 2: // Home
                  context.read<ProductProvider>().reset();
                  context.read<OrdersProvider>().resetFilters();
                  context.read<CustomerProvider>().reset();
                  context.read<ProfileProvider>().resetState();
                  break;
                case 3: // Customer
                  context.read<ProductProvider>().reset();
                  context.read<OrdersProvider>().resetFilters();
                  context.read<ProfileProvider>().resetState();
                  break;
                case 4: // Account
                  context.read<ProductProvider>().reset();
                  context.read<OrdersProvider>().resetFilters();
                  context.read<CustomerProvider>().reset();
                  break;
              }

              if (index == 0) provider.setAppBarTitle("Products");
              if (index == 1) provider.setAppBarTitle("Orders");
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
