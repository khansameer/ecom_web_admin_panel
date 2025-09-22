import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots/models/customer_model.dart';

import '../core/component/component.dart';
import '../main.dart';
import '../service/api_config.dart';
import '../service/api_services.dart';
import '../service/gloable_status_code.dart';

class CustomerProvider with ChangeNotifier {
  Color getStatusColor(String status) {
    switch (status) {
      case "Subscribed":
        return Colors.green;

      default:
        return Colors.red;
    }
  }

  void reset() {
    _searchQuery = "";
    _statusFilter = "All";
    notifyListeners();
  }

  final _service = ApiService();
  bool _isFetching = false;

  bool get isFetching => _isFetching;
  int _totalCustomerCount = 0;

  int get totalCustomerCount => _totalCustomerCount;

  Future<void> getTotalCustomerCount() async {
    _isFetching = true;
    notifyListeners();
    final response = await _service.callGetMethod(
      context: navigatorKey.currentContext!,
      url: ApiConfig.totalCustomerUrl,
    );

    if (globalStatusCode == 200) {

      final data = json.decode(response);

      _totalCustomerCount = data["count"] ?? 0;
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  CustomerModel? _customerModel;

  CustomerModel? get customerModel => _customerModel;

  Future<void> getCustomerList() async {
    _isFetching = true;
    notifyListeners();
    final response = await _service.callGetMethod(
      context: navigatorKey.currentContext!,
      url: ApiConfig.customerUrl,
    );

    if (globalStatusCode == 200) {

      _customerModel = CustomerModel.fromJson(json.decode(response));
      //final customer = _customerModel?.customers ?? [];

     /* await Future.wait(customer.map((customer) async {
        customer.avatarUrl ??= await fetchCustomerImage(
            customerID: customer.id ?? 0,
            service: _service,
          );
      }));*/
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  String _searchQuery = "";
  String _statusFilter = "All"; // All, Active, Inactive

  List<Customer>? get customers {
    return _customerModel?.customers?.where((c) {
      final matchesSearch = c.firstName.toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesStatus =
          _statusFilter == "All" ||
          c.emailMarketingConsent?.state == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  String _selectedStatusFilter = "All";

  String get selectedStatusFilter => _selectedStatusFilter;

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    _statusFilter = status;
    notifyListeners();
  }
}
