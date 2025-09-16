import 'package:flutter/material.dart';
import 'package:neeknots/feature/dashboard/page/customer_detail_page.dart';

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
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
