import 'package:flutter/material.dart';
import 'package:neeknots/provider/login_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:neeknots/routes/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/string/string_utils.dart';
import 'provider/theme_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
List<SingleChildWidget> providers = [
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
  ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
];

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: appName,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      initialRoute: RouteName.splashScreen,
      onGenerateRoute: RouteGenerate.onGenerateRoute,
    );
  }
}
