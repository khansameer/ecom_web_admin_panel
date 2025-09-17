import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../../core/color/color_utils.dart';

productInfo() {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(),

        const Divider(height: 1),

        // Content
        Consumer<OrdersProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: commonListViewBuilder(
                shrinkWrap: true,
                padding: EdgeInsetsGeometry.zero,
                items: provider.ordersDetails,
                itemBuilder: (context, index, data) {
                  return Container(
                    decoration: commonBoxDecoration(borderColor: colorBorder),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    margin: const EdgeInsets.all(5.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        commonNetworkImage(
                          borderRadius: 10,
                          fit: BoxFit.cover,
                          shape: BoxShape.rectangle,
                          data.image,
                          size: 50,
                        ),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonText(
                                text: data.title,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              commonText(text: data.desc, fontSize: 12),
                              commonText(
                                text: 'Qty:${data.qty}',
                                fontSize: 12,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: commonText(
                            text: '\$${data.price}',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}

commonHeadingView({String? title}) {
  return Padding(
    padding: EdgeInsets.all(12.0),
    child: commonText(
      text: title ?? "Product Information",
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

customerInfo() {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: "Customer Information"),

        const Divider(height: 1),

        // Content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildRow("Name", "Sameer Khan"),
              _buildRow("Email", "pathansameerahmed@gmail.com"),
              _buildRow("Mobile", "+917984512507"),
            ],
          ),
        ),

        const Divider(height: 1),

        // Footer text
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonText(text: "Shipping address", fontWeight: FontWeight.w600),
              commonText(
                text:
                    "Turquoise 3, BLOCK-A, 501, Gala Gymkhana Rd, South Bopal, Bopal, Ahmedabad, Gujarat 380058",

                fontSize: 12,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonText(text: "Billing address", fontWeight: FontWeight.w600),
              commonText(
                text:
                    "Turquoise 3, BLOCK-A, 501, Gala Gymkhana Rd, South Bopal, Bopal, Ahmedabad, Gujarat 380058",

                fontSize: 12,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

paymentSummery() {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: "Payment"),

        const Divider(height: 1),

        // Content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildRowPayment(
                title: "Subtotal",
                amount: "\$750.00",
                value: "5 items",
              ),
              _buildRowPayment(
                title: "Add discount",
                amount: "\$0.00",
                value: "-",
              ),
              _buildRowPayment(
                title: "Add shipping or delivery",
                amount: "\$0.00",
                value: '-',
              ),
              _buildRowPayment(
                title: "Estimated tax",
                value: "Not calculated",
                amount: "",
              ),
              const SizedBox(height: 8),
              const Divider(),
              _buildRowPayment(
                title: "Total",
                fontWeight: FontWeight.w600,
                amount: "\$750.00",
                fontSize: 14,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        commonText(text: title, fontWeight: FontWeight.w400, fontSize: 14),
        commonText(text: value, fontWeight: FontWeight.w500, fontSize: 14),
      ],
    ),
  );
}

Widget _buildRowPayment({
  required String title,
  String? value,
  double? fontSize,
  FontWeight? fontWeight,
  required String amount,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        Expanded(
          child: commonText(
            textAlign: TextAlign.left,
            text: title,
            fontWeight: fontWeight??FontWeight.w400,
            fontSize: fontSize ?? 12,
          ),
        ),

        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonText(
                text: value ?? '',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        Expanded(
          child: commonText(
            textAlign: TextAlign.right,
            text: amount,
            fontWeight: fontWeight??FontWeight.w500,
            fontSize: fontSize ?? 12,
          ),
        ),
      ],
    ),
  );
}
