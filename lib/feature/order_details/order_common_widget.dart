import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../core/color/color_utils.dart';
import '../../main.dart';

productInfo() {
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(isPayment: false),

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

commonHeadingView({String? title, required bool isPayment}) {
  return Padding(
    padding: EdgeInsets.all(12.0),
    child: Row(
      children: [
        Expanded(
          child: commonText(
            text: title ?? "Product Information",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        /*isPayment
            ? Container(
                decoration: commonBoxDecoration(color: colorBorder),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    commonText(
                      text: "Payment Status : ",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    commonText(
                      text: "Paid",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),*/
      ],
    ),
  );
}

orderInfo({required Order order}) {
  final orderProvider = Provider.of<OrdersProvider>(
    navigatorKey.currentContext!,
  );
  final themeProvider = Provider.of<ThemeProvider>(
    navigatorKey.currentContext!,
  );
  return Container(
    decoration: commonBoxDecoration(borderColor: colorBorder, borderRadius: 8),
    margin: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        commonHeadingView(title: "Order Information", isPayment: false),

        const Divider(height: 1),

        // Content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildRow(
                colorText: themeProvider.isDark ? Colors.white : colorLogo,
                title: "Order No", value: '#${order.orderId}', fontWeight: FontWeight.w600,),
              _buildRow(
                fontSize: 14,

                fontWeight: FontWeight.w600,
                title: "Order Status",
                value: order.status,
                colorText:orderProvider.getStatusColor(order.status),

              ),
              _buildRow(title: "Payment Status", value: order.paymentStatus??'', fontWeight: FontWeight.w600, colorText: orderProvider.getPaymentStatusColor(order.paymentStatus??''),),
            ],
          ),
        ),
      ],
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
        commonHeadingView(title: "Customer Information", isPayment: false),

        const Divider(height: 1),

        // Content
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildRow(title: "Name", value: "Sameer Khan"),
              _buildRow(title: "Email", value: "pathansameerahmed@gmail.com"),
              _buildRow(title: "Mobile", value: "+917984512507"),
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
        commonHeadingView(title: "Payment", isPayment: true),

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
            fontWeight: fontWeight ?? FontWeight.w400,
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
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 12,
          ),
        ),
      ],
    ),
  );
}
