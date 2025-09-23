import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neeknots/service/network_repository.dart';

import '../main.dart';

class ApiService {

  Future<String> callPostMethodApi({
    required Map<String, dynamic> body,
    required BuildContext context,
    required String url,
  }) async {
    // Internet check
   /* bool isConnected = await checkInternetConnection();

    if (!isConnected) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text("No internet connection")),
      );
      return "No internet connection";
    }
*/
    // API call
    var response = await callPostMethod(url, body);
    return response;
  }

  Future<String> callPostMethodApiWithToken({
    required Map<String, dynamic> body,
    required BuildContext context,
    required String url,
    Map<String, String>? headers,
  }) async {
    //bool isConnected = await checkInternetConnection();

    /*if (!isConnected) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text("No internet connection")),
      );
      return "No internet connection";
    }*/

    var response = await callPostMethodWithToken(
      url: url,
      params: body,
      headers: headers,
    );

    return response;
  }

  Future<String> callPutMethodApiWithToken({
    required Map<String, dynamic> body,
    required String url,
    required BuildContext context,
  }) async {
   /* bool isConnected = await checkInternetConnection();

    if (!isConnected) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text("No internet connection")),
      );
      return "No internet connection";
    }*/
    var response = await callPutMethodWithToken(url, body);
    return response;
  }

  Future<String> callPatchMethods({
    required Map<String, dynamic> body,
    required BuildContext context,
    required String url,
    String? token,
  }) async {
   /* bool isConnected = await checkInternetConnection();

    if (!isConnected) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text("No internet connection")),
      );
      return "No internet connection";
    }
*/
    var response = await callPatchMethod(url, body);
    return response;
  }

  Future<String> callGetMethod({
    required String url,
    String? key,
    required BuildContext context,
  }) async {
   // bool isConnected = await checkInternetConnection();

   /* if (!isConnected) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text("No internet connection")),
      );
      return "No internet connection";
    }*/
    // Start stopwatch before API call

    var response = await callGETMethod(url: url, key: key);
    // Stop stopwatch after API call

    return response;
  }

  Future<String> callDeleteMethods({
    required String url,
    String? key,
    required BuildContext context,
  }) async {
    debugPrint('callDeleteMethods  $url');
   /* bool isConnected = await checkInternetConnection();

    if (!isConnected) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text("No internet connection")),
      );
      return "No internet connection";
    }*/
    var response = await callDeleteMethod(url: url);

    return response;
  }
}
