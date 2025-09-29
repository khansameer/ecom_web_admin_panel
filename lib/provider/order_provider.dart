import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/models/order_details_model.dart';
import 'package:neeknots/models/order_model.dart';
import 'package:neeknots/service/gloable_status_code.dart';
import 'package:neeknots/service/network_repository.dart';

import '../models/order_details_model.dart'
    as orderDetails
    show OrderDetailsModel;
import '../service/api_config.dart';

class OrdersProvider with ChangeNotifier {
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

  String get selectedStatus => _selectedStatus;

  /// 🏷️ Filter by status (Pending, Shipped, Delivered, or All)

  /*  void filterByStatus(String status) {
    String apiStatus = status.toLowerCase().replaceAll(' ', '_');
    if (status == "all") {
      getOrderList(financialStatus: null);
    } else {
      getOrderList(financialStatus: apiStatus);
    }

    _selectedStatus = status;
    notifyListeners();
    //_applyFilters();
  }*/

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  String _searchQuery = "";

  String get searchQuery => _searchQuery;

  //for filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  final int _limit = 100; // items per page

  // Store totals
  int totalPaid = 0;
  int totalPending = 0;
  int totalRefunded = 0;
  int totalShipping = 0;
  int totalCancel = 0;
  String selectedTab = "Paid";
  List<Order> filterTotalOrderList = [];

  void setSelectedTab(String tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void resetData() {
    filterOrderList.clear();
    _searchQuery = "";

    totalPaid = totalPending = totalRefunded = totalShipping = totalCancel = 0;
    notifyListeners();
  }

  Map<String, List<Order>> _ordersByStatus = {};

  Map<String, List<Order>> get ordersByStatus => _ordersByStatus;

  // selected tab orders
  List<Order> get selectedOrders =>
      _ordersByStatus[selectedTab.toLowerCase()] ?? [];

  Future<void> orderCountStatusValue({
    int? limit,
    String? financialStatus,
  }) async {
    _isFetching = true;
    notifyListeners();
    final effectiveLimit = limit ?? _limit;

    try {
      String url =
          '${await ApiConfig.ordersUrl}?status=any&limit=$effectiveLimit&order=id+asc';
      if (financialStatus != null && financialStatus.isNotEmpty) {
        final encodedTitle = "&financial_status=$financialStatus";
        url += encodedTitle;
      }

      final response = await callGETMethod(url: url);
      if (globalStatusCode == 200) {
        final data = json.decode(response); // ✅ now .body works

        final fetchedOrders = OrderModel.fromJson(data).orders ?? [];

        totalPaid = fetchedOrders
            .where((e) => e.financialStatus?.toLowerCase() == 'paid')
            .length;
        totalPending = fetchedOrders
            .where((e) => e.financialStatus?.toLowerCase() == 'pending')
            .length;
        totalRefunded = fetchedOrders
            .where((e) => e.financialStatus?.toLowerCase() == 'refunded')
            .length;
        totalShipping = fetchedOrders
            .where((e) => e.financialStatus?.toLowerCase() == 'shipping')
            .length;
        totalCancel = fetchedOrders
            .where((e) => e.financialStatus?.toLowerCase() == 'cancelled')
            .length;
        _ordersByStatus.clear(); // ✅ naya fetch hote hi purana clear karo
        for (var order in fetchedOrders) {
          final status = order.financialStatus?.toLowerCase() ?? 'unknown';
          _ordersByStatus.putIfAbsent(status, () => []);
          _ordersByStatus[status]!.add(order);
        }

        _isFetching = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  int _totalOrderCount = 0;

  int get totalOrderCount => _totalOrderCount;

 /* Future<void> getTotalOrderCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isFetching = true;
    notifyListeners();

    final response =  callGETMethod(
      url: '${ApiConfig.totalOrderUrl}?status=any',
    );

    if (globalStatusCode == 200) {
      final data = json.decode(await response);

      _totalOrderCount = data["count"] ?? 0;
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }*/


  Future<void> getTotalOrderCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isFetching = true;
    notifyListeners();

    final url = "${await ApiConfig.totalOrderUrl}?status=any";

    final response = await callGETMethod(url: url);

    if (globalStatusCode == 200) {
      final data = json.decode(await response);
      _totalOrderCount = data["count"] ?? 0;
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
    final url = "${await  ApiConfig.totalOrderUrl}?created_at_min=$createdAtMin&created_at_max=$createdAtMax";
    final response = await callGETMethod(
      url:
      url,
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

  clearOrderDetailsData() {
    _orderDetailsModel?.orderData = null;
    notifyListeners();
  }

  Future<void> getOrderById({int? orderID}) async {
    _isFetching = true;
    notifyListeners();

    try {
      final url = '${await ApiConfig.getOrderById}/$orderID.json';

      final response = await callGETMethod(url: url);

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

  //Girish 25-Sep
  final List<Order> _customerOrders = [];

  List<Order> get customerOrders => _customerOrders;

  List<Order> get filterCustomerOrderList {
    return _customerOrders.where((p) {
      final matchesSearch = p.name.toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      //return matchesSearch && matchesCategory && matchesStatus;
      return matchesSearch;
    }).toList();
  }

  Future<void> getOrdersByCustomerId({required String customerId}) async {
    _customerOrders.clear();
    _isFetching = true;
    notifyListeners();

    try {
      final url =
          '${await ApiConfig.getCustomerImage}/$customerId/orders.json?status=any';
      final response = await callGETMethod(url: url);
      if (globalStatusCode == 200) {
        final data = json.decode(response);
        final fetchedOrders = OrderModel.fromJson(data).orders ?? [];
        if (fetchedOrders.isNotEmpty) {
          _customerOrders.addAll(fetchedOrders);
        } else {
          _customerOrders.clear();
        }
      }
    } catch (e) {
      _isFetching = false;
      notifyListeners();
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
    required bool isDashboard,
  }) async {
    _isFetching = true;
    _orderModelByDate = null;

    notifyListeners();

    final utcStart = startDate.toUtc();
    final utcEnd = endDate.toUtc();

    // Format as ISO 8601
    final createdAtMin = Uri.encodeComponent(utcStart.toIso8601String());
    final createdAtMax = Uri.encodeComponent(utcEnd.toIso8601String());
    final url = "${await ApiConfig.ordersUrl}?created_at_min=$createdAtMin&created_at_max=$createdAtMax";
    final response = await callGETMethod(
      url:
      url,
    );

    if (globalStatusCode == 200) {
      _orderModelByDate = OrderModel.fromJson(json.decode(response));

      if (isDashboard) {
        _totalOrderPrice = getTotalOrderPrice(
          _orderModelByDate ?? OrderModel(),
        );
      }

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
      isDashboard: false,
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

    getOrderByDate(isDashboard: false, startDate: startDate, endDate: endDate);
  }

  Future<Map<String, dynamic>> getOrderPagination({
    String? pageInfo,
    String? financialStatus,
    String? limit,
  }) async {
    final queryParams = {
      'limit': limit ?? '10',
      if (pageInfo != null)
        'page_info': pageInfo
      else if (financialStatus != null)
        'financial_status': financialStatus
      else
        'status': 'any',
    };

    final baseUrl = await ApiConfig.baseUrl;

    final uri = Uri.parse(
        "$baseUrl/orders.json"
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: await ApiConfig.getCommonHeaders(),
    );


    if (response.statusCode != 200) {
      throw Exception("Error fetching orders: ${response.body}");
    }

    final data = json.decode(response.body);

    final orders = (data['orders'] as List)
        .map((e) => Order.fromJson(e))
        .toList();
    String? nextPageInfo;
    final linkHeader = response.headers['link'];
    if (linkHeader != null) {
      final parts = linkHeader.split(',');
      for (var part in parts) {
        if (part.contains('rel="next"')) {
          final match = RegExp(r'page_info=([^&>]+)').firstMatch(part);
          if (match != null) {
            nextPageInfo = match.group(1);
          }
        }
      }
    }

    return {"orders": orders, "nextPageInfo": nextPageInfo};
  }

  void filterByStatus(String status) {
    String apiStatus = status.toLowerCase().replaceAll(' ', '_');
    if (status == "all") {
      getOrderList(loadMore: false, financialStatus: null);
    } else {
      getOrderList(loadMore: false, financialStatus: apiStatus);
    }

    _selectedStatus = status;
    notifyListeners();
    //_applyFilters();
  }

  String? _nextPageInfo;

  bool get hasMore => _nextPageInfo != null;

  List<Order> get ordersList => _ordersList;
  List<Order> _ordersList = [];

  Future<void> getOrderList({
    bool loadMore = false,
    String? financialStatus,
    String? limit,
  }) async {
    if (_isFetching) return;
    if (!loadMore) _ordersList.clear(); // clear only on initial load

    _isFetching = true;
    notifyListeners();

    try {
      final result = await getOrderPagination(
        financialStatus: financialStatus,
        limit: limit,
        pageInfo: loadMore ? _nextPageInfo : null,
      );

      if (loadMore) {
        _ordersList.addAll(result["orders"]);
      } else {
        _ordersList = result["orders"];
      }

      _nextPageInfo = result["nextPageInfo"];
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  List<Order> get filterOrderList {
    return ordersList.where((p) {
      final matchesSearch = p.name.toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      return matchesSearch;
    }).toList();
  }
}

class SalesData {
  final String orderNumber;
  final double totalPrice;

  SalesData({required this.orderNumber, required this.totalPrice});
}
