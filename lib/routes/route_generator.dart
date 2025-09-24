import 'package:flutter/material.dart';
import 'package:neeknots/feature/sales_details_screen.dart';
import 'package:neeknots/feature/change_password/change_password_screen.dart';
import 'package:neeknots/feature/customer_details/customer_detail_page.dart';
import 'package:neeknots/feature/edit_profile/edit_profile_screen.dart';
import 'package:neeknots/feature/notification/notification_screen.dart';
import 'package:neeknots/feature/order_details/order_details_screen.dart';
import 'package:neeknots/feature/product_details/add_product_screen.dart';
import 'package:neeknots/feature/product_details/product_details_screen.dart';
import 'package:neeknots/feature/total_order_screen.dart';

import 'package:neeknots/models/product_model.dart';
import 'package:neeknots/models/customer_model.dart';

import '../feature/dashboard/dashboard_screen.dart';
import '../feature/login/login_screen.dart';
import '../feature/splash/splash_screen.dart';
import '../feature/total_customer_screen.dart';
import '../feature/total_product_screen.dart';
import '../models/order_model.dart' hide Customer;
import 'app_routes.dart';

class RouteGenerate {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.dashboardScreen:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RouteName.customerDetail:
        final args = settings.arguments as Customer;
        return MaterialPageRoute(
          builder: (_) => CustomerDetailPage(customer: args),
        );

      case RouteName.notificationScreen:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      case RouteName.changePasswordScreen:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());

      case RouteName.editProfileScreen:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case RouteName.productDetailsScreen:
        final args = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(productId: args),
        );

      case RouteName.orderDetailsScreen:
        final args = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(order: args),
        );
      case RouteName.addProductScreen:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      case RouteName.totalOrderScreen:
        return MaterialPageRoute(builder: (_) => const TotalOrderScreen());
      case RouteName.totalCustomerScreen:
        return MaterialPageRoute(builder: (_) => const TotalCustomerScreen());
      case RouteName.totalProductScreen:
        return MaterialPageRoute(builder: (_) => const TotalProductScreen());
      case RouteName.salesDetailsScreen:
        final args = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => SalesDetailsScreen(todaySales: args),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
