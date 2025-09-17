import 'dart:io';

import 'package:flutter/material.dart';

class Product {
  final String name;
  final String status;
  final String icon;
  final String inventory;
  final String category;
  final double price; // ✅ Added price
  Product({
    required this.name,
    required this.status,
    required this.icon,
    required this.inventory,
    required this.category,
    required this.price, // ✅ Constructor
  });
}

class ProductProvider with ChangeNotifier {
  List<Product> products = [
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Alligator Soft Toy",
      status: "Draft",
      inventory: "14 in stock for 7 variants",
      category: "Dresses",
      price: 499.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK012.jpg",
      name: "Bat Soft Toy",
      status: "Draft",
      inventory: "10 in stock for 5 variants",
      category: "Dresses",
      price: 399.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK018.jpg",
      name: "Bee Soft Toy",
      status: "Active",
      inventory: "1 in stock for 1 variant",
      category: "Tops",
      price: 299.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK047.jpg",
      name: "Cheetah Soft Toy",
      status: "Active",
      inventory: "0 in stock for 5 variants",
      category: "Shirts",
      price: 599.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK055.jpg",
      name: "Dinosaur Soft Toy",
      status: "Draft",
      inventory: "8 in stock for 3 variants",
      category: "Toys",
      price: 699.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Elephant Soft Toy",
      status: "Active",
      inventory: "12 in stock for 6 variants",
      category: "Animals",
      price: 549.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK063.jpg",
      name: "Frog Soft Toy",
      status: "Draft",
      inventory: "7 in stock for 2 variants",
      category: "Animals",
      price: 349.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK070.jpg",
      name: "Giraffe Soft Toy",
      status: "Active",
      inventory: "5 in stock for 3 variants",
      category: "Animals",
      price: 799.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK090.jpg",
      name: "Hippo Soft Toy",
      status: "Draft",
      inventory: "9 in stock for 4 variants",
      category: "Animals",
      price: 459.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Iguana Soft Toy",
      status: "Active",
      inventory: "11 in stock for 5 variants",
      category: "Reptiles",
      price: 529.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK085.jpg",
      name: "Jaguar Soft Toy",
      status: "Draft",
      inventory: "3 in stock for 1 variant",
      category: "Cats",
      price: 679.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK090.jpg",
      name: "Koala Soft Toy",
      status: "Active",
      inventory: "6 in stock for 2 variants",
      category: "Animals",
      price: 399.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Lion Soft Toy",
      status: "Draft",
      inventory: "0 in stock for 4 variants",
      category: "Cats",
      price: 749.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Monkey Soft Toy",
      status: "Active",
      inventory: "15 in stock for 7 variants",
      category: "Animals",
      price: 459.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK115.jpg",
      name: "Narwhal Soft Toy",
      status: "Draft",
      inventory: "4 in stock for 2 variants",
      category: "Sea",
      price: 589.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK110.jpg",
      name: "Octopus Soft Toy",
      status: "Active",
      inventory: "2 in stock for 1 variant",
      category: "Sea",
      price: 329.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK115.jpg",
      name: "Penguin Soft Toy",
      status: "Draft",
      inventory: "8 in stock for 3 variants",
      category: "Sea",
      price: 479.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK120.jpg",
      name: "Quokka Soft Toy",
      status: "Active",
      inventory: "5 in stock for 2 variants",
      category: "Animals",
      price: 569.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK125.jpg",
      name: "Rabbit Soft Toy",
      status: "Draft",
      inventory: "13 in stock for 6 variants",
      category: "Animals",
      price: 389.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Shark Soft Toy",
      status: "Active",
      inventory: "9 in stock for 4 variants",
      category: "Sea",
      price: 629.0,
    ),
  ];
  List<Product> productsVariants = [
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Other",
      status: "Handbag",
      inventory: "14 in stock for 7 variants",
      category: "Dresses",
      price: 499.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Size",
      status: "OS",
      inventory: "14 in stock for 7 variants",
      category: "Dresses",
      price: 499.0,
    ),
  ];
  List<Product> productsDetails = [
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK002.jpg",
      name: "Alligator Soft Toy",
      status: "Draft",
      inventory: "14 in stock for 7 variants",
      category: "Dresses",
      price: 499.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK012.jpg",
      name: "Bat Soft Toy",
      status: "Draft",
      inventory: "10 in stock for 5 variants",
      category: "Dresses",
      price: 399.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK018.jpg",
      name: "Bee Soft Toy",
      status: "Active",
      inventory: "1 in stock for 1 variant",
      category: "Tops",
      price: 299.0,
    ),
    Product(
      icon: "https://www.neeknots.com/cdn/shop/files/NEEK047.jpg",
      name: "Cheetah Soft Toy",
      status: "Active",
      inventory: "0 in stock for 5 variants",
      category: "Shirts",
      price: 599.0,
    ),

  ];

  int _currentIndex = 0;

  List<Product> get images => productsDetails;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  String _searchQuery = "";
  String _selectedCategory = "All";
  String _selectedStatus = "All";

  // Expose current filter values
  String get selectedCategory => _selectedCategory;
  String get selectedStatus => _selectedStatus;

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
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }


  String _status = "Active";
  String get status => _status;

  void setFilter(String value) {
    _status = value;
    notifyListeners();
  }
  bool _isEdit = false;

  bool get isEdit => _isEdit;

  void toggleEdit() {
    _isEdit = !_isEdit;
    notifyListeners();
  }

  void setEdit(bool value) {
    _isEdit = value;
    notifyListeners();
  }

  void reset() {
    _searchQuery = "";
    _selectedCategory = "All";
    _selectedStatus = "All";
    _status = "Active";
    _isEdit = false;
    _currentIndex = 0;
    notifyListeners();
  }

  File? _imageFile;
  File? get imageFile => _imageFile;
  void setImageFilePath({required File img}) {
    _imageFile = img;
    notifyListeners();
  }

  void imagePathClear() {
    _imageFile = null;
    notifyListeners();
  }

  List<File> _imageFiles = [];
  List<File> get imageFiles => _imageFiles;

  void addImage(File file) {
    _imageFiles.add(file);
    notifyListeners();
  }

  void removeImage(int index) {
    _imageFiles.removeAt(index);
    notifyListeners();
  }

  String addProductStatus = "Active";
  String category = "Category 1";
}