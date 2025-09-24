import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neeknots/models/product_model.dart';

import '../core/component/component.dart';
import '../main.dart';
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


  Timer? _debounce;

  /*void setSearchQuery(String query) {
    _searchQuery = query;

    // 👉 Debounce to avoid multiple API calls on every keystroke
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchQuery.length >= 3) {
        _lastId = null;
        _products.clear();
        getProductList(
          context: navigatorKey.currentContext!,
          searchTitle: query,
        );
      } else if (_searchQuery.isEmpty) {
        // ✅ Agar clear kar diya, to normal list reload karo
        _lastId = null;
        _products.clear();
        getProductList(context: navigatorKey.currentContext!);
      }
    });

    notifyListeners();
  }*/
  /*void setSearchQuery(String query) {
    _searchQuery = query;

    // 👉 Debounce to avoid multiple API calls on every keystroke
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _lastId = null;
      _products.clear();

      // ✅ Call API even for short queries
      if (_searchQuery.isNotEmpty) {
        getProductList(
          context: navigatorKey.currentContext!,
          searchTitle: query,
        );
      } else {
        // ❌ Empty query → load normal list
        getProductList(context: navigatorKey.currentContext!);
      }
    });

    notifyListeners();
  }*/

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setStatus(String status) {
    print('=-====${status}');
    _selectedStatus = status;

    if (status == "all") {
      _lastId = null;
      _products.clear();
      getProductList(context: navigatorKey.currentContext!, status: null);
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
  final int _limit = 50; // items per page
  bool get hasMore => _hasMore;
  List<Products> _products = [];
  int? _lastId; // last fetched product ID
  List<Products> get products => _products;

  Future<void> getProductList({
    int? limit,

    String? status,
    required BuildContext context,
  }) async {
    _isFetching = true;
    notifyListeners();

    try {
      final effectiveLimit =
          limit ??
          _limit; // agar limit pass ho to use kare, warna default _limit

      String url =
          '${ApiConfig.productsUrl}?limit=$effectiveLimit&order=id+asc';

    /*  // 👉 Agar title search ho to query param add karo
      if (searchTitle != null && searchTitle.isNotEmpty) {
        // remove invalid special characters for Shopify search

        final encodedTitle = "&title=$searchTitle";
        url += encodedTitle;
      }*/
      if (status != null && status.isNotEmpty) {
        // remove invalid special characters for Shopify search

        final encodedTitle = "&status=$status";
        url += encodedTitle;
      }

      if (_lastId != null) {
        url += '&since_id=$_lastId';
      }
      print('==========${url}');
      final response = await callGETMethod(url: url);

      print('${json.decode(response)}');
      if (globalStatusCode == 200) {
        final fetchedProducts =
            ProductModel.fromJson(json.decode(response)).products ?? [];

        if (fetchedProducts.isEmpty || fetchedProducts.length < _limit) {
          _hasMore = false;
        }

        if (fetchedProducts.isNotEmpty) {
          if (_lastId == null /*|| searchTitle != null*/) {
            // 👉 Agar search kar rahe ho to purani list clear karna better hai
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
