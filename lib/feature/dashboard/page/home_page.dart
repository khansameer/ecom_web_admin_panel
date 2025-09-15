import 'package:flutter/material.dart';
import 'package:neeknots/feature/dashboard/home_widget/common_home_widget.dart';
import 'package:provider/provider.dart';

import '../../../provider/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      shrinkWrap: true,
        padding: EdgeInsets.all(12),
        children: [

      homeTopView(),

    ]);
  }
}
