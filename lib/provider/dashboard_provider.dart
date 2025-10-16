import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/api_config.dart';
import '../service/network_repository.dart';


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

  String _filter = "Month";

  String get filter => _filter;

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  void resetTab() {
    _currentIndex = 0;
    _appbarTitle = null;
    _isFetching = false;
    _filter = "Month"; // 👈 default reset
    notifyListeners();
  }
  String? _name;

  String? get name => _name;

  void setName(String? value) {
    _name = value;
    notifyListeners();
  }
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }


  Future<void> updateFCMToken({required int id,required String token}) async {
    _setLoading(true);
    try {

      Map<String, dynamic> body={
        "fcm_token": token
      };
      final response = await callApi(
          method: HttpMethod.PUT,
          url:'${ApiConfig.authAPi}/$id/fcmToken',body:body);

      print('=updateFCMToken==${json.decode(response)}');
      
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
