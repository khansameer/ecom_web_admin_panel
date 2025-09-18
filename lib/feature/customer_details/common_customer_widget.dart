import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/string/string_utils.dart';
import 'package:neeknots/feature/order_details/order_common_widget.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:provider/provider.dart';

customerDetailsInfo() {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: "Customer  Information", isPayment: false),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildRow(title: "Name", value: "Sameer Khan"),
              _buildRow(title: "email", value: "sameer@gmail.com  "),
              _buildRow(title: "Customer Since", value: "7 Month"),
              _buildRow(title: "RFM Group", value: "Needs Attentions"),
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

        // Content
      ],
    ),
  );
}

customerOrderDetailsInfo() {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: "Details  Information", isPayment: false),
        const Divider(height: 1),

        // Content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildRow(title: "Amount Spent", value: "$rupeeIcon${"1500.00"}"),
              _buildRow(title: "Order", value: "1"),
              _buildRow(title: "Customer Since", value: "7 Month"),
              _buildRow(title: "RFM Group", value: "Needs Attentions"),
            ],
          ),
        ),

        const Divider(height: 1),

        // Footer text
      ],
    ),
  );
}

customerProductInfo() {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(isPayment: false, title: "Last Order Placed"),

        const Divider(height: 1),

        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  spacing: 20,
                  children: [
                    commonText(
                      text: "#1014",

                      fontWeight: FontWeight.w600,
                    ),
                    Container(
                      decoration: commonBoxDecoration(color: colorBorder),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 3,
                        ),
                        child: commonText(
                          text: "Paid",
                          fontSize: 10,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      decoration: commonBoxDecoration(color: colorBorder),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 3,
                      ),
                      child: commonText(
                        text: "Fulfilled",
                        fontSize: 10,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  commonText(
                    text: "$rupeeIcon${"1050.00"}",
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: commonText(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            text: "3 September 2025 at  7:19 pm from  Draft Orders",
          ),
        ),
        SizedBox(height: 10),
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

Widget _buildRow({
  required String title,
  required String value,
  FontWeight? fontWeight,
  Color? colorText,
  Decoration? decoration,
  EdgeInsetsGeometry? padding,
  double? fontSize,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        commonText(text: title, fontWeight: FontWeight.w400, fontSize: 14),
        Container(
          padding: padding,
          decoration: decoration,
          child: commonText(
            text: value,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 14,
            color: colorText,
          ),
        ),
      ],
    ),
  );
}
