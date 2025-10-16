import 'package:flutter/material.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/feature/admin/model/all_order_model.dart';
import 'package:provider/provider.dart';

import '../../../core/color/color_utils.dart';
import '../../../core/component/common_switch.dart';
import '../../../core/component/component.dart';
import '../../../core/component/responsive.dart';
import '../../../core/hive/app_config_cache.dart';
import '../../../models/user_model.dart';
import '../../../provider/admin_dashboard_provider.dart';

class OrderFilterListPage extends StatefulWidget {
  final String storeName;


  const OrderFilterListPage({
    super.key,
    required this.storeName,
  });

  @override
  State<OrderFilterListPage> createState() => _StoreCollectionTabState();
}

class _StoreCollectionTabState extends State<OrderFilterListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  void init() {
    final provider = Provider.of<AdminDashboardProvider>(
      context,
      listen: false,
    );

    provider.getAllOrder(storeRoom: widget.storeName);
  }

  void _showAddFilterDialog(BuildContext context) {
    final nameController = TextEditingController();
    bool status = false;

    showCommonDialog(
      title: "Add New Filter",
      context: context,
      confirmText: "Add",
      onPressed: () async {
        final name = nameController.text.trim();
        if (name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a filter name")),
          );
          return;
        }

        final provider = context.read<AdminDashboardProvider>();
        UserModel? user =
            await AppConfigCache.getUserModel(); // await the future
        Map<String, dynamic> params = {
          "id": user?.id ?? 0,
          "title": name,
          "status": status ? 1 : 0,
          "store_name": widget.storeName,
        };
        final isSuccess = await provider.createOrder(
          params: params,
          storeRoom: widget.storeName,
        );
        // final message = await provider.createOrder(name: name,status: status,storeName: widget.storeName);

        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Order created successfully!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to create order. Please try again."),
            ),
          );
          Navigator.pop(context);
        }
      },
      contentView: StatefulBuilder(
        builder: (context, setState) {
          return Material(
            color: Colors.transparent,
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText(text: "Title"),
                commonTextField(hintText: '', controller: nameController),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonText(text: "Status:"),
                    CommonSwitch(
                      activeThumbColor: Colors.green,
                      // when ON
                      inactiveThumbColor: Colors.grey,
                      // thumb when OFF
                      inactiveTrackColor: Colors.grey.withValues(alpha: 0.4),

                      // track when OFF
                      value: status,
                      onChanged: (value) {
                        setState(() => status = value ?? false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditFilterDialog({required BuildContext context, Orders? item}) {
    final nameController = TextEditingController(text: item?.title ?? '');
    bool status = (item?.status == 1);

    showCommonDialog(
      title: "Update Details",
      context: context,
      confirmText: "Update",
      onPressed: () async {
        final name = nameController.text.trim();

        if (name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a filter name")),
          );
          return;
        }

        final provider = context.read<AdminDashboardProvider>();
        final params = {
          "title": name,
          "status": status ? 1 : 0,
          "store_name": widget.storeName,
        };

        final isSuccess = await provider.updateOrder(
          params: params,
          orderID: item?.orderId ?? 0,
          storeRoom: widget.storeName,
        );

        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Order updated successfully!")),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to update order. Please try again."),
            ),
          );
        }
      },
      contentView: StatefulBuilder(
        builder: (context, setState) {
          return Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(text: "Title"),
                const SizedBox(height: 8),
                commonTextField(hintText: '', controller: nameController),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    commonText(text: "Status:"),
                    CommonSwitch(
                      activeThumbColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withValues(alpha: 0.4),
                      value: status,
                      onChanged: (value) {
                        setState(() => status = value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: commonButton(
                height: 45,

                colorBorder: colorBorder,
                color: Colors.white,
                textColor: colorLogo,
                padding: EdgeInsets.symmetric(horizontal: 30),
                fontSize: 12,

                text: "Add New Order Filter",
                onPressed: () {
                  _showAddFilterDialog(context);
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Consumer<AdminDashboardProvider>(
            builder: (context, provider, _) {
              /* if (provider.isLoading) {
                return SizedBox.shrink();
              }*/
              if (provider.allOrderModel?.orders?.isEmpty == true) {
                return commonErrorView();
              }

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 0,
                    ),
                    child: Column(
                      children: [

                        SizedBox(height: 10),
                        Expanded(
                          child: commonListViewBuilder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            items: provider.allOrderModel?.orders ?? [],
                            itemBuilder: (context, index, data) {
                              final item =
                                  provider.allOrderModel?.orders?[index];
                              return Container(
                                decoration: commonBoxDecoration(
                                  color: Colors.white,
                                  borderColor: colorBorder,
                                ),
                                margin: EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  child: commonListTile(
                                    titleFontSize: isMobile ? 14 : 16,

                                    contentPadding: EdgeInsetsGeometry.zero,
                                    title:
                                        item?.title.toString().toCapitalize() ??
                                        '',
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CommonSwitch(
                                          scale: isMobile ? 0.6 : 0.8,
                                          value: (item?.status == 1),
                                          onChanged: (value) async {
                                            setState(() {
                                              item?.status = value ? 1 : 0;
                                            });

                                            final params = {
                                              "status": value ? 1 : 0,
                                              "store_name": widget.storeName,
                                            };

                                            final isSuccess = await provider
                                                .updateOrder(
                                                  params: params,
                                                  orderID: item?.orderId ?? 0,
                                                  storeRoom: widget.storeName,
                                                );
                                            if (isSuccess) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Order updated successfully!",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Order updated not successfully!",
                                                  ),
                                                ),
                                              );
                                            }

                                          },
                                          activeThumbColor: Colors.green,
                                          inactiveThumbColor: Colors.red,
                                        ),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            _showEditFilterDialog(
                                              context: context,
                                              item: item,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            showCommonDialog(
                                              confirmText: "Yes",
                                              cancelText: "No",
                                              title: "Delete",
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await context
                                                    .read<
                                                      AdminDashboardProvider
                                                    >()
                                                    .deleteOrderByID(
                                                      orderID:
                                                          item?.orderId ?? 0,
                                                      storeRoom:
                                                          widget.storeName,
                                                    );
                                              },
                                              context: context,
                                              content:
                                                  "Are you sure you want to delete ${item?.title ?? ''}",
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  provider.isLoading ? showLoaderList() : SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
