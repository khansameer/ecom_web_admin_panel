import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/component/component.dart';
import '../../../core/component/date_utils.dart';
import '../../../core/component/responsive.dart';
import '../../../provider/admin_dashboard_provider.dart';
import '../../../provider/product_provider.dart';

class AdminProductList extends StatefulWidget {
  final String storeName;

  const AdminProductList({super.key, required this.storeName});

  @override
  State<AdminProductList> createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
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

    provider.getAllProduct(storeRoom: widget.storeName);
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    return Consumer2<AdminDashboardProvider, ProductProvider>(
      builder: (context, provider, productProvider, child) {
        /*if (provider.isLoading) {
          return SizedBox.shrink();
        }*/

        return Stack(
          children: [
            provider.allProductModel?.products?.isNotEmpty == true
                ? GridView.builder(
                    itemCount: provider.allProductModel?.products?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      var data = provider.allProductModel?.products?[index];
                      Uint8List? imageBytes;
                      if (data?.imagePath != null &&
                          data?.imagePath?.isNotEmpty == true) {
                        imageBytes = base64Decode(data?.imagePath ?? '');
                      }
                      return Container(
                        margin: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 🖼 Product Image
                            imageBytes != null
                                ? Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.memory(
                                        imageBytes,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(
                                    text: data?.name ?? '',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  commonText(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    text:
                                        'Requested: ${formatString(data?.createdDate ?? DateTime.now().toString())}',
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    spacing: 16,
                                    children: [
                                      Expanded(
                                        child: commonButton(
                                          fontSize: isMobile ? 12 : 14,
                                          height: isMobile ? 45 : null,
                                          radius: 8,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 6,
                                          ),
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          colorBorder: Colors.green.withValues(
                                            alpha: 0.7,
                                          ),
                                          textColor: Colors.green,
                                          text: "Approve",
                                          onPressed: () {
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
                                                    storeRoom: widget.storeName,
                                                  );
                                                }
                                              },
                                              context: context,
                                              content:
                                                  "Are you sure you want to approve this image?",
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: commonButton(
                                          radius: 8,
                                          fontSize: isMobile ? 12 : 14,
                                          height: isMobile ? 45 : null,
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          colorBorder: Colors.red.withValues(
                                            alpha: 0.7,
                                          ),
                                          text: "DisApprove",
                                          textColor: Colors.red,
                                          onPressed: () {
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
                                                    storeRoom: widget.storeName,
                                                  );
                                                }
                                              },
                                              context: context,
                                              content:
                                                  "Are you sure you want to disapprove this image?",
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : commonErrorView(),
            provider.isLoading || productProvider.isImageUpdating
                ? showLoaderList()
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
