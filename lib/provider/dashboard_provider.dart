
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RequestStatus { pending, accepted, rejected }

class DashboardProvider with ChangeNotifier {
  int _currentIndex = 0;

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


}