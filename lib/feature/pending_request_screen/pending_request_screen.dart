import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/admin_dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../../core/component/date_utils.dart';
import '../../core/hive/app_config_cache.dart';
import '../../models/user_model.dart';
import '../../provider/product_provider.dart';

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({super.key});

  @override
  State<PendingRequestScreen> createState() => _PendingRequestScreenState();
}

class _PendingRequestScreenState extends State<PendingRequestScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<AdminDashboardProvider>(context, listen: false);
      UserModel? user = await AppConfigCache.getUserModel(); // await the future
      provider.getAllProduct(storeRoom: user?.storeName??'');
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      appBar: commonAppBar(
        title: "Pending Request",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: Consumer2<AdminDashboardProvider,ProductProvider>(
          builder: (context, provider,productProvider, child) {

            /*if (provider.isLoading) {
              return SizedBox.shrink();
            }*/

            return Stack(
              children: [
                provider.allProductModel?.products?.isNotEmpty == true
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount:  provider.allProductModel?.products?.length,
                        itemBuilder: (context, index) {
                          var data =  provider.allProductModel?.products?[index];
                          Uint8List? imageBytes;

                          if (data?.imagePath != null) {
                            // Remove the 'data:image/png;base64,' part if it exists
                            final base64String = data!.imagePath!.split(',').last;
                            imageBytes = base64Decode(base64String);
                          }
                          return Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: commonBoxDecoration(
                              borderColor: colorBorder,
                            ),
                            padding: const EdgeInsets.all(0.0),
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageBytes != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadiusGeometry.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Image.memory(
                                          imageBytes,
                                          width: size.width,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SizedBox.shrink(),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8,
                                    top: 5,
                                    bottom: 10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 8,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commonText(
                                        text: data?.name??'',
                                        fontWeight: FontWeight.w500,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /*Expanded(
                                            child: commonText(
                                              text: formatTimestamp(
                                                data?.createdDate,
                                              ),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),*/
                                          _commonButton(
                                            color: Colors.green,
                                            onTap: () async {
                                              UserModel? user = await AppConfigCache.getUserModel(); // await the future
                                              showCommonDialog(
                                                confirmText: "Upload",
                                                title: "Approve",
                                                onPressed: () async {
                                                 Navigator.pop(context);
                                                 Map<String, dynamic> body = {
                                                   "product_id":
                                                   data?.productId ?? 0,
                                                   "imagePath":
                                                   data?.imagePath ?? '',
                                                   "storeName":
                                                   data?.storeName ?? '',
                                                   "versionCode":
                                                   data?.version_code ?? '',
                                                   "accessToken":
                                                   data?.accessToken ?? '',
                                                 };
                                                 final isSuccess =
                                                     await productProvider
                                                     .approvedProductImage(
                                                   params: body,
                                                   imageID:
                                                   data?.imageId ??
                                                       '',
                                                 );
                                                 if (isSuccess) {
                                                   final provider =
                                                   Provider.of<
                                                       AdminDashboardProvider
                                                   >(context, listen: false);

                                                   provider.getAllProduct(
                                                     storeRoom: user?.storeName??'',
                                                   );
                                                 }

                                                },
                                                context: context,
                                                content:
                                                    "Are you sure you want to approve this image?",
                                              );
                                            },
                                          ),
                                          SizedBox(width: 8),
                                          _commonButton(
                                            color: Colors.red,
                                            onTap: () async {
                                              UserModel? user = await AppConfigCache.getUserModel(); // await the future
                                              showCommonDialog(
                                                confirmText: "Yes",
                                                title: "Decline",
                                                onPressed: () async {
                                                  Navigator.pop(context);

                                                  final isSuccess =
                                                      await productProvider
                                                      .disApprovedProductImage(
                                                    productID:
                                                    data?.productId ??
                                                        0,
                                                  );
                                                  if (isSuccess) {
                                                    final provider =
                                                    Provider.of<
                                                        AdminDashboardProvider
                                                    >(context, listen: false);

                                                    provider.getAllProduct(
                                                      storeRoom: user?.storeName??'',
                                                    );
                                                  }
                                                },
                                                context: context,
                                                content:
                                                    "Are you sure you want to disapprove this image?",
                                              );
                                            },
                                            text: "Disapprove",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /* Row(
                            children: [
                              Expanded(child: commonText(text: "Product Name")),
                              commonText(text: "Product Name"),
                            ],
                          ),*/
                              ],
                            ),
                          );
                        },
                      )
                    : commonErrorView(),

                provider.isLoading
                    ? showLoaderList()
                    : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _commonButton({
    String? text,
    required Color color,
    void Function()? onTap,
  }) {
    return commonInkWell(
      onTap: onTap,
      child: Container(
        decoration: commonBoxDecoration(
          borderColor: color,
          color: color.withValues(alpha: 0.05),
          borderRadius: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          child: Center(
            child: commonText(
              color: color,
              text: text ?? "Approve",
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
