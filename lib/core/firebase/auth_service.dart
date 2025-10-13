import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/hive/app_config_cache.dart';

import '../../main.dart';
import '../../routes/app_routes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final contactUsCollection="contact_us";
  final orderFilterCollection="order_filter";
  final productCollection="product";
  final storesCollection="stores";
  late final String storeName; // 🔹 dynamic storeName accessible in all methods

  //--------------------------------------------------------------------------------------------common Collection Store Wise ------------------------------------------------------------
  Future<CollectionReference<Map<String, dynamic>>> getStoreSubCollection(
    String subCollection,
  ) async {
    final config = await AppConfigCache.loadConfig();
    final storeName = config['storeName'] ?? '';

    if (storeName.isEmpty) {
      throw Exception("Store name not found in config");
    }

    final collectionRef = _firestore
        .collection(storeName) // e.g. "merlettenyc-demo"
        .doc(
          subCollection,
        ) // optional — can also use a fixed document name like "root"
        .collection(subCollection); // e.g. "contact_us", "stores", "orders"

    return collectionRef;
  }

  //---------------------------------------------------------------------------------------------For store ------------------------------------------------------------

  //============================================contactUs==============================================================//
  Future<List<Map<String, dynamic>>> getAllContactList() async {
    try {
      final contactCollection = await getStoreSubCollection(contactUsCollection);

      final storeSnapshot = await contactCollection.get();

      final allContacts = storeSnapshot.docs.map((doc) {
        final data = doc.data();
        data["uid"] = doc.id; // add document ID
        return data;
      }).toList();

      print('Fetched ${allContacts.length} contact(s) from all stores');
      return allContacts; // ✅ return the list
    } catch (e) {
      throw Exception("Failed to fetch contacts: $e");
    }
  }

  Future<int?> getUnseenContactCount() async {
    final contactCollection = await getStoreSubCollection(contactUsCollection);

    try {
      // 🔹 Create aggregate query
      final aggregateQuery = contactCollection
          .where("isSeen", isEqualTo: false)
          .count();

      // 🔹 Await the result
      final snapshot = await aggregateQuery.get();

      final count = snapshot.count; // ✅ now it's defined
      print('Unseen contacts: $count');
      return count;
    } catch (e) {
      debugPrint("❌ Failed to fetch unseen count: $e");
      //_contactCount = 0;
    }
    return null;
  }

  Future<void> markAllAsSeen() async {
    try {
      WriteBatch batch = _firestore.batch();
      final contactCollection = await getStoreSubCollection(contactUsCollection);
      final querySnapshot = await contactCollection.get();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {"isSeen": true});
      }

      await batch.commit();
      debugPrint("✅ All contacts marked as seen");
    } catch (e) {
      debugPrint("❌ Failed to mark all as seen: $e");
    }
  }

  //============================================End==============================================================//

  //============================================Order Filter==============================================================//

  Future<List<Map<String, dynamic>>> getAllFilterOrderList() async {
    try {
      final contactCollection = await getStoreSubCollection(orderFilterCollection);

      final storeSnapshot = await contactCollection.get();

      final allContacts = storeSnapshot.docs.map((doc) {
        final data = doc.data();
        data["uid"] = doc.id; // add document ID
        return data;
      }).toList();

      print('Fetched ${allContacts.length} contact(s) from all stores');
      return allContacts; // ✅ return the list
    } catch (e) {
      throw Exception("Failed to fetch contacts: $e");
    }
  }


}
