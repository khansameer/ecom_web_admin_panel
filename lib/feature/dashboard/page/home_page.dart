import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:provider/provider.dart';

import '../../../provider/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return  Center(
      child: Column(
        children: [


         
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: themeProvider.isDark,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
        ],
      ),
    );
  }
}
