import 'package:flutter/material.dart';
import 'package:neeknots/feature/change_password/change_password_screen.dart';
import 'package:neeknots/feature/dashboard/page/customer_detail_page.dart';
import 'package:neeknots/feature/edit_profile/edit_profile_screen.dart';
import 'package:neeknots/feature/notification/notification_screen.dart';
import 'package:neeknots/feature/product_details/add_product_screen.dart';
import 'package:neeknots/feature/product_details/product_details_screen.dart';

import '../feature/dashboard/dashboard_screen.dart';
import '../feature/login/login_screen.dart';
import '../feature/splash/splash_screen.dart';
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
        return MaterialPageRoute(builder: (_) => const CustomerDetailPage());

      case RouteName.notificationScreen:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

      case RouteName.changePasswordScreen:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());

      case RouteName.editProfileScreen:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case RouteName.productDetailsScreen:
        return MaterialPageRoute(builder: (_) => const ProductDetailsScreen());
      case RouteName.addProductScreen:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
