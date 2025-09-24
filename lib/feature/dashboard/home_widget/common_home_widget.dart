import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/common_dropdown.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/order_provider.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:neeknots/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/component/animated_counter.dart';
import '../../../core/component/date_utils.dart';
import '../../../core/string/string_utils.dart';
import '../order_widget/common_order_widget.dart';
import '../product_widget/common_product_widget.dart';

homeTopView({
  required int totalProduct,
  required int totalOrder,
  required int totalCustomer,
  required int totalSaleOrder,
  required double totalOrderPrice,
}) {
  return Consumer<ThemeProvider>(
    builder: (context, provider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: _commonDashboardView(
                  color: colorSale,
                  provider: provider,
                  icon: icTotalSale,
                  title: "Today Sales",
                  subtitle: "$rupeeIcon$totalOrderPrice",
                  onTap: () {
                    navigatorKey.currentState?.pushNamed(
                      RouteName.salesDetailsScreen,
                      arguments: 278,
                    );
                  },
                  leftText: "",
                  rightText: "",
                  //value: "\$278m",
                  value: totalSaleOrder,
                ),
              ),
              Expanded(
                child: _commonDashboardView(
                  color: colorProduct,
                  provider: provider,
                  leftText: '',
                  onTap: () {
                    navigatorKey.currentState?.pushNamed(
                      RouteName.totalProductScreen,
                    );
                  },
                  icon: icProductMenu,
                  title: "Total Product",

                  value: totalProduct,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _commonDashboardView(
                  color: Colors.blue.shade400,
                  icon: icOrderMenu,
                  onTap: () {
                    navigatorKey.currentState?.pushNamed(
                      RouteName.totalOrderScreen,
                    );
                  },
                  provider: provider,
                  title: "Total  Order",
                  leftText: '',

                  value: totalOrder,
                ),
              ),
              Expanded(
                child: _commonDashboardView(
                  color: colorUser,
                  onTap: () {
                    navigatorKey.currentState?.pushNamed(
                      RouteName.totalCustomerScreen,
                    );
                  },
                  provider: provider,
                  icon: icTotalUser,
                  leftText: '',
                  title: "Total Customer",

                  value: totalCustomer,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

_commonDashboardView({
  Color? color,
  required ThemeProvider provider,
  required String icon,
  required String title,
  String? subtitle,
  required int value,
  String? leftText,
  String? rightText,
  void Function()? onTap,
}) {
  /*  AnimatedCounter(
    endValue: 4215,
    duration: Duration(seconds: 3),
    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
  ),*/
  return commonInkWell(
    onTap: onTap,
    child: Container(
      width: 140,
      margin: EdgeInsets.all(5),
      padding: const EdgeInsets.all(16),
      decoration: commonBoxDecoration(
        color:
            color?.withValues(alpha: 0.05) ?? colorLogo.withValues(alpha: 0.1),

        borderColor:
            color?.withValues(alpha: 0.3) ?? colorLogo.withValues(alpha: 0.3),
        borderRadius: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2), // border thickness
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color ?? Colors.transparent, // border color
                width: 1.5, // border width
              ),
            ),
            child: CircleAvatar(
              radius: 28,

              backgroundColor: Colors.white,
              child: Center(
                child: commonAssetImage(
                  icon,
                  width: 24,
                  height: 24,
                  color: color ?? Colors.transparent,
                ),
              ) /*Icon(
                icon,
                color: startColor ?? Colors.transparent,
                size: 28,
              )*/,
            ),
          ),
          const SizedBox(height: 12),
          commonText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: provider.isDark ? Colors.white : colorText,
          ),


          AnimatedCounter(
            leftText: leftText,
            rightText: rightText?.isNotEmpty == true ? rightText : '',
            endValue: value,
            duration: Duration(seconds: 2),
            style: commonTextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: provider.isDark ? Colors.white : colorTextDesc1,
            ),
          ),
          /*   subtitle?.isNotEmpty==true?*/ commonText(
            text: subtitle ?? '',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: provider.isDark ? Colors.white : colorLogo,
          ) /*:SizedBox.shrink()*/,
          /*commonText(
            text: value,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: provider.isDark ? Colors.white : colorText,
          ),*/
        ],
      ),
    ),
  );
}

homeGraphView({required bool isSaleDetails}) {
  return Consumer2<ThemeProvider, OrdersProvider>(
    builder: (context, themeProvider, orderProvider, child) {
      final data = orderProvider.orderModelByDate?.orders ?? [];
      final chartData = data.map((order) {
        return SalesData(
          orderNumber: order.name.toString(),
          totalPrice: double.tryParse(order.totalPrice ?? "0") ?? 0,
        );
      }).toList();
      return Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            isSaleDetails?SizedBox.shrink(): Row(
              children: [
                Expanded(
                  child: commonText(
                    text: "Summary Sales",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Spacer(),
             Expanded(
                  child: SizedBox(
                    height: 45,
                    child: CommonDropdown(
                      borderRadius: 5,
                      initialValue: orderProvider.selectedRange,
                      items: ["Today", "Week", "Month"],

                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          orderProvider.setRange(newValue); // update Provider

                          orderProvider.fetchByRange(newValue);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),


            Flexible(
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return chartData.isEmpty
                      ? Center(
                    child: Text(
                      "No Data Available",
                      style: commonTextStyle(
                        fontSize: 14,
                        color: themeProvider.isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                      :
                   SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      labelStyle: commonTextStyle(
                        fontSize: 12,
                        color: themeProvider.isDark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: commonTextStyle(
                        color: themeProvider.isDark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      axisLine: const AxisLine(width: 0),

                      // hide right side line
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      header: '',
                      builder:
                          (
                            dynamic data,
                            dynamic point,
                            dynamic series,
                            int pointIndex,
                            int seriesIndex,
                          ) {
                            final sales = data as SalesData;
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                sales.orderNumber,

                                // "Orders: ${sales.orderIds.join(', ')}\nTotal: ${sales.y}",
                                style: commonTextStyle(color: Colors.white),
                              ),
                            );
                          },
                    ),
                    series: <CartesianSeries<SalesData, String>>[
                      ColumnSeries<SalesData, String>(
                        color: Colors.orange.withValues(alpha: 0.3),
                        borderColor: Colors.orange,
                        borderWidth: 2,

                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        width: 0.5,   // bar thickness (0.5 = 50% of available slot)
                        spacing: 0.2, // gap between bars
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          height: 6,
                          width: 6,
                          shape: DataMarkerType.circle,
                          borderWidth: 2,
                        ),
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => sales.orderNumber,
                        yValueMapper: (SalesData sales, _) => sales.totalPrice,

                        dataLabelSettings: DataLabelSettings(isVisible: true,  textStyle: commonTextStyle(
                          fontWeight: FontWeight.w600, // ✅ Bold
                          fontSize: 12,               // optional size
                          color: colorTextDesc1,        // or Colors.white in dark mode
                        ),),
                        dataLabelMapper: (SalesData sales, _) =>
                        "$rupeeIcon${sales.totalPrice.toStringAsFixed(0)}",
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

commonTopProductListView({void Function()? onTap}) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: commonText(
                  text: "Top Products",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Spacer(),
              commonInkWell(
                onTap: onTap,
                child: commonText(
                  text: "See All",
                  color: themeProvider.isDark ? Colors.white : colorTextDesc,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 130,
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return commonListViewBuilder(
                  padding: EdgeInsetsGeometry.zero,
                  shrinkWrap: true,
                  items: provider.products,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index, data) {
                    var data = provider.products[index];
                    final totalVariants = data.variants?.length;
                    //  final left = "${parts[0]}for";
                    num? totalInventory = data.variants?.isNotEmpty == true
                        ? data.variants?.fold(
                            0,
                            (sum, variant) =>
                                sum! + (variant.inventoryQuantity ?? 0),
                          )
                        : 0;

                    return commonProductListView(
                      margin: EdgeInsetsGeometry.only(right: 10),
                      imageMargin: EdgeInsetsGeometry.only(left: 10),

                      width:
                          provider.products != null &&
                              provider.products!.length == 1
                          ? MediaQuery.sizeOf(context).width - 30
                          : MediaQuery.sizeOf(context).width - 80,
                      image: data.image?.src ?? '',
                      onTap: () {},
                      price: data.variants?.isNotEmpty == true
                          ? '$rupeeIcon${data.variants?.first.price}'
                          : '$rupeeIcon 0',
                      textInventory1: "$totalInventory in stock",
                      textInventory2: ' for $totalVariants variants',
                      productName: data.title ?? '',
                      status: data.status.toString().toCapitalize() ?? '',
                      colorStatusColor: data.status?.isNotEmpty == true
                          ? provider.getStatusColor(
                              data!.status.toString().toCapitalize(),
                            )
                          : Colors.grey,
                      decoration: commonBoxDecoration(
                        borderRadius: 8,
                        borderWidth: 0.5,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

commonTopOrderListView({void Function()? onTap}) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: commonText(
                  text: "Top Orders",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Spacer(),
              commonInkWell(
                onTap: onTap,
                child: commonText(
                  text: "See All",
                  color: themeProvider.isDark ? Colors.white : colorTextDesc,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 130,
            width: MediaQuery.sizeOf(context).width,

            child: Consumer<OrdersProvider>(
              builder: (context, provider, child) {
                return commonListViewBuilder(
                  padding: EdgeInsetsGeometry.zero,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  items: provider.filterOrderList ?? [],
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index, data) {
                    var data = provider.filterOrderList?[index];
                    return commonOrderView(
                      margin: EdgeInsetsGeometry.only(right: 10),

                      errorImageView: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: commonErrorBoxView(text: data?.name ?? ''),
                      ),
                      width:
                          provider.filterOrderList != null &&
                              provider.filterOrderList!.length == 1
                          ? MediaQuery.sizeOf(context).width - 30
                          : MediaQuery.sizeOf(context).width - 80,
                      onTap: () {
                        navigatorKey.currentState?.pushNamed(
                          RouteName.orderDetailsScreen,
                          arguments: data,
                        );
                      },
                      colorTextStatus: provider.getPaymentStatusColor(
                        '${data?.financialStatus.toString().toCapitalize()}',
                      ),
                      decoration: commonBoxDecoration(
                        borderRadius: 4,

                        color: provider
                            .getPaymentStatusColor(
                              '${data?.financialStatus.toString().toCapitalize()}',
                            )
                            .withValues(alpha: 0.1),
                      ),

                      orderID:
                      data?.customer?.firstName!=null?
                      '${data?.customer?.firstName}  ${data?.customer?.lastName}':noCustomer,
                      image: '',

                      productName: 'Items:${data?.lineItems?.length}',
                      status:
                          '${data?.financialStatus.toString().toCapitalize()}',
                      price: double.parse(
                        data?.subtotalPrice?.toString() ?? '0',
                      ),
                      date: formatDateTime(
                        data?.createdAt ?? '',
                      ), //data.date.toLocal().toString(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
