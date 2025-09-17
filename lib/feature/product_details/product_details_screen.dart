import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../core/component/common_dropdown.dart';
import '../../core/image_picker/image_pick_and_crop_widget.dart';
import '../../main.dart';
import '../../provider/theme_provider.dart';
import 'common_product_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(
      navigatorKey.currentContext!,
    );
    return commonScaffold(
      appBar: commonAppBar(
        title: "Product Details",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: ListView(
          children: [
            SizedBox(height: 8),
            commonBannerView(
              provider: provider,
              onTap: () async {
                final path = await CommonImagePicker.pickImage(
                  context,
                  themeProvider,
                );
                if (path != null) {
                  print('=======$path');
                  //imageProvider.setImagePath(path);

                  /*  provider.setImageFilePath(
                  img: File(imageProvider.imagePath!),
                );*/
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonFormView(provider: provider),

                  SizedBox(height: 15),
                  commonVariants(provider: provider),
                  SizedBox(height: 15),
                  _commonHeading(text: "Status"),
                  SizedBox(height: 15),
                  CommonDropdown(
                    initialValue: provider.status,
                    items: ["Active", "Draft"],
                    enabled: provider.isEdit, // 👈 इस से ही control हो जाएगा
                    onChanged: provider.isEdit
                        ? (value) {
                            provider.setFilter(value!);
                          }
                        : (value) {}, // 👈 fallback empty function
                  ),
                  SizedBox(height: 30),
                  commonButton(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    text: provider.isEdit ? "Update" : "Edit",
                    onPressed: () {
                      if (provider.isEdit) {
                        /// TODO: Save / Update logic here
                      }
                      provider.toggleEdit(); // 👈 provider state change
                    },
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _commonHeading({String? text}) {
    return commonText(
      text: text ?? "Product Description",
      fontWeight: FontWeight.w600,
    );
  }
}
