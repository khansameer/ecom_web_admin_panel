import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/customer_provider.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:neeknots/provider/profile_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../core/firebase/auth_service.dart';
import '../../core/hive/app_config_cache.dart';
import '../../provider/product_provider.dart';

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
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? storedEmailOrMobile = await AppConfigCache.getName();
      String? id = await AppConfigCache.getID();

      String? fcmToken = await FirebaseMessaging.instance.getToken();
      final provider = Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false);
      provider.setName(storedEmailOrMobile);
      final authService = AuthService();
      await authService.updateFcm(userID: id ?? '', fcmToken: fcmToken ?? '');
    });
  }

  String getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0]; // Only first name
    } else {
      return parts[0][0] + parts[1][0]; // First + Last initials
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, ThemeProvider>(
      builder: (context, provider, themeProvider, child) {
        return Stack(
          children: [
            commonScaffold(
              backgroundColor: themeProvider.isDark
                  ? colorDarkBgColor
                  : Colors.white,
              appBar: commonAppBar(
                backgroundColor: themeProvider.isDark
                    ? colorDarkBgColor
                    : colorLogo,

                centerTitle: true,
                actions: [

                  IconButton(

                      onPressed: (){

                        navigatorKey.currentState?.pushNamed(RouteName.contactUsScreen);
                      }, icon: commonAssetImage(icContact,color: Colors.white,width: 30,height: 30))
                  /*notificationWidget(), SizedBox(width: 16)*/],
                title: provider.appbarTitle ?? "Home",
                context: context,
                leading: Container(
                  padding: EdgeInsets.only(left: 16),

                  child: commonInkWell(
                    onTap: () => provider.setIndex(4),
                    child: Center(
                      child: /*commonCircleAssetImage(

                        borderColor: Colors.white,
                        borderWidth: 2,
                        icDummyUser,
                        size: 40,
                      )*/ SizedBox(
                        width: 45,
                        height: 45,
                        child: CircleAvatar(
                          radius: 100,
                          child: commonCircleNetworkImage(

                            '',

                            color:themeProvider.isDark?colorDarkBgColor: Colors.black,

                            errorWidget: commonErrorBoxView(
                              colorText: themeProvider.isDark?Colors.white: Colors.white,
                              text: (provider.name?.isNotEmpty ?? false
                                  ? getInitials(provider.name.toString().toUpperCase())
                                  : ''),

                            ),
                          ),
                        ),
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
                      context.read<OrdersProvider>().resetData();
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
                      context.read<OrdersProvider>().resetData();
                      context.read<CustomerProvider>().reset();
                      context.read<ProfileProvider>().resetState();
                      break;
                    case 3: // Customer
                      context.read<ProductProvider>().reset();
                      context.read<OrdersProvider>().resetData();
                      context.read<ProfileProvider>().resetState();
                      break;
                    case 4: // Account
                      context.read<ProductProvider>().reset();
                      context.read<OrdersProvider>().resetData();
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
            ),

            context.watch<ProductProvider>().isFetching ||
                    context.watch<OrdersProvider>().isFetching ||
                    context.watch<CustomerProvider>().isFetching
                ? Container(
                    color: Colors.black.withValues(alpha: 0.01),
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: showLoaderList11(),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
