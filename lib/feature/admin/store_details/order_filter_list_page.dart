import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/color/color_utils.dart';
import '../../../core/component/component.dart';
import '../../../provider/admin_dashboard_provider.dart';

class OrderFilterListPage extends StatefulWidget {
  final String storeName;
  final String collectionName;

  const OrderFilterListPage({
    super.key,
    required this.storeName,
    required this.collectionName,
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
    final customerProvider = Provider.of<AdminDashboardProvider>(
      context,
      listen: false,
    );

    customerProvider.getStoreCollectionData(
      storeName: widget.storeName,
      collectionName: widget.collectionName,
    );
  }

  void _showAddFilterDialog(BuildContext context) {
    final nameController = TextEditingController();
    bool status = false;

    showCommonDialog(
      title: "Add New Filter",
      context: context,
      confirmText: "Save",
      onPressed: () async {
        final name = nameController.text.trim();
        if (name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a filter name")),
          );
          return;
        }

        final provider = context.read<AdminDashboardProvider>();
        final message = await provider.addNewOrderFilter(name, status);

        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Filter added successfully!")),
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
                    Checkbox(
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return SizedBox.shrink();
        }
        if (provider.allOrderFilterList.isEmpty) {
          return commonErrorView();
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Column(
                children: [

                  SizedBox(height: 10),
                  Expanded(
                    child: commonListViewBuilder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      items: provider.allOrderFilterList,
                      itemBuilder: (context, index, data) {
                        final item = provider.allOrderFilterList[index];
                        return Container(
                          decoration: commonBoxDecoration(
                            borderColor: colorBorder,
                          ),
                          margin: EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: commonListTile(
                              contentPadding: EdgeInsetsGeometry.zero,
                              title: item["title"] ?? "No Name",
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showCommonDialog(
                                    confirmText: "Yes",
                                    cancelText: "No",
                                    title: "Delete",
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await context.read<AdminDashboardProvider>().deleteOrderFilter(item["uid"]);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Deleted \"${item["title"]}\"")),
                                      );
                                    },
                                    context: context,
                                    content:
                                    "Are you sure you want to delete ${item["title"]}",
                                  );
                                  /*   _confirmDelete(
                                          context, item["uid"], item["name"] ?? "Unknown")*/
                                },
                              ),
                              leadingIcon: Checkbox(
                                value: item["status"] ?? false,
                                onChanged: (value) {
                                  provider.toggleStatus(
                                    item["uid"],
                                    value ?? false,
                                  );
                                },
                              ),
                              /*  activeColor: colorLogo,


                                  checkColor: Colors.white,
                                  contentPadding: EdgeInsetsGeometry.zero,
                                  title: commonText(
                                    text: item["title"] ?? "No Name",
                                  ),
                                  value: item["status"] ?? false,
                                  onChanged: (bool? newValue) {
                                    if (newValue != null) {
                                      */
                              /*  provider.updateOrderFilterStatus(
                                        item["uid"],
                                        newValue,
                                      );*/
                              /*
                                      provider.toggleStatus(
                                        item["uid"],
                                        newValue ?? false,
                                      );
                                    }
                                  },*/
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 30.0,
                      left: 16,
                      right: 16,
                    ),
                    child: commonButton(
                      text: "Update",
                      onPressed: () async {
                        await provider.updateAllStatusesToFirebase();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: commonText(
                              text: "Statuses updated!",
                              color: Colors.white,
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
    );
  }
}
