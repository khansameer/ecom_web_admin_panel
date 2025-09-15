
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SalesData {
  final String x;
  final double y;

  SalesData(this.x, this.y);
}
enum RequestStatus { pending, accepted, rejected }

class DashboardProvider with ChangeNotifier {
  int _currentIndex = 2;

  int get currentIndex => _currentIndex;

  String? _appbarTitle;

  String? get appbarTitle => _appbarTitle;
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  set isFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setAppBarTitle(String? value) {
    _appbarTitle = value;
    notifyListeners();
  }

  void resetTab() {
    _currentIndex = 0;
    notifyListeners();
  }

  String _filter = "Month";
  String get filter => _filter;

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  List<SalesData> get salesData {
    if (_filter == "Today") {
      return [
        SalesData("9 AM", 5),
        SalesData("12 PM", 12),
        SalesData("3 PM", 8),
        SalesData("6 PM", 15),
        SalesData("9 PM", 10),
      ];
    } else if (_filter == "Week") {
      return [
        SalesData("Mon", 10),
        SalesData("Tue", 15),
        SalesData("Wed", 20),
        SalesData("Thu", 13),
        SalesData("Fri", 25),
        SalesData("Sat", 18),
        SalesData("Sun", 22),
      ];
    } else {
      return [
        SalesData('Jan', 9),
        SalesData('Feb', 11),
        SalesData('Mar', 14),
        SalesData('Apr', 10),
        SalesData('May', 21),
        SalesData('Jun', 23),
        SalesData('Jul', 18),
        SalesData('Aug', 22),
        SalesData('Sep', 28),
        SalesData('Oct', 26),
        SalesData('Nov', 27),
        SalesData('Dec', 31),
      ];
    }
  }
}