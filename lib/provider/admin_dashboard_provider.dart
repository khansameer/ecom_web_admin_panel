import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/feature/admin/model/AllUserModel.dart';
import 'package:neeknots/feature/admin/model/admin_contact_model.dart';
import 'package:neeknots/feature/admin/model/all_order_model.dart';
import 'package:neeknots/feature/admin/model/all_product_model.dart';
import 'package:neeknots/main.dart';

import '../feature/admin/model/all_store_room_model.dart';
import '../service/api_config.dart';
import '../service/gloable_status_code.dart';
import '../service/network_repository.dart';

class AdminDashboardProvider with ChangeNotifier {
  final tetFullName = TextEditingController();
  final tetEmail = TextEditingController();
  final tetPhone = TextEditingController();
  final tetCountryCodeController = TextEditingController();
  final tetStoreName = TextEditingController();
  final tetWebsiteUrl = TextEditingController();
  final tetAccessToken = TextEditingController();
  final tetVersionCode = TextEditingController();
  final tetAppLogo = TextEditingController();
  bool _status = false;

  bool get status => _status;

  void setStatus(bool value) {
    _status = value;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }




  List<Map<String, dynamic>> _allPendingRequest = [];

  List<Map<String, dynamic>> get allPendingRequest => _allPendingRequest;

  final List<Color> professionColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.yellow,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.grey,
    Colors.blueGrey,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.tealAccent,
    Colors.yellowAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
    Colors.limeAccent,
    Colors.amberAccent,
    Colors.deepOrangeAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.deepPurpleAccent,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.teal.shade200,
    Colors.yellow.shade200,
    Colors.pink.shade200,
    Colors.cyan.shade200,
    Colors.indigo.shade200,
    Colors.lime.shade200,
    Colors.amber.shade200,
    Colors.deepOrange.shade200,
  ];
  Map<String, Color> professionColorMap = {};

  Color getProfessionColor(String profession, int index) {
    if (!professionColorMap.containsKey(profession)) {
      // Assign color based on index (wrap around if > 50)
      professionColorMap[profession] =
          professionColors[index % professionColors.length];
    }
    return professionColorMap[profession]!;
  }

  int _selectedIndex = 0;
  String? _selectedSection;

  // Getters
  int get selectedIndex => _selectedIndex;

  String? get selectedSection => _selectedSection;


  // Methods
  void setSelectedStore(int index) {
    _selectedIndex = index;
    _selectedSection = null;
    notifyListeners();
  }

  void setSelectedSection(String? section) {
    _selectedSection = section;
    notifyListeners();
  }


  int usersCount = 0;
  int ordersCount = 0;
  int productsCount = 0;
  int contactsCount = 0;

  // Helper to get count by title
  int getCountForTitle(String title) {
    switch (title) {
      case "users":
        return usersCount;
      case "orders":
        return ordersCount;
      case "products":
        return productsCount;
      case "contacts":
        return contactsCount;
      default:
        return 0;
    }
  }

  AdminContactListModel? _adminContactModel;

  AdminContactListModel? get adminContactModel => _adminContactModel;

  Future<void> getAllContact({required String storeName}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        method: HttpMethod.GET,
        url: '${ApiConfig.getAllContact}?store_name=$storeName',
      );


      print('=globalStatusCode==${globalStatusCode}');
      print('=globalStatusCode==${ json.decode(response)}');
      if (globalStatusCode == 200) {
        _adminContactModel = AdminContactListModel.fromJson(
          json.decode(response),
        );
      } else {
        _adminContactModel?.contacts = [];
      }
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _adminContactModel?.contacts = [];
      notifyListeners();

    }
  }

  AllStoreNameModel? _allStoreNameModel;

  AllStoreNameModel? get allStoreNameModel => _allStoreNameModel;

  Future<void> getAllStoreName() async {
    _setLoading(true);
    try {
      final response = await callApi(
          method: HttpMethod.GET,
          url: ApiConfig.allStoreList);

      if (globalStatusCode == 200) {
        _allStoreNameModel = AllStoreNameModel.fromJson(json.decode(response));
      } else {
        _allStoreNameModel?.stores = [];
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _allStoreNameModel?.stores = [];
      notifyListeners();
      _setLoading(false);
      showCommonDialog(
          showCancel: false,
          confirmText: "Close",
          title: "Error", context: navigatorKey.currentContext!,content: errorMessage);

      rethrow;
    }
  }



  Future<void> countByAllStoreName({required String storeRoom}) async {
    _setLoading(true);
    notifyListeners();
    try {
      final response = await callApi(
        method: HttpMethod.GET,
        url: '${ApiConfig.storeWiseGetCount}?store_name=$storeRoom',
      );

      if (globalStatusCode == 200) {
        final data = json.decode(response);

        final Map<String, dynamic> rawCounts = data['counts'];
        productsCount = rawCounts['products'];
        contactsCount = rawCounts['contacts'];
        ordersCount = rawCounts['orders'];
        usersCount = rawCounts['users'];

      } else {
        productsCount = 0;
        contactsCount = 0;
        ordersCount = 0;
        usersCount = 0;

      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      productsCount = 0;
      contactsCount = 0;
      ordersCount = 0;
      usersCount = 0;
      notifyListeners();
      showCommonDialog(
          showCancel: false,
          confirmText: "Close",
          title: "Error", context: navigatorKey.currentContext!,content: errorMessage);
      _setLoading(false);
      rethrow;
    }
  }

  AllUserModel? _allUserModel;

  AllUserModel? get allUserModel => _allUserModel;

  Future<void> getAllUser({required String storeRoom}) async {
    _setLoading(true);
    notifyListeners();
    try {
      final response = await callApi(
        method: HttpMethod.GET,
        url: '${ApiConfig.getAllUser}?store_name=$storeRoom',
      );

      if (globalStatusCode == 200) {
        _allUserModel = AllUserModel.fromJson(json.decode(response));
      } else {
        _allUserModel?.users = [];
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      //_totalContactCount =0;
      _setLoading(false);
      _allUserModel?.users = [];
      notifyListeners();


    }
  }

  Future<void> updateUserDetails({
    required Map<String, dynamic> body,
    required String storeRoom,
  }) async {
    _setLoading(true);
    notifyListeners();
    try {
       await callApi(
        body: body,
         method: HttpMethod.PUT,
        url: ApiConfig.updateUserDetails,
      );

      if (globalStatusCode == 200) {
        getAllUser(storeRoom: storeRoom);
      }
      notifyListeners();
    } catch (e) {
      //_totalContactCount =0;
      _setLoading(false);
      rethrow;
    } finally {
      //_totalContactCount =0;
      _setLoading(false);
    }
  }

  AllProductModel? _allProductModel;

  AllProductModel? get allProductModel => _allProductModel;

  Future<void> getAllProduct({required String storeRoom}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        method: HttpMethod.GET,
        url: '${ApiConfig.getALlProduct}?store_name=$storeRoom',
      );

      if (globalStatusCode == 200) {
        _allProductModel = AllProductModel.fromJson(json.decode(response));
      } else {
        _allProductModel?.products = [];
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _allProductModel?.products = [];
      notifyListeners();
      _setLoading(false);

    }
  }

  AllOrderModel? _allOrderModel;

  AllOrderModel? get allOrderModel => _allOrderModel;

  Future<void> getAllOrder({required String storeRoom}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        method: HttpMethod.GET,
        url: '${ApiConfig.getAlOrder}?store_name=$storeRoom',
      );

      if (globalStatusCode == 200) {
        _allOrderModel = AllOrderModel.fromJson(json.decode(response));
      } else {
        _allOrderModel?.orders = [];
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _allOrderModel?.orders = [];
      notifyListeners();
      _setLoading(false);

    }
  }
  List<Map<String, dynamic>> get activeFilters {
    if (_allOrderModel?.orders == null || _allOrderModel?.orders?.isEmpty==true) {
      return [];
    }

    // Example: create filter options based on order status
    final statuses = _allOrderModel?.orders!=null?_allOrderModel!.orders!
        .map((o) => o.title ?? "Unknown")
        .toSet()
        .toList():[];

    return statuses.map((s) => {"title": s}).toList();
  }
  Future<bool> createOrder({
    required Map<String, dynamic> params,
    required String storeRoom,
  }) async {
    _setLoading(true);
    try {
      await callApi(
        body: params,

        method: HttpMethod.POST,
        url: ApiConfig.createOrder,
      );

      if (globalStatusCode == 200) {
        getAllOrder(storeRoom: storeRoom);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
     // showCommonDialog(title: "$e", context: navigatorKey.currentContext!);
      notifyListeners();
      _setLoading(false);

      return false;
    }
  }

  Future<bool> updateOrder({
    required Map<String, dynamic> params,
    required String storeRoom,
    required int orderID,
  }) async {
    _setLoading(true);
    try {
      await callApi(
        body: params,
        method: HttpMethod.PUT,
        url: '${ApiConfig.updateOrder}/$orderID',
      );

      if (globalStatusCode == 200) {
        getAllOrder(storeRoom: storeRoom);

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      //showCommonDialog(title: "${e}", context: navigatorKey.currentContext!);
      notifyListeners();
      _setLoading(false);

      return false;
    }
  }

  Future<void> deleteOrderByID({
    required String storeRoom,
    required int orderID,
  }) async {
    _setLoading(true);
    try {
       await callApi(
         method: HttpMethod.DELETE,
        url: '${ApiConfig.deleteOrderByID}/$orderID',
      );

      if (globalStatusCode == 200) {
        getAllOrder(storeRoom: storeRoom);
        notifyListeners();
      }
       _setLoading(false);
       notifyListeners();
    } catch (e) {
      _setLoading(false);
    }
  }


  // /users/update
}
