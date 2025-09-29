import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neeknots/models/product_model.dart' hide Variants, Images;

import '../core/component/component.dart';
import '../main.dart';
import '../models/product_details_model.dart';
import '../service/api_config.dart';
import '../service/gloable_status_code.dart';
import '../service/network_repository.dart';

class ProductProvider with ChangeNotifier {
  var tetName = TextEditingController();
  var tetDesc = TextEditingController();
  var tetQty = TextEditingController();
  var tetPrice = TextEditingController();

  List<Images> productImages = [];

  //Girsh - 24-Sept-2025
  // dynamic controllers mapped by variant id
  final Map<int, TextEditingController> qtyControllers = {};
  final Map<int, TextEditingController> priceControllers = {};

  // initialize controllers based on variants

  void initializeVariantController(List<Variants>? variants) {
    qtyControllers.clear();
    priceControllers.clear();
    if (variants != null) {
      for (final v in variants) {
        final key = v.id ?? 0;

        qtyControllers[key] = TextEditingController(
          text: v.inventoryQuantity?.toString() ?? '',
        );
        priceControllers[key] = TextEditingController(text: v.price ?? '');
      }
    }
  }

  // dispose controllers to avoid memory leaks
  void disposeControllers() {
    for (final c in qtyControllers.values) {
      c.dispose();
    }
    for (final c in priceControllers.values) {
      c.dispose();
    }
    qtyControllers.clear();
    priceControllers.clear();
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  String _searchQuery = "";

  String get searchQuery => _searchQuery;
  String _selectedCategory = "All";
  String _selectedStatus = "All";

  // Expose current filter values
  String get selectedCategory => _selectedCategory;

  String get selectedStatus => _selectedStatus;

  List<Products> get filteredProducts {
    return _products.where((p) {
      final matchesSearch = p.title.toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      return matchesSearch;
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

    if (status == "all") {
      _lastId = null;
      _products.clear();
      getProductList(context: navigatorKey.currentContext!);
    } else {
      _lastId = null;
      _products.clear();
      getProductList(context: navigatorKey.currentContext!, status: status);
    }

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

  bool _hasMore = true;
  final int _limit = 100; // items per page
  bool get hasMore => _hasMore;
  List<Products> _products = [];

  List<Products> get products => _products;
  int? _lastId; // last fetched product ID
  int _currentPage = 0;
  int get currentPage => _currentPage;
  Future<void> getProductListPagination({
    int? limit,
    String? status,
    required BuildContext context,
    bool reset = false,
  }) async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;
    notifyListeners();

    try {
      final effectiveLimit = limit ?? _limit;

      if (reset) {
        _lastId = null;
        _products.clear();
        _hasMore = true;
        _currentPage = 0;
      }

      String url =
          '${ await ApiConfig.productsUrl}?limit=$effectiveLimit&order=id+asc';
      if (status != null && status.isNotEmpty) url += "&status=$status";
      if (_lastId != null) url += '&since_id=$_lastId';

      final response = await callGETMethod(url: url);

      if (globalStatusCode == 200) {
        final fetchedProducts =
            ProductModel.fromJson(json.decode(response)).products ?? [];

        if (fetchedProducts.isNotEmpty) {
          // Remove duplicates before adding
          final newItems = fetchedProducts
              .where((p) => !_products.any((e) => e.id == p.id))
              .toList();

          if (newItems.isNotEmpty) {
            _products.addAll(newItems);
            _lastId = newItems.last.id;
            _currentPage++;
            debugPrint("📄 Loaded page: $_currentPage");
            debugPrint("📦 Total items loaded: ${_products.length}");
          } else {
            // No new items → stop pagination
            _hasMore = false;
            debugPrint("✅ All products loaded, stopping pagination.");
          }
        } else {
          _hasMore = false;
          debugPrint("✅ No more products returned from API.");
        }
        // stop fetching if we have loaded all 278
        if (_products.length >= 278) {
          _hasMore = false;
          debugPrint("✅ Loaded all 278 products.");
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint("⚠️ Unexpected Error: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }


  Future<void> getProductList({
    int? limit,

    String? status,
    required BuildContext context,
  }) async {
    _isFetching = true;
    notifyListeners();

    try {
      final effectiveLimit = limit ?? _limit;

      String url =
          '${await ApiConfig.productsUrl}?limit=$effectiveLimit&order=id+asc';
      if (status != null && status.isNotEmpty) {
        final encodedTitle = "&status=$status";
        url += encodedTitle;
      }

      if (_lastId != null) {
        url += '&since_id=$_lastId';
      }

      final response = await callGETMethod(url: url);

      if (globalStatusCode == 200) {
        final fetchedProducts =
            ProductModel.fromJson(json.decode(response)).products ?? [];

        if (fetchedProducts.isEmpty || fetchedProducts.length < _limit) {
          _hasMore = false;
        }

        if (fetchedProducts.isNotEmpty) {
          if (_lastId == null /*|| searchTitle != null*/ ) {
            _products.clear();
          }
          _products.addAll(fetchedProducts);
          _lastId = fetchedProducts.last.id; // move cursor forward
        }

        notifyListeners();
      }
      _isFetching = false;
      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Unexpected Error: $e");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  void resetProducts() {
    _products = [];

    _hasMore = true;
    _lastId = null;
    notifyListeners();
  }

  ProductDetailsModel? _productDetailsModel;

  ProductDetailsModel? get productDetailsModel => _productDetailsModel;

  void setIsImageUpdating(bool val) {
    _isImageUpdating = val;
    notifyListeners();
  }

  Future<void> getProductById({required String productId}) async {
    try {
      final url = "${await ApiConfig.getImageUrl}/$productId.json";
      final response = await callGETMethod(url: url);
      if (globalStatusCode == 200) {
        final jsonData = json.decode(response);

        _productDetailsModel = ProductDetailsModel.fromJson(jsonData['product']);
      }
    } catch (e) {
      debugPrint("⚠️ Unexpected Error: $e");
    } finally {}
  }

  int _totalProductCount = 0;

  int get totalProductCount => _totalProductCount;

  Future<void> getTotalProductCount() async {
    _isFetching = true;
    notifyListeners();
    final response = await callGETMethod(url: await ApiConfig.totalProductUrl);

    if (globalStatusCode == 200) {
      final data = json.decode(response);

      _totalProductCount = data["count"] ?? 0;
      _isFetching = false;
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  Future<void> fetchImagesForProduct(ProductDetailsModel product) async {
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

    final urlString = "${await ApiConfig.baseUrl}/products/$productId/images.json";
    final bytes = await File(imagePath).readAsBytes();

    final base64Image = base64Encode(bytes);

    final response = await callPostMethodWithToken(
      body: {
        "image": {"attachment": base64Image},
      },
      url: urlString,
    );
    if (globalStatusCode == 200) {
      final data = json.decode(response);
      final imageJson = data["image"];
      if (imageJson != null) {
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
    _isImageUpdating = true;
    notifyListeners();
    final urlString =
        "${await ApiConfig.baseUrl}/products/$productId/images/$imageId.json";

    await callDeleteMethod(url: urlString);

    if (globalStatusCode == 200) {
      productImages.removeWhere((img) => img.id == imageId);

      if (currentIndex >= productImages.length && currentIndex > 0) {
        setCurrentIndex(productImages.length - 1); // ✅ Correct
      }
      _isImageUpdating = false;
      notifyListeners();
    } else {
      _isImageUpdating = false;
      notifyListeners();
    }
  }

  Future<void> updateProductById({
    String? title,
    String? description,
    required int productId,
    List<Map<String, dynamic>>? variants,
  }) async {
    final urlString = "${await ApiConfig.baseUrl}/products/$productId.json";

    final Map<String, dynamic> productData = {"id": productId};
    if (title != null) productData["title"] = title;
    if (description != null) productData["body_html"] = description;
    if (variants != null) productData["variants"] = variants;
    final _ = await callPutMethodWithToken(
      params: {"product": productData},
      url: urlString,
    );
    if (globalStatusCode == 200) {
    } else {}
  }

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  void setDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void clearDateRange() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }
}
