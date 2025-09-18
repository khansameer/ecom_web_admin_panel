import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/string/string_utils.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../core/component/common_dropdown.dart';
import '../../core/image_picker/image_pick_and_crop_widget.dart';
import '../../main.dart';
import '../../provider/theme_provider.dart';
import 'common_product_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() {
    /* final provider = Provider.of<ProductProvider>(context);

    provider.tetName.text=widget.product.name;
    provider.tetDesc.text=widget.product.desc??'';
    provider.tetQty.text='${widget.product.qty}';
    provider.tetPrice.text='${widget.product.price}';*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      provider.tetName.text = widget.product.name;
      provider.tetDesc.text = widget.product.desc ?? '';
      provider.tetQty.text = '${widget.product.qty}';
      provider.tetPrice.text = '${widget.product.price}';
    });
  }

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
                              text: widget.product.name,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : colorLogo,
                            ),
                          ),
                          commonText(
                            text: '$rupeeIcon${widget.product.price}',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: commonText(
                              text: "Quantity : ${widget.product.qty}",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          commonText(
                            text: widget.product.status,
                            fontWeight: FontWeight.w600,
                            color: provider.getStatusColor(
                              widget.product.status,
                            ),
                          ),
                        ],
                      ),

                      commonText(
                        text: widget.product.desc ?? '',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 2),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _commonDotView(themeProvider: themeProvider),
                          _commonDotView(
                            text: "Baby Safe",
                            themeProvider: themeProvider,
                          ),
                          _commonDotView(
                            text: "Handwashable",
                            themeProvider: themeProvider,
                          ),
                          _commonDotView(
                            text: "Environment Friendly",
                            themeProvider: themeProvider,
                          ),
                          _commonDotView(
                            text: "Handmade Product",
                            themeProvider: themeProvider,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // commonFormView(provider: provider),
                  SizedBox(height: 15),
                  commonVariants(provider: provider),
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
                              commonFormView(provider: provider),
                              SizedBox(height: 15),
                              _commonHeading(text: "Status"),

                              SizedBox(height: 15),

                              CommonDropdown(
                                initialValue: provider.status,
                                items: ["Active", "Draft"],
                                enabled: true,
                                onChanged: (value) {
                                  provider.setFilter(value!);
                                },
                              ),
                              SizedBox(height: 30),

                              commonButton(
                                text: "Update",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
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
      ),
    );
  }

  Widget _buildGlassChip({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.black45,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: Colors.green,
                          key: ValueKey("check"),
                        )
                      : const SizedBox.shrink(key: ValueKey("empty")),
                ),
                // if (isSelected) ...[
                //   const Icon(
                //     Icons.check_circle_rounded,
                //     size: 16,
                //     color: Colors.white,
                //   ),
                // ],
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
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
