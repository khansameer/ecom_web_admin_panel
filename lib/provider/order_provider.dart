import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots/models/order_model.dart';

import '../main.dart';
import '../service/api_config.dart';
import '../service/api_services.dart';

class Product {
  final String name;
  final String status;
  final String icon;
  final String inventory;
  final String category;

  Product({
    required this.name,
    required this.status,
    required this.icon,
    required this.inventory,
    required this.category,
  });
}

class OrderDetails {
  final String title;
  final String desc;
  final String image;

  final double qty;
  final double price;

  OrderDetails({
    required this.title,
    required this.desc,
    required this.image,
    required this.qty,
    required this.price,
  });
}

class OrdersProvider with ChangeNotifier {
  List<Product> products = [
    Product(
      name: "Alligator Soft Toy",
      status: "Draft",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK002_7c4febb4-278c-4b0a-9e83-ad482c0fb5ab.jpg?v=1730814932&width=1240",
      inventory: "14 in stock for 7 variants",
      category: "Dresses",
    ),
    Product(
      name: "Bat Soft Toy",
      status: "Draft",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK012_7b7f38dd-fba0-41b0-a8c5-06280866eb5a.jpg?v=1730814935&width=1240",
      inventory: "10 in stock for 5 variants",
      category: "Dresses",
    ),
    Product(
      name: "Bee Soft Toy",
      status: "Active",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK018_07e92d11-3b8f-4c56-8e1f-aa4318efc2a0.jpg?v=1730814939&width=1240",
      inventory: "1 in stock for 1 variant",
      category: "Tops",
    ),
    Product(
      name: "Cheetah Soft Toy",
      status: "Active",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK047_8006c9ce-49c4-4e2b-9cc0-4d9ddc1ed6f4.jpg?v=1730814956&width=1240",
      inventory: "0 in stock for 5 variants",
      category: "Shirts",
    ),
    Product(
      name: "Alligator Soft Toy",
      status: "Draft",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK002_7c4febb4-278c-4b0a-9e83-ad482c0fb5ab.jpg?v=1730814932&width=1240",
      inventory: "14 in stock for 7 variants",
      category: "Dresses",
    ),
    Product(
      name: "Bat Soft Toy",
      status: "Draft",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK012_7b7f38dd-fba0-41b0-a8c5-06280866eb5a.jpg?v=1730814935&width=1240",
      inventory: "10 in stock for 5 variants",
      category: "Dresses",
    ),
    Product(
      name: "Bee Soft Toy",
      status: "Active",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK018_07e92d11-3b8f-4c56-8e1f-aa4318efc2a0.jpg?v=1730814939&width=1240",
      inventory: "1 in stock for 1 variant",
      category: "Tops",
    ),
    Product(
      name: "Cheetah Soft Toy",
      status: "Active",
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK047_8006c9ce-49c4-4e2b-9cc0-4d9ddc1ed6f4.jpg?v=1730814956&width=1240",
      inventory: "0 in stock for 5 variants",
      category: "Shirts",
    ),
  ];




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

  List<OrderDetails> ordersDetails = [
    OrderDetails(
      title: "Addison Sweater Dress-Black",
      desc: "Black / Knit Dress / …",
      image:
          "https://cdn.shopify.com/s/files/1/0619/0216/0063/products/85K06C_BLACK_011revised_900x_a235d253-c8c1-4d63-aa8f-0749d908d125_40x40@3x.jpg?v=1659447430",
      qty: 1,
      price: 150,
    ),
    OrderDetails(
      title: "Addison Sweater Dress-Black",
      desc: "Black / Knit Dress / …",
      image:
          "https://cdn.shopify.com/s/files/1/0619/0216/0063/products/85K06C_BLACK_011revised_900x_a235d253-c8c1-4d63-aa8f-0749d908d125_40x40@3x.jpg?v=1659447430",
      qty: 1,
      price: 150,
    ),
    OrderDetails(
      title: "Addison Sweater Dress-Black",
      desc: "Black / Knit Dress / …",
      image:
          "https://cdn.shopify.com/s/files/1/0619/0216/0063/products/85K06C_BLACK_011revised_900x_a235d253-c8c1-4d63-aa8f-0749d908d125_40x40@3x.jpg?v=1659447430",
      qty: 1,
      price: 150,
    ),
    OrderDetails(
      title: "Addison Sweater Dress-Black",
      desc: "Black / Knit Dress / …",
      image:
          "https://cdn.shopify.com/s/files/1/0619/0216/0063/products/85K06C_BLACK_011revised_900x_a235d253-c8c1-4d63-aa8f-0749d908d125_40x40@3x.jpg?v=1659447430",
      qty: 1,
      price: 150,
    ),
    OrderDetails(
      title: "Addison Sweater Dress-Black",
      desc: "Black / Knit Dress / …",
      image:
          "https://cdn.shopify.com/s/files/1/0619/0216/0063/products/85K06C_BLACK_011revised_900x_a235d253-c8c1-4d63-aa8f-0749d908d125_40x40@3x.jpg?v=1659447430",
      qty: 1,
      price: 150,
    ),
  ];

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
      return matchesSearch  && matchesStatus;
    }).toList();
  }

  Future<void> getOrderList() async {
    _isFetching = true;
    notifyListeners();

    try {
      final response = await _service.callGetMethod(
        context: navigatorKey.currentContext!,
        url: ApiConfig.ordersUrl,
      );

      _orderModel = OrderModel.fromJson(json.decode(response));
      _isFetching = false;

      debugPrint('Orders count: ${_orderModel?.orders?.length}');
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      _orderModel = OrderModel(orders: []); // fallback empty list
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
