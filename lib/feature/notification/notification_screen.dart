import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return commonScaffold(
      appBar: commonAppBar(title: "Notification", context: context,centerTitle: true),
      body: commonAppBackground(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: commonListViewBuilder(
            items: provider.notifications,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index, data) {
              return Container(
                decoration: commonBoxDecoration(
                  borderColor: colorBorder
                ),
                margin: EdgeInsets.all(8),
                child: commonListTile(
                  textColor: themeProvider.isDark?Colors.white:colorLogo,
                  leadingIcon:  Container(
                    width: 45,
                      height: 45,
                      decoration: commonBoxDecoration(
                        shape: BoxShape.circle,
                        color: colorBorder

                      ),
                      child: Icon(Icons.notifications, color: themeProvider.isDark?Colors.white:colorLogo)),
                  subtitleView: commonText(text: data.description,fontSize: 12),
                  trailing: commonText(text: data.time,fontSize: 12,),
                  title: data.title,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
