import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/models/product_model.dart';

import '../service/api_config.dart';
import '../service/api_services.dart';
import '../service/gloable_status_code.dart';

class Product {
  final String name;
  final String status;
  final String icon;
  final String inventory;
  final String? desc;
  final String? qty;
  final String category;
  final double price; // ✅ Added price
  Product({
    required this.name,
    required this.status,
    required this.icon,
    this.desc,
    this.qty,

    required this.inventory,
    required this.category,
    required this.price, // ✅ Constructor
  });
}

class ProductProvider with ChangeNotifier {
  var tetName = TextEditingController();
  var tetDesc = TextEditingController();
  var tetQty = TextEditingController();
  var tetPrice = TextEditingController();

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

  List<Products>? get filteredProducts {
    return productModel?.products?.where((p) {
      final matchesSearch = p.title.toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      /*    final matchesCategory =
          _selectedCategory == "All" || p.status == _selectedCategory;
*/
      final matchesStatus =
          _selectedStatus == "All" || p.status == _selectedStatus;

      //return matchesSearch && matchesCategory && matchesStatus;
      return matchesSearch && matchesStatus;
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
    _imageFiles.clear();
    tetName.clear();
    tetDesc.clear();
    tetPrice.clear();
    tetQty.clear();
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

  //--------------------------------------------------------------API Calling -----------------------------------------------------

  final _service = ApiService();
  bool _isFetching = false;

  bool get isFetching => _isFetching;
  ProductModel? _productModel;

  ProductModel? get productModel => _productModel;

  Future<void> getProductList() async {
    _isFetching = true;
    notifyListeners();
    final response = await _service.callGetMethod(
      context: navigatorKey.currentContext!,
      url: ApiConfig.productsUrl,
    );

    if (globalStatusCode == 200) {
      _productModel = ProductModel.fromJson(json.decode(response));
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  Future<void> uploadProductImage({required String imagePath}) async {
    final urlString = "${ApiConfig.baseUrl}/products/7313811701951/images.json";
    // read as bytes
    final bytes = await File(imagePath).readAsBytes();

    // convert to base64
    final base64Image = base64Encode(bytes);

    //Acapulco Dress-Navy
    final response = await _service.callPostMethodApiWithToken(
      body: {
        "image": {"attachment": base64Image},
      },
      url: urlString,
      context: navigatorKey.currentContext!,
    );

    print("Upload response:- $response");
  }
}
