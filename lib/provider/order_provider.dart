import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/models/order_details_model.dart';
import 'package:neeknots/models/order_model.dart';
import 'package:neeknots/service/gloable_status_code.dart';

import '../main.dart';
import '../models/order_details_model.dart' as orderDetails;
import '../service/api_config.dart';
import '../service/api_services.dart';

class OrdersProvider with ChangeNotifier {
  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.amber;
      case "Shipped":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }


  Color getPaymentStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.amber;
      case "Failed":
        return Colors.red;
      case "Paid":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _selectedStatus = "All";
  String _statusFilter = "All";

  String get selectedStatus => _selectedStatus;

  void resetFilters() {
    _searchQuery = "";
    _statusFilter = "All";
    //   _applyFilters();
  }

  /// 🏷️ Filter by status (Pending, Shipped, Delivered, or All)

  void filterByStatus(String status) {
    _statusFilter = status;
    _selectedStatus = status;
    notifyListeners();
    //_applyFilters();
  }

  final _service = ApiService();
  bool _isFetching = false;

  bool get isFetching => _isFetching;
  OrderModel? _orderModel;

  OrderModel? get orderModel => _orderModel;
  String _searchQuery = "";

  //for filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Order>? get filterOrderList {
    return orderModel?.orders?.where((p) {
      final matchesSearch = p.name.toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesStatus =
          _selectedStatus == "All" || p.financialStatus == _selectedStatus;

      //return matchesSearch && matchesCategory && matchesStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> getOrderList({int? limit}) async {
    _isFetching = true;
    notifyListeners();

    try {
      final url = limit != null
          ? '${ApiConfig.ordersUrl}?limit=$limit'
          : ApiConfig.ordersUrl;

      final response = await _service.callGetMethod(
        context: navigatorKey.currentContext!,
        url: url,
      );
      _orderModel = OrderModel.fromJson(json.decode(response));

      final orders = _orderModel?.orders ?? [];

      await Future.wait(
        orders.map(
          (order) => Future.wait(
            (order.lineItems ?? []).map((item) async {
              item.imageUrl = await fetchProductImage(
              productId:   item.productId ?? 0,
               variantId:  item.variantId ?? 0,
                service: _service
              );
            }),
          ),
        ),
      );

      _isFetching = false;

    } catch (e) {
      debugPrint('Error fetching orders: $e');
      _orderModel = OrderModel(orders: []); // fallback empty list
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  int _totalOrderCount = 0;

  int get totalOrderCount => _totalOrderCount;

  Future<void> getTotalOrderCount() async {
    _isFetching = true;
    notifyListeners();
    final response = await _service.callGetMethod(
      context: navigatorKey.currentContext!,
      url: ApiConfig.totalOrderUrl,
    );

    if (globalStatusCode == 200) {

      final data = json.decode(response);

      _totalOrderCount = data["count"] ?? 0;
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }


  OrderDetailsModel? _orderDetailsModel;

OrderDetailsModel? get orderDetailsModel => _orderDetailsModel;
  Future<void> getOrderBYID({int  ?orderID}) async {
    _isFetching = true;
    notifyListeners();

    try {
      final url = '${ ApiConfig.getOrderById}/$orderID.json';

      final response = await _service.callGetMethod(
        context: navigatorKey.currentContext!,
        url: url,
      );

      print('======================${json.decode(response)}');
      _orderDetailsModel = orderDetails. OrderDetailsModel.fromJson(json.decode(response));

      final orderData = _orderDetailsModel?.orderData;
      if (orderData != null && orderData.lineItems != null) {
        fetchImagesForProduct(product: orderData);
      }


      _isFetching = false;

    } catch (e) {
      debugPrint('Error fetching orders: $e');
      _orderDetailsModel = OrderDetailsModel(); // fallback empty list
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
  Future<void> fetchImagesForProduct({required OrderData product}) async {
    if (product.lineItems == null) return;

    _isFetching = true;
    notifyListeners();

    await Future.wait(
      product.lineItems!.map((item) async {
        item.imageUrl = await fetchProductImage(
          productId: item.productId ?? 0,
          variantId: item.id ?? 0,
          service: _service, // if your fetchProductImage needs the service instance
        );
      }),
    );

    _isFetching = false;
    notifyListeners();
  }
}
