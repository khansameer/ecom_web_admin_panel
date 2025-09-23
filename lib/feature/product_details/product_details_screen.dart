import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/string/string_utils.dart';
import 'package:neeknots/models/product_model.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../core/component/common_dropdown.dart';
import '../../core/image_picker/image_pick_and_crop_widget.dart';
import '../../main.dart';
import '../../provider/theme_provider.dart';
import 'common_product_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.products});

  final Products products;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    //Update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.tetName.text = widget.products.title ?? '';
      provider.tetDesc.text = widget.products.bodyHtml ?? '';
      provider.tetQty.text = '${widget.products.variants?.length ?? 0}';
      provider.tetPrice.text = widget.products.variants?.first.price ?? "0";
      provider.fetchImagesForProduct(widget.products);
      provider.productImages = widget.products.images ?? [];

      if (widget.products.id != null) {
        provider.getProductDetail(productId: "${widget.products.id}");

        print("product model:- ${provider.product?.id ?? 0}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(
      navigatorKey.currentContext!,
    );

    final stockInfo = _stockCalculation();
    final inventory = stockInfo["inventory"];
    final variants = stockInfo["variants"];

    return commonScaffold(
      appBar: commonAppBar(
        title: "Product Details",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(height: 8),
                commonBannerView(
                  provider: provider,
                  images: provider.productImages,
                  onTap: () async {
                    final path = await CommonImagePicker.pickImage(
                      context,
                      themeProvider,
                    );
                    if (path != null) {
                      provider.uploadProductImage(
                        imagePath: path,
                        productId: widget.products.id ?? 0,
                      );
                    }
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: commonText(
                                  text: widget.products.title ?? '',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: themeProvider.isDark
                                      ? Colors.white
                                      : colorLogo,
                                ),
                              ),
                              commonText(
                                text: _priceCalculation(),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: commonBoxDecoration(
                                  borderColor: colorBorder,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 5,
                                ),
                                child: _commonRichText(
                                  str1: inventory ?? '',
                                  str2: variants ?? '',
                                  provider: themeProvider,
                                ),
                                /**
                                 * commonText(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  text: "${_stockCalculation()}",
                                  // "Qty:- ${widget.products.variants?.length ?? 0} ",
                                  // ${widget.product.qty}",
                                ),
                                 */
                              ),

                              Spacer(),
                              Container(
                                decoration: commonBoxDecoration(
                                  borderColor: colorBorder,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 5,
                                ),
                                child: Row(
                                  children: [
                                    commonText(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      text: "Status : ",
                                    ),
                                    commonText(
                                      textAlign: TextAlign.right,
                                      text: widget.products.status ?? '',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: provider.getStatusColor(
                                        widget.products.status
                                                ?.toCapitalize() ??
                                            'Grey',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),

                          commonText(
                            text: "Description", //widget.product.desc ?? '',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),

                          commonText(
                            text: removeHtmlTags(
                              widget.products.bodyHtml ?? '',
                            ),
                          ),
                        ],
                      ),

                      // commonFormView(provider: provider),
                      SizedBox(height: 15),
                      commonOtherVariants(
                        provider: provider,
                        products: widget.products,
                      ),
                      commonVariants(
                        provider: provider,
                        products: widget.products,
                      ),
                      SizedBox(height: 30),

                      commonButton(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        text: "Edit",
                        //text: provider.isEdit ? "Update" : "Edit",
                        onPressed: () {
                          showCommonBottomSheet(
                            context: context,
                            content: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      commonInkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: commonBoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              size: 15,
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  commonFormView(provider: provider),
                                  SizedBox(height: 15),
                                  _commonHeading(text: "Status"),

                                  SizedBox(height: 15),
                                  CommonDropdown(
                                    initialValue: provider.status,
                                    items: ["Active", "Draft"],
                                    enabled: provider.isEdit,
                                    onChanged: provider.isEdit
                                        ? (value) {
                                            provider.setFilter(value!);
                                          }
                                        : (value) {},
                                  ),
                                  SizedBox(height: 30),

                                  commonButton(
                                    text: "Update",
                                    onPressed: () {},
                                  ),
                                  SizedBox(height: 30),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
            provider.isImageUpdating ? showLoaderList() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Map<String, String> _stockCalculation() {
    var data = widget.products.variants ?? [];
    final totalVariants = data.length;
    //  final left = "${parts[0]}for";
    num? totalInventory = data.isNotEmpty == true
        ? data.fold(
            0,
            (sum, variant) => sum! + (variant.inventoryQuantity ?? 0),
          )
        : 0;

    return {
      "inventory": "$totalInventory in stock",
      "variants": "for $totalVariants variants",
    };
  }

  _priceCalculation() {
    var data = widget.products.variants ?? [];
    final priceText = data.isNotEmpty == true
        ? '$rupeeIcon${data.first.price}'
        : '$rupeeIcon 0';
    return priceText;
  }

  _commonRichText({
    required String str1,
    required String str2,
    required ThemeProvider provider,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$str1 ", // first part
            style: commonTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorOffline,
            ),
          ),
          TextSpan(
            text: str2, // second part
            style: commonTextStyle(
              fontSize: 12,
              color: provider.isDark ? Colors.white : colorText,
            ),
          ),
        ],
      ),
    );
  }

  _commonDotView({String? text, required ThemeProvider themeProvider}) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: commonBoxDecoration(
            color: themeProvider.isDark
                ? Colors.white
                : Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(child: commonText(text: text ?? 'Pure Cotton', fontSize: 12)),
      ],
    );
  }

  _commonHeading({String? text}) {
    return commonText(
      text: text ?? "Product Description",
      fontWeight: FontWeight.w600,
    );
  }
}
