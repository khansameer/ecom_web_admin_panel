import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
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
                    label: "Status",
                    options: ["All", "Active", "Inactive"],
                    selectedValue: "All",
                  ),

                ];
                showCommonFilterDialog(
                  context: context,
                  title: "Filter Customer",
                  filters: filters,
                  onReset: () {
                    // reset all filters
                    for (var filter in filters) {
                      filter.selectedValue = "All";
                    }

                  },
                  onApply: () {
                    final selectedStatus = filters
                        .firstWhere((f) => f.label == "Status")
                        .selectedValue;
                    provider.setStatusFilter(selectedStatus);

                    //provider.setStatusFilter(value);

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
            itemBuilder: (context, index,data) {

              return Container(
                decoration: commonBoxDecoration(
                  borderColor: colorBorder
                ),
                margin: EdgeInsets.all(5),
                child: commonListTile(
                  textColor: colorLogo,
                  leadingIcon: CircleAvatar(
                    backgroundImage: NetworkImage(data.avatar),
                  ),
                  title: data.name,
                  subtitle: data.email,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: commonBoxDecoration(
                      borderRadius: 8,
                      borderWidth: 0.5,
                      color: provider
                          .getStatusColor(data.status)
                          .withValues(alpha: 0.01),
                      borderColor: provider
                          .getStatusColor(data.status)
                          .withValues(alpha: 1),
                    ),
                    child: commonText(
                     text:  data.status,
                      color: provider.getStatusColor(data.status),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
