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
                productId: item.productId ?? 0,
                variantId: item.variantId ?? 0,
                service: _service,
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

  Future<void> getTotalOrderCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
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

  int _totalOrderSaleCount = 0;

  int get totalOrderSaleCount => _totalOrderSaleCount;

  Future<void> getTotalSaleOrder({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _isFetching = true;
    notifyListeners();

    final utcStart = startDate.toUtc();
    final utcEnd = endDate.toUtc();

    // Format as ISO 8601
    final createdAtMin = Uri.encodeComponent(utcStart.toIso8601String());
    final createdAtMax = Uri.encodeComponent(utcEnd.toIso8601String());

    final response = await _service.callGetMethod(
      context: navigatorKey.currentContext!,
      url:
          '${ApiConfig.totalOrderUrl}?created_at_min=$createdAtMin&created_at_max=$createdAtMax',
    );

    if (globalStatusCode == 200) {
      final data = json.decode(response);

      _totalOrderSaleCount = data["count"] ?? 0;
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  OrderDetailsModel? _orderDetailsModel;

  OrderDetailsModel? get orderDetailsModel => _orderDetailsModel;

  Future<void> getOrderBYID({int? orderID}) async {
    _isFetching = true;
    notifyListeners();

    try {
      final url = '${ApiConfig.getOrderById}/$orderID.json';

      final response = await _service.callGetMethod(
        context: navigatorKey.currentContext!,
        url: url,
      );

      _orderDetailsModel = orderDetails.OrderDetailsModel.fromJson(
        json.decode(response),
      );

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
          service:
              _service, // if your fetchProductImage needs the service instance
        );
      }),
    );

    _isFetching = false;
    notifyListeners();
  }

  OrderModel? _orderModelByDate;

  OrderModel? get orderModelByDate => _orderModelByDate;
  double _totalOrderPrice = 0.0;

  double get totalOrderPrice => _totalOrderPrice;

  Future<void> getOrderByDate({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _isFetching = true;
    _orderModelByDate = null;
    _totalOrderPrice = 0;
    notifyListeners();

    final utcStart = startDate.toUtc();
    final utcEnd = endDate.toUtc();

    // Format as ISO 8601
    final createdAtMin = Uri.encodeComponent(utcStart.toIso8601String());
    final createdAtMax = Uri.encodeComponent(utcEnd.toIso8601String());

    final response = await _service.callGetMethod(
      context: navigatorKey.currentContext!,
      url:
          '${ApiConfig.ordersUrl}?created_at_min=$createdAtMin&created_at_max=$createdAtMax',
    );

    if (globalStatusCode == 200) {
      _orderModelByDate = OrderModel.fromJson(json.decode(response));
      _totalOrderPrice = getTotalOrderPrice(_orderModelByDate ?? OrderModel());
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  double getTotalOrderPrice(OrderModel orderModel) {
    double total = 0;

    if (orderModel.orders != null) {
      for (var order in orderModel.orders!) {
        // totalPrice String hai, so double me convert karo
        final price = double.tryParse(order.totalPrice ?? "0") ?? 0;
        total += price;
      }
    }

    return total;
  }


  //===============================================Graph
  String _selectedRange = "Today";

  String get selectedRange => _selectedRange;

  void setRange(String range) {
    _selectedRange = range;
    notifyListeners();
  }

  void fetchTodayOrders() {
    final today = DateTime.now();

    getOrderByDate(
      startDate: DateTime(today.year, today.month, today.day),
      endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
    );
  }

  void fetchByRange(String range) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    if (range == "Week") {
      startDate = now.subtract(
        Duration(days: now.weekday - 1),
      ); // start of week
    } else if (range == "Month") {
      startDate = DateTime(now.year, now.month, 1); // start of month
    } else {
      DateTime now = DateTime.now();

      // Aaj ka start (00:00:00)
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);

      // Aaj ka end (23:59:59)
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      //startDate = now; // default today
    }

    getOrderByDate(startDate: startDate, endDate: endDate);
  }
}
class SalesData {
  final String orderNumber;
  final double totalPrice;

  SalesData({required this.orderNumber, required this.totalPrice});
}
