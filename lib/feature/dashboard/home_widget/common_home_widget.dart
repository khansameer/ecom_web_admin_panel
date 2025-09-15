import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/CommonDropdown.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';
import 'package:neeknots/feature/dashboard/product_widget/common_product_widget.dart';
import 'package:neeknots/provider/dashboard_provider.dart';
import 'package:neeknots/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

homeTopView() {
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

              icon: icTotalSale,
              title: "Total Sales",
              subtitle: "+50% Incomes",
              value: "\$278m",
            ),
          ),
          Expanded(
            child: _commonDashboardView(
              color: colorProduct,

              icon: icProductMenu,
              title: "Total Product",
              subtitle: "+25% New Product",
              value: "548",
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
              title: "Total  Order",
              subtitle: "+25 New Order",
              value: "845",
            ),
          ),
          Expanded(
            child: _commonDashboardView(
              color: colorUser,

              icon: icTotalUser,
              title: "Total Customer",
              subtitle: "+48% New User",
              value: "4215",
            ),
          ),
        ],
      ),
    ],
  );
}

_commonDashboardView({
  Color? color,

  required String icon,
  required String title,
  subtitle,
  required String value,
}) {
  return Container(
    width: 140,
    margin: EdgeInsets.all(5),
    padding: const EdgeInsets.all(16),
    decoration: commonBoxDecoration(
      color: color?.withValues(alpha: 0.05) ?? colorLogo.withValues(alpha: 0.1),

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
          color: colorText,
        ),
        commonText(text: subtitle, fontSize: 12, color: colorTextDesc),
        const SizedBox(height: 8),
        commonText(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorText,
        ),
      ],
    ),
  );
}

homeGraphView() {
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
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0), // hide bottom line
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 35,
                  axisLine: const AxisLine(width: 0), // hide right side line
                  interval: 10,
                  majorGridLines: const MajorGridLines(dashArray: <double>[5, 5]),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  header: '',
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
}

commonTopProductListView(){
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
          commonText(text: "See All",color: colorTextDesc)
        ],
      ),

      SizedBox(

        height: 210,
        child: Consumer<ProductProvider>(
            builder: (context,provider,child) {
              return commonListViewBuilder(
                padding: EdgeInsetsGeometry.zero,
                shrinkWrap: true,
                items: provider.filteredProducts,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index, data) {
                  final parts = data.inventory.split("for");
                  final left = "${parts[0]}for";
                  final right = parts.length > 1 ? parts[1].trim() : "";

                  return Center(
                    child: Container(
                      decoration: commonBoxDecoration(
                          borderColor: colorBorder
                      ),
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(

                                width: double.infinity,

                                height: 140,
                                clipBehavior: Clip.antiAlias,
                                decoration: commonBoxDecoration(borderRadius: 10),
                                child: Image.network(fit: BoxFit.cover, data.icon),
                              ),
                              Positioned(
                                  bottom: 3,
                                  right: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                    decoration: commonBoxDecoration(
                                      borderRadius: 5,
                                      color: provider
                                          .getStatusColor(data.status)
                                          .withValues(alpha: 1),
                                    ),
                                   height: 30,
                                    child: Center(
                                      child: commonText(text: data.status,   fontSize: 10,
                                        fontWeight: FontWeight.w600,),
                                    ),))
                            ],
                          ),
                          SizedBox(height: 8,),
                          commonText(text: data.name,fontWeight: FontWeight.w600),
                          SizedBox(height: 5,),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "$left ", // first part
                                  style: commonTextStyle(
                                    fontSize: 12,
                                    color: colorSale,
                                  ),
                                ),
                                TextSpan(
                                  text: right, // second part
                                  style: commonTextStyle(
                                    fontSize: 12,
                                    color: colorText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                },
              );
            }
        ),
      ),
    ],
  );
}
commonTopOrderListView(){
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
          commonText(text: "See All",color: colorTextDesc)
        ],
      ),

      SizedBox(

        height: 210,
        child: Consumer<ProductProvider>(
            builder: (context,provider,child) {
              return commonListViewBuilder(
                padding: EdgeInsetsGeometry.zero,
                shrinkWrap: true,
                items: provider.filteredProducts,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index, data) {
                  final parts = data.inventory.split("for");
                  final left = "${parts[0]}for";
                  final right = parts.length > 1 ? parts[1].trim() : "";

                  return Center(
                    child: Container(
                      decoration: commonBoxDecoration(
                          borderColor: colorBorder
                      ),
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(

                                width: double.infinity,

                                height: 140,
                                clipBehavior: Clip.antiAlias,
                                decoration: commonBoxDecoration(borderRadius: 10),
                                child: Image.network(fit: BoxFit.cover, data.icon),
                              ),
                              Positioned(
                                  bottom: 3,
                                  right: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                    decoration: commonBoxDecoration(
                                      borderRadius: 5,
                                      color: provider
                                          .getStatusColor(data.status)
                                          .withValues(alpha: 1),
                                    ),
                                    height: 30,
                                    child: Center(
                                      child: commonText(text: data.status,   fontSize: 10,
                                        fontWeight: FontWeight.w600,),
                                    ),))
                            ],
                          ),
                          SizedBox(height: 8,),
                          commonText(text: data.name,fontWeight: FontWeight.w600),
                          SizedBox(height: 5,),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "$left ", // first part
                                  style: commonTextStyle(
                                    fontSize: 12,
                                    color: colorSale,
                                  ),
                                ),
                                TextSpan(
                                  text: right, // second part
                                  style: commonTextStyle(
                                    fontSize: 12,
                                    color: colorText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                },
              );
            }
        ),
      ),
    ],
  );
}
