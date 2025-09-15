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

class ProductProvider with ChangeNotifier {
  List<Product> products = [
    Product(
      icon:
          "https://www.neeknots.com/cdn/shop/files/NEEK002_7c4febb4-278c-4b0a-9e83-ad482c0fb5ab.jpg?v=1730814932&width=1240",
      name: "Alligator Soft Toy",
      status: "Draft",
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

  String _searchQuery = "";
  String _selectedCategory = "All";
  String _selectedStatus = "All";

  List<Product> get filteredProducts {
    return products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == "All" || p.category == _selectedCategory;

      final matchesStatus =
          _selectedStatus == "All" || p.status == _selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Draft":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
