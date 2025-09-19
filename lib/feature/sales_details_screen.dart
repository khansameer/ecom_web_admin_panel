import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../core/component/animated_counter.dart';

class SalesDetailsScreen extends StatelessWidget {
  final int todaySales;

  const SalesDetailsScreen({super.key, required this.todaySales});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    /* final List<SalesData> salesData = [
      SalesData('Jan', 10),
      SalesData('Feb', 12),
      SalesData('Mar', 9),
      SalesData('Apr', 20),
      SalesData('May', 18),
      SalesData('Jun', 25),
      SalesData('Jul', 22),
      SalesData('Aug', 28),
      SalesData('Sep', 24),
      SalesData('Oct', 30),
      SalesData('Nov', 32),
      SalesData('Dec', 35),
    ];
*/
    final List<SalesData> salesTrend = [
      SalesData('Jan', 10),
      SalesData('Feb', 12),
      SalesData('Mar', 9),
      SalesData('Apr', 20),
      SalesData('May', 18),
      SalesData('Jun', 25),
      SalesData('Jul', 22),
      SalesData('Aug', 28),
      SalesData('Sep', 24),
      SalesData('Oct', 30),
      SalesData('Nov', 32),
      SalesData('Dec', 35),
    ];

    final List<SalesData> categoryWise = [
      SalesData('Electronics', 40),
      SalesData('Clothes', 30),
      SalesData('Grocery', 20),
      SalesData('Toys', 10),
    ];

    final List<RegionSales> regionWise = [
      RegionSales('North', 35, Colors.blue),
      RegionSales('South', 28, Colors.green),
      RegionSales('West', 22, Colors.orange),
      RegionSales('East', 15, Colors.purple),
    ];
    double lastMonth = salesTrend[salesTrend.length - 2].sales;
    double currentMonth = salesTrend.last.sales;
    bool isGrowing = currentMonth >= lastMonth;
    return commonScaffold(
      appBar: commonAppBar(
        title: "Sales Detail",
        context: context,
        centerTitle: true,
      ),
      body: commonAppBackground(
        child: Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with animated count
                  commonBoxView(
                    title: "Today Sales",
                    contentView: SizedBox(
                      width: size.width,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                isGrowing
                                    ? Icons.trending_up
                                    : Icons.trending_down,
                                color: isGrowing ? Colors.green : Colors.red,
                                size: 50,
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),

                          commonText(text: "+50% compared to yesterday"),
                          SizedBox(height: 10),
                          AnimatedCounter(
                            leftText: '',
                            endValue: todaySales,
                            duration: Duration(seconds: 2),
                            style: commonTextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                            prefix: "\$",
                            suffix: "m",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: commonBoxView(
                          title: "This Week",
                          contentView: _infoCard(
                            value: "\$120m",
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),

                      Expanded(
                        child: commonBoxView(
                          title: "This Month",
                          contentView: _infoCard(
                            value: "\$450m",
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  commonBoxView(
                    title: "Sales Summary",
                    contentView: SizedBox(
                      height: 250,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(labelFormat: '{value}m'),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          LineSeries<SalesData, String>(
                            dataSource: salesTrend,
                            xValueMapper: (SalesData data, _) => data.month,
                            yValueMapper: (SalesData data, _) => data.sales,
                            color: Colors.orange,
                            width: 3,
                            markerSettings: MarkerSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bar Chart (Category Wise Sales)
                  SizedBox(height: 20),
                  commonBoxView(
                    title: "Category Wise Sales (Bar Chart)",
                    contentView: SizedBox(
                      height: 250,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(labelFormat: '{value}%'),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          ColumnSeries<SalesData, String>(
                            dataSource: categoryWise,
                            xValueMapper: (SalesData data, _) => data.month,
                            yValueMapper: (SalesData data, _) => data.sales,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Pie Chart (Region Wise Sales)
                  commonBoxView(
                    title: "Region Wise Sales (Pie Chart)",
                    contentView: SizedBox(
                      height: 250,
                      child: SfCircularChart(
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                        ),
                        series: <CircularSeries>[
                          PieSeries<RegionSales, String>(
                            dataSource: regionWise,
                            xValueMapper: (RegionSales data, _) => data.region,
                            yValueMapper: (RegionSales data, _) => data.sales,
                            pointColorMapper: (RegionSales data, _) =>
                                data.color,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard({required String value, required Color color}) {
    return commonText(
      text: value,
      textAlign: TextAlign.center,
      color: color,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}

/*class SalesData {
  final String month;
  final double sales;
  SalesData(this.month, this.sales);
}*/
class RegionSales {
  final String region;
  final double sales;
  final Color color;

  RegionSales(this.region, this.sales, this.color);
}
