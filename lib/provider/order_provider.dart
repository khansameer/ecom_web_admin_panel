import 'package:flutter/material.dart';
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
class Order {
  final String orderId;
  final String customerName;
  final List<Product> products;
  final double totalAmount;
  final String status;
  final DateTime date;

  Order({
    required this.orderId,
    required this.customerName,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.date,
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

  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;
  //List<Order> get orders => _orders;

  OrdersProvider() {
    _loadOrders();
  }

  String _searchQuery = "";
  String _statusFilter = "All";


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
  void _loadOrders() {
    _orders = [
      Order(
        orderId: "ORD001",
        customerName: "Rahul Sharma",
        products: [products[0], products[2]],
        totalAmount: 1200.0,
        status: "Pending",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      Order(
        orderId: "ORD002",
        customerName: "Neha Verma",
        products: [products[1]],
        totalAmount: 650.0,
        status: "Shipped",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      Order(
        orderId: "ORD003",
        customerName: "Amit Singh",
        products: [products[3], products[2]],
        totalAmount: 1800.0,
        status: "Delivered",
        date: DateTime.now().subtract(Duration(days: 5)),
      ),
      Order(
        orderId: "ORD001",
        customerName: "Rahul Sharma",
        products: [products[0], products[2]],
        totalAmount: 1200.0,
        status: "Pending",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      Order(
        orderId: "ORD002",
        customerName: "Neha Verma",
        products: [products[1]],
        totalAmount: 650.0,
        status: "Shipped",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      Order(
        orderId: "ORD003",
        customerName: "Amit Singh",
        products: [products[3], products[2]],
        totalAmount: 1800.0,
        status: "Delivered",
        date: DateTime.now().subtract(Duration(days: 5)),
      ),
      Order(
        orderId: "ORD001",
        customerName: "Rahul Sharma",
        products: [products[0], products[2]],
        totalAmount: 1200.0,
        status: "Pending",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      Order(
        orderId: "ORD002",
        customerName: "Neha Verma",
        products: [products[1]],
        totalAmount: 650.0,
        status: "Shipped",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      Order(
        orderId: "ORD003",
        customerName: "Amit Singh",
        products: [products[3], products[2]],
        totalAmount: 1800.0,
        status: "Delivered",
        date: DateTime.now().subtract(Duration(days: 5)),
      ),
      Order(
        orderId: "ORD001",
        customerName: "Rahul Sharma",
        products: [products[0], products[2]],
        totalAmount: 1200.0,
        status: "Pending",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      Order(
        orderId: "ORD002",
        customerName: "Neha Verma",
        products: [products[1]],
        totalAmount: 650.0,
        status: "Shipped",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      Order(
        orderId: "ORD003",
        customerName: "Amit Singh",
        products: [products[3], products[2]],
        totalAmount: 1800.0,
        status: "Delivered",
        date: DateTime.now().subtract(Duration(days: 5)),
      ),


    ];
    _applyFilters();
    notifyListeners();
  }
  void searchOrders(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  /// 🏷️ Filter by status (Pending, Shipped, Delivered, or All)
  void filterByStatus(String status) {
    _statusFilter = status;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredOrders = _orders.where((order) {
      bool matchesSearch = _searchQuery.isEmpty ||
          order.orderId.toLowerCase().contains(_searchQuery) ||
          order.customerName.toLowerCase().contains(_searchQuery) ||
          order.date.toString().toLowerCase().contains(_searchQuery);

      bool matchesStatus =
          _statusFilter == "All" || order.status == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();

    notifyListeners();
  }


  void resetFilters() {
    _searchQuery = "";
    _statusFilter = "All";
    _applyFilters();
  }

}