import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neeknots/models/product_model.dart';

import '../core/component/component.dart';
import '../service/api_config.dart';

import '../service/gloable_status_code.dart';
import '../service/network_repository.dart';

class ProductProvider with ChangeNotifier {
  var tetName = TextEditingController();
  var tetDesc = TextEditingController();
  var tetQty = TextEditingController();
  var tetPrice = TextEditingController();

  //Girish - 23-sept
  List<Images> productImages = [];

  int _currentIndex = 0;

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

      final matchesStatus =
          _selectedStatus == "All" || p.status == _selectedStatus;

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

  bool _isFetching = false;
  bool _isImageUpdating = false;

  bool get isFetching => _isFetching;

  bool get isImageUpdating => _isImageUpdating;

  ProductModel? _productModel;

  ProductModel? get productModel => _productModel;

  clearProductData() {
    _productModel = null;
    notifyListeners();
  }

  Future<void> getProductList({
    int? limit,
    required BuildContext context,
  }) async {
    _isFetching = true;
    notifyListeners();

    try {
      final url = limit != null
          ? '${ApiConfig.productsUrl}?limit=$limit&order=updated_at+desc'
          :'${ApiConfig.productsUrl}?order=created_at+desc';

      final response = await callGETMethod(url: url);

      if (globalStatusCode == 200) {
        _productModel = ProductModel.fromJson(json.decode(response));

        notifyListeners();
      }
    } catch (e) {
      debugPrint("⚠️ Unexpected Error: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Products? _product;

  Products? get product => _product;

  Future<void> getProductDetail({required String productId}) async {
    _isFetching = true;
    notifyListeners();
    try {
      final url = "${ApiConfig.getImageUrl}/$productId.json";

      final response = await callGETMethod(url: url);
      if (globalStatusCode == 200) {
        _product = Products.fromJson(json.decode(response));
      }
    } catch (e) {
      debugPrint("⚠️ Unexpected Error: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  int _totalProductCount = 0;

  int get totalProductCount => _totalProductCount;

  Future<void> getTotalProductCount() async {
    _isFetching = true;
    notifyListeners();
    final response = await callGETMethod(url: ApiConfig.totalProductUrl);

    if (globalStatusCode == 200) {
      final data = json.decode(response);

      _totalProductCount = data["count"] ?? 0;
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  Future<void> fetchImagesForProduct(Products product) async {
    if (product.variants == null) return;

    _isFetching = true;
    notifyListeners();

    await Future.wait(
      product.variants!.map((item) async {
        item.imageUrl = await fetchProductImage(
          productId: item.productId ?? 0,
          variantId: item.id ?? 0,
        );
      }),
    );

    _isFetching = false;
    notifyListeners();
  }

  Future<void> uploadProductImage({
    required String imagePath,
    required int productId,
  }) async {
    _isImageUpdating = true;
    notifyListeners();

    final urlString = "${ApiConfig.baseUrl}/products/$productId/images.json";
    // read as bytes
    final bytes = await File(imagePath).readAsBytes();

    // convert to base64
    final base64Image = base64Encode(bytes);

    //Acapulco Dress-Navy
    final response = await callPostMethodWithToken(
      body: {
        "image": {"attachment": base64Image},
      },
      url: urlString,
    );

    if (globalStatusCode == 200) {
      final data = json.decode(response);
      final imageJson = data["image"];
      /*   if (imageJson != null) {
        final newImage = Images.fromJson(imageJson);

        // Add to list and refresh UI
        productImages.add(newImage);

        // Optional: jump to the newly added image
        setCurrentIndex(productImages.length - 1);

        _isImageUpdating = false;
        notifyListeners();
      }*/
      if (imageJson != null) {
        // Convert JSON → Images model
        final newImage = Images.fromJson(imageJson);

        productImages.add(newImage);
        _isImageUpdating = false;
        notifyListeners(); // ✅ UI refresh
      }
    } else {
      _isImageUpdating = false;
      notifyListeners();
    }
  }

  Future<void> deleteProductImage({
    required int imageId,
    required int productId,
    required ProductProvider provider,
  }) async {
    final urlString =
        "${ApiConfig.baseUrl}/products/$productId/images/$imageId.json";

      await callDeleteMethod(url: urlString);

    if (globalStatusCode == 200) {
      // Remove image from local list
      productImages.removeWhere((img) => img.id == imageId);

      // Adjust currentIndex if needed
      if (currentIndex >= productImages.length && currentIndex > 0) {
        setCurrentIndex(productImages.length - 1); // ✅ Correct
      }
    }
  }
}
