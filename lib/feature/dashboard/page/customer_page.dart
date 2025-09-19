import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../provider/customer_provider.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
          child: commonTextField(
            hintText: "Search customers...",
            prefixIcon: commonPrefixIcon(
              image: icProductSearch,
              width: 16,
              height: 16,
            ),

            suffixIcon: IconButton(
              icon: commonPrefixIcon(
                image: icProductFilter,
                width: 20,
                height: 20,
              ),
              onPressed: () {
                final filters = [
                  FilterItem(
                    label: "Email Subscription",
                    options: ["All", "Subscribed", "Not Subscribed"],
                    selectedValue:
                        provider.selectedStatusFilter, // 👈 provider से लो
                  ),
                ];
                showCommonFilterDialog(
                  context: context,
                  title: "Filter Customer",
                  filters: filters,
                  onReset: () {
                    provider.setStatusFilter("All");
                  },
                  onApply: () {
                    final selectedStatus = filters
                        .firstWhere((f) => f.label == "Email Subscription")
                        .selectedValue;
                    provider.setStatusFilter(selectedStatus);
                  },
                );
              },
            ),
            onChanged: (value) => provider.setSearchQuery(value),
          ),
        ),

        Expanded(
          child: commonListViewBuilder(
            padding: const EdgeInsets.all(12),
            items: provider.customers,
            itemBuilder: (context, index, data) {
              return Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Container(
                    decoration: commonBoxDecoration(borderColor: colorBorder),
                    margin: EdgeInsets.all(5),
                    child: commonListTile(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.customerDetail);
                      },
                      textColor: themeProvider.isDark
                          ? Colors.white
                          : colorLogo,
                      leadingIcon: SizedBox(
                        width: 45,
                        height: 45,
                        child: CircleAvatar(
                          radius: 100,
                          child: commonCircleNetworkImage(data.avatar),
                        ),
                      ),
                      title: data.name,
                      subtitleView: commonText(text: data.email, fontSize: 12),
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: provider
                              .getStatusColor(data.status)
                              .withValues(alpha: 0.1),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: commonBoxDecoration(
                          borderRadius: 8,
                          borderWidth: 0.5,
                          /*  color: provider
                              .getStatusColor(data.status)
                              .withValues(alpha: 0.01),
                          borderColor: provider
                              .getStatusColor(data.status)
                              .withValues(alpha: 1),*/
                        ),
                        child: commonText(
                          text: data.status,
                          color: provider.getStatusColor(data.status),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
