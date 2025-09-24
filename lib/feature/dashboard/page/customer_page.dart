import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../provider/customer_provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider = Provider.of<CustomerProvider>(
        context,
        listen: false,
      );
      await customerProvider.getCustomerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    return commonRefreshIndicator(
      onRefresh: () async {
        init();
      },
      child: ListView(
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
                      selectedValue: provider
                          .selectedStatusFilter, // 👈 provider से लो
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
                          .firstWhere(
                            (f) => f.label == "Email Subscription",
                      )
                          .selectedValue;
                      provider.setStatusFilter(selectedStatus);
                    },
                  );
                },
              ),
              onChanged: (value) => provider.setSearchQuery(value),
            ),
          ),
          commonRefreshIndicator(
            onRefresh: () async {
              init();
            },
            child:  provider.isFetching
                ?SizedBox.shrink()
                :provider.customers?.isNotEmpty==true?commonListViewBuilder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(12),
              physics: BouncingScrollPhysics(),
              items: provider.customers??[],
              itemBuilder: (context, index,data1) {
                var data = provider.customers?[index];
                return Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Container(
                      decoration: commonBoxDecoration(
                        borderColor: colorBorder,
                      ),
                      margin: EdgeInsets.all(5),
                      child: commonListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.customerDetail,
                            arguments: data,
                          );
                        },
                        textColor: themeProvider.isDark
                            ? Colors.white
                            : colorLogo,
                        leadingIcon: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircleAvatar(
                            radius: 100,
                            child: commonCircleNetworkImage(
                              '',

                              errorWidget: commonErrorBoxView(
                                text:
                                '${data?.firstName?[0].toString()}${data?.lastName?[0].toString()}',
                              ),
                            ),
                          ),
                        ),
                        title: '${data?.firstName} ${data?.lastName}',
                        subtitleView: commonText(
                          text: data?.email ?? '',
                          fontSize: 12,
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: provider
                                .getStatusColor(
                              data?.emailMarketingConsent?.state ??
                                  '',
                            )
                                .withValues(alpha: 0.1),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),

                          child: commonText(
                            text:
                            '${data?.emailMarketingConsent?.state.toString().toCapitalize().replaceAll("_", " ")}',
                            color: provider.getStatusColor(
                              data?.emailMarketingConsent?.state ?? '',
                            ),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ):commonErrorView(
              text: "Customer Not Fount."
            ),
          ),


        ],
      ),
    );
  }
}
