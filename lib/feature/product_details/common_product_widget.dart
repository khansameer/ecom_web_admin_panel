import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neeknots/core/component/price_input_format.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../../core/color/color_utils.dart';
import '../../core/component/component.dart';
import '../../main.dart';
import '../../provider/theme_provider.dart';

commonBannerView({required ProductProvider provider, void Function()? onTap}) {
  final themeProvider = Provider.of<ThemeProvider>(
    navigatorKey.currentContext!,
  );
  return Column(
    children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 360.0,
          enlargeCenterPage: false,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.7,
          onPageChanged: (index, reason) {
            provider.setCurrentIndex(index); // update provider
          },
        ),
        items: provider.productsDetails.map((img) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade200,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: commonNetworkImage(img.icon, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: commonInkWell(
                        onTap: () {
                          showCommonDialog(
                            confirmText: "Remove",
                            title: "Remove",
                            context: context,
                            content:
                                "Do you want to remove this image from our product.",
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: commonBoxDecoration(
                            shape: BoxShape.circle,
                            color: colorLogo.withValues(alpha: 0.5),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),

      /// Dots Indicator
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: provider.images.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () {
              // optionally jump to slide using controller
            },
            child: Container(
              width: 10.0,
              height: 10.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    (provider.currentIndex == entry.key
                            ? colorLogo
                            : Colors.grey)
                        .withValues(alpha: 0.9),
              ),
            ),
          );
        }).toList(),
      ),

      Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            commonInkWell(
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                decoration: commonBoxDecoration(
                  borderWidth: 0.5,
                  borderColor: themeProvider.isDark ? Colors.white : colorLogo,
                ),
                child: Center(
                  child: commonText(
                    text: "Add Image",
                    color: themeProvider.isDark ? Colors.white : colorLogo,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

commonFormView({required ProductProvider provider}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _commonHeading(text: "Product Name"),
      SizedBox(height: 8),
      commonTextField(enabled: provider.isEdit, hintText: "Alligator Soft Toy"),
      SizedBox(height: 15),
      _commonHeading(text: "Product Description"),
      SizedBox(height: 8),
      commonTextField(
        enabled: provider.isEdit,
        hintText:
            "The Paraiso blouse embodies effortless warm-weather dressing. The unique cotton eyelet is enhanced by the volume of the tiers, which end in a high-low hem. The puff sleeves add just a touch of sweetness. Shown with the Norte short for a tonal look.",
      ),

      SizedBox(height: 15),

      Row(
        spacing: 10,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _commonHeading(text: "Qty"),
                SizedBox(height: 8),
                commonTextField(
                  hintText: "1",
                  enabled: provider.isEdit,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 0,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _commonHeading(text: "Price"),
                SizedBox(height: 8),
                commonTextField(
                  hintText: "\$25",
                  enabled: provider.isEdit,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [PriceInputFormatter()],
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

commonVariants({required ProductProvider provider}) {
  return Column(
    spacing: 0,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _commonHeading(text: "Variants"),
      SizedBox(height: 8),
      commonListViewBuilder(
        shrinkWrap: true,
        padding: EdgeInsetsGeometry.zero,
        items: provider.productsVariants,
        itemBuilder: (context, index, data) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Container(
                decoration: commonBoxDecoration(borderColor: colorBorder),
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                child: commonListTile(
                  textColor: themeProvider.isDark ? Colors.white : colorLogo,
                  contentPadding: EdgeInsetsGeometry.zero,
                  leadingIcon: Container(
                    width: 40,
                    margin: EdgeInsets.only(left: 5),
                    height: 40,
                    decoration: commonBoxDecoration(
                      color: themeProvider.isDark ? Colors.white : colorLogo,
                    ),
                    child: Center(
                      child: commonText(
                        color: themeProvider.isDark
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                        text: data.name[0],
                      ),
                    ),
                  ),
                  subtitleView: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: commonBoxDecoration(
                          color: colorBorder,
                          borderRadius: 5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 10,
                          ),
                          child: commonText(
                            text: data.status,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: data.name,
                ),
              );
            },
          );
        },
      ),
    ],
  );
}

_commonHeading({String? text}) {
  return commonText(
    text: text ?? "Product Description",
    fontWeight: FontWeight.w600,
  );
}
