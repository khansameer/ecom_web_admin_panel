import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../core/component/component.dart';
import '../core/firebase/send_fcm_notification.dart';

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
  bool _isUpdated = false;

  bool get isUpdated => _isUpdated;

  void _setUpdating(bool val) {
    _isUpdated = val;
    notifyListeners();
  }



  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> get allUsers => _allUsers;
  List<Map<String, dynamic>> _filteredUsers = [];

  List<Map<String, dynamic>> get userData => _filteredUsers;

  String _searchQuery = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> fetchUsers() async {
    _setLoading(true);
    try {
      final querySnapshot = await _firestore.collection("stores").get();
      _allUsers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data["uid"] = doc.id;
        return data;
      }).toList();

      applySearch(_searchQuery); // Apply any current search
      _setLoading(false);
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
    _setLoading(false);
  }

  void applySearch(String query) {
    _searchQuery = query.toLowerCase();

    if (_searchQuery.isEmpty) {
      _filteredUsers = List.from(_allUsers);
    } else {
      _filteredUsers = _allUsers.where((user) {
        final name = user["name"]?.toString().toLowerCase() ?? "";
        final email = user["email"]?.toString().toLowerCase() ?? "";
        return name.contains(_searchQuery) || email.contains(_searchQuery);
      }).toList();
    }

    notifyListeners();
  }


  Future<void> updateUser({required String docId, String? token,}) async {
    _setUpdating(true);
    try {
      await FirebaseFirestore.instance.collection('stores').doc(docId).update({
        "name": tetFullName.text.trim(),
        "email": tetEmail.text.trim(),
        "mobile": tetPhone.text.trim(),
        "store_name": tetStoreName.text.trim(),
        "accessToken": tetAccessToken.text.trim(),
        "version_code": tetVersionCode.text.trim(),
        "logo_url": tetAppLogo.text.trim(),
        "website_url": tetWebsiteUrl.text.trim(),
        "active_status": _status,
      });

      if (token != null && token.isNotEmpty) {
        final payload = buildNotificationPayload(
          token: token,
          title: tetFullName.text.trim(),
          body: _status
              ? "Your account is activated, open the app"
              : "Your account has been deactivated, please contact support",
          data: {
            "category": "chat",
          },
        );
        await sendFCMNotification(bodyMap: payload);
      }

      fetchUsers();
      notifyListeners();
      _setUpdating(false);
    } catch (e) {
      debugPrint("Error updating user: $e");
      _setUpdating(false);
    }
  }

  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> get contacts => _contacts;
  Future<void> getAllContactList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection("contact_us").get();

      if (querySnapshot.docs.isEmpty) {
        _contacts = [];
      } else {
        _contacts = querySnapshot.docs.map((doc) {
          final data = doc.data();
          data["uid"] = doc.id; // add UID
          return data;
        }).toList();
      }
    } catch (e) {
      debugPrint("❌ Failed to fetch users: $e");
      _contacts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int _contactCount = 0;


  int get contactCount => _contactCount;


/*  Future<void> getContactUsCount() async {
    _isLoading = true;
    notifyListeners();

    try {
      final aggregateQuery =
      await _firestore.collection("contact_us").count().get();

      _contactCount = aggregateQuery.count??0;
    } catch (e) {
      debugPrint("❌ Failed to fetch count: $e");
      _contactCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }*/
  Future<void> getUnseenContactCount() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Sirf unseen contacts count karo
      final aggregateQuery = await _firestore
          .collection("contact_us")
          .where("isSeen", isEqualTo: false) // ✅ filter
          .count()
          .get();

      _contactCount = aggregateQuery.count ?? 0;
    } catch (e) {
      debugPrint("❌ Failed to fetch unseen count: $e");
      _contactCount = 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAllAsSeen() async {
    try {
      WriteBatch batch = _firestore.batch();

      // Sare contacts lekar unpe batch update lagao
      final querySnapshot = await _firestore.collection("contact_us").get();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {"isSeen": true});
      }

      await batch.commit();

      // Local list update bhi kar dete hain
      for (var c in _contacts) {
        c["isSeen"] = true;
      }
      notifyListeners();

      debugPrint("✅ All contacts marked as seen");
    } catch (e) {
      debugPrint("❌ Failed to mark all as seen: $e");
    }
  }
}
