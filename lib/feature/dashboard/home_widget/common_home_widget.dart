import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/common_dropdown.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/component/context_extension.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
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

homeTopView({required int  totalProduct,required int totalOrder, }) {
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
                  subtitle: "+50% Incomes",
                  onTap: () {
                    navigatorKey.currentState?.pushNamed(
                      RouteName.salesDetailsScreen,
                      arguments: 278,
                    );
                  },
                  leftText: rupeeIcon,
                  rightText: "m",
                  //value: "\$278m",
                  value: 278,
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
                  subtitle: "+25% New Product",
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
                  subtitle: "+25 New Order",
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
                  leftText: rupeeIcon,
                  title: "Total Customer",
                  subtitle: "+48% New User",
                  value: 4215,
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
  subtitle,
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

        /*  commonText(
            text: subtitle,
            fontSize: 12,
            color: provider.isDark ? Colors.white : colorTextDesc,
          ),
          const SizedBox(height: 8),*/
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

homeGraphView() {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: commonText(
                    text: "Summary Sales",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Spacer(),
                Flexible(
                  child: Consumer<DashboardProvider>(
                    builder: (context, provider, child) {
                      return SizedBox(
                        height: 45,

                        child: CommonDropdown(
                          initialValue: provider.filter,
                          items: ["Today", "Week", "Month"],
                          onChanged: (value) {
                            provider.setFilter(value!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<DashboardProvider>(
                builder: (context, provider, child) {
                  return SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    // hide border
                    primaryXAxis: CategoryAxis(
                      labelStyle: commonTextStyle(
                        fontSize: 12,
                        color: themeProvider.isDark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0), // hide bottom line
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 35,
                      labelStyle: commonTextStyle(
                        color: themeProvider.isDark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      axisLine: const AxisLine(width: 0),
                      // hide right side line
                      interval: 10,
                      majorGridLines: const MajorGridLines(
                        dashArray: <double>[5, 5],
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      header: '',
                      textStyle: commonTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      format: 'point.y k',
                    ),
                    series: <CartesianSeries>[
                      SplineAreaSeries<SalesData, String>(
                        dataSource: provider.salesData,
                        xValueMapper: (SalesData sales, _) => sales.x,
                        yValueMapper: (SalesData sales, _) => sales.y,
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderColor: Colors.orange,
                        borderWidth: 2,
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
                  items: provider.filteredProducts??[],
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index, data) {


                    var data = provider.filteredProducts?[index];
                    final totalVariants = data?.variants?.length;
                    //  final left = "${parts[0]}for";
                    num? totalInventory =
                    data?.variants?.isNotEmpty == true
                        ? data?.variants?.fold(
                      0,
                          (sum, variant) =>
                      sum! + (variant.inventoryQuantity ?? 0),
                    )
                        : 0;

                    return commonProductListView(

                      margin: EdgeInsetsGeometry.only(right: 10),
                      imageMargin: EdgeInsetsGeometry.only(left: 10),

                      width: provider.filteredProducts != null && provider.filteredProducts!.length == 1
                          ? MediaQuery.sizeOf(context).width-30
                          : MediaQuery.sizeOf(context).width - 80,
                      image: data?.image?.src ?? '',
                      onTap: () {

                      },
                      price: data?.variants?.isNotEmpty == true?'$rupeeIcon${data?.variants?.first.price}':'$rupeeIcon 0',
                      textInventory1: "$totalInventory in stock",
                      textInventory2: ' for $totalVariants variants',
                      productName: data?.title ?? '',
                      status:
                      data?.status.toString().toCapitalize() ?? '',
                      colorStatusColor: data?.status?.isNotEmpty == true
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
            width:  MediaQuery.sizeOf(context).width,

            child: Consumer<OrdersProvider>(
              builder: (context, provider, child) {
                return commonListViewBuilder(

                  padding: EdgeInsetsGeometry.zero,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  items: provider.filterOrderList??[],
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index, data) {
                    var data=provider.filterOrderList?[index];
                    return commonOrderView(
                      margin: EdgeInsetsGeometry.only(right: 10),

                      errorImageView: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: commonErrorBoxView(text: data?.name??''),
                      ),
                      width: provider.filterOrderList != null && provider.filterOrderList!.length == 1
                          ? MediaQuery.sizeOf(context).width-30
                          : MediaQuery.sizeOf(context).width - 80,
                      onTap: () {
                        navigatorKey.currentState?.pushNamed(
                          RouteName.orderDetailsScreen,
                          arguments: data,
                        );
                      },
                      colorTextStatus: provider.getPaymentStatusColor('${data?.financialStatus.toString().toCapitalize()}'),
                      decoration: commonBoxDecoration(
                        borderRadius: 4,

                        color: provider
                            .getPaymentStatusColor('${data?.financialStatus.toString().toCapitalize()}')
                            .withValues(alpha: 0.1),
                      ),

                      orderID:'${ data?.customer?.firstName}  ${ data?.customer?.lastName}',
                      image: '',

                      productName:'Items:${data?.lineItems?.length}',
                      status: '${data?.financialStatus.toString().toCapitalize()}',
                      price: double.parse(data?.subtotalPrice?.toString() ?? '0'),
                      date: formatDateTime(data?.createdAt??''), //data.date.toLocal().toString(),
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
