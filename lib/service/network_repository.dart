import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:neeknots/core/validation/validation.dart';
import 'package:neeknots/main.dart';
import 'package:neeknots/service/api_config.dart';

import 'gloable_status_code.dart';

/*Future callPostMethod({
  required String url,
  required Map<String, dynamic> params,
  Map<String, String>? headers,
}) async {
  debugPrint('==Post Method==$url');
  try {
    final response = await http
        .post(
          Uri.parse(url),
          body: json.encode(params),
          headers: await ApiConfig.getCommonHeaders(),
        )
        .timeout(
          const Duration(seconds: 10),
        ); // Increased timeout for reliability

    return getResponse(response);
  } on SocketException {
    debugPrint('No Internet connection');
    return {
      'status': false,
      'message':
          'No Internet connection. Please check your network and try again.',
    };
  } on TimeoutException {
    debugPrint('Request timed out');
    return {
      'status': false,
      'message': 'Request timed out. Please try again later.',
    };
  } catch (e) {
    debugPrint('Unexpected error: $e');
    return {
      'status': false,
      'message': 'Something went wrong. Please try again.',
    };
  }
}

Future callPatchMethod(String url, Map<String, dynamic> body) async {
  debugPrint('==Patch Method==$url');
  try {
    final response = await http
        .patch(
          Uri.parse(url),
          body: utf8.encode(json.encode(body)),
          headers: await ApiConfig.getCommonHeaders(),
        )
        .timeout(const Duration(seconds: 10));

    return getResponse(response);
  } on SocketException {
    debugPrint('No Internet connection');
    return {
      'status': false,
      'message':
          'No Internet connection. Please check your network and try again.',
    };
  } on TimeoutException {
    debugPrint('Request timed out');
    return {
      'status': false,
      'message': 'Request timed out. Please try again later.',
    };
  } catch (e) {
    debugPrint('Unexpected error: $e');
    return {
      'status': false,
      'message': 'Something went wrong. Please try again.',
    };
  }
}

Future callPostMethodWithToken({
  required String url,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
}) async {
  debugPrint('==Post Method==$url');
  try {
    final response = await http
        .post(
          Uri.parse(url),
          body: utf8.encode(json.encode(body)),
          headers: headers ?? await ApiConfig.getCommonHeaders(),
        )
        .timeout(const Duration(seconds: 10)); // timeout

    return getResponse(response);
  } on SocketException {
    debugPrint('No Internet connection');
    return {
      'status': false,
      'message':
          'No Internet connection. Please check your network and try again.',
    };
  } on TimeoutException {
    debugPrint('Request timed out');
    return {
      'status': false,
      'message': 'Request timed out. Please try again later.',
    };
  } catch (e) {
    debugPrint('Unexpected error: $e');
    return {
      'status': false,
      'message': 'Something went wrong. Please try again.',
    };
  }
}

Future callPutMethodWithToken({
  required String url,
  required Map<String, dynamic> params,
}) async {
  final uri = Uri.parse(url);
  debugPrint('==PUT Method==$url');

  try {
    final response = await http
        .put(
          uri,
          body: jsonEncode(params),
          headers: await ApiConfig.getCommonHeaders(),
        )
        .timeout(const Duration(seconds: 30));

    return getResponse(response);
  } on SocketException {
    debugPrint('No Internet connection');
    return {
      'status': false,
      'message':
          'No Internet connection. Please check your network and try again.',
    };
  } on TimeoutException {
    debugPrint('Request timed out');
    return {
      'status': false,
      'message': 'Request timed out. Please try again later.',
    };
  } catch (e) {
    debugPrint('Unexpected error: $e');
    return {
      'status': false,
      'message': 'Something went wrong. Please try again.',
    };
  }
}

Future callDeleteMethod({
  required String url,
  Map<String, dynamic>? params,
}) async {
  debugPrint('==Delete Method==$url');

  try {
    final request = http.Request("DELETE", Uri.parse(url));
    request.headers.addAll(await ApiConfig.getCommonHeaders());

    if (params != null) {
      request.body = json.encode(params);
    }

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final response = await http.Response.fromStream(streamedResponse);

    return getResponse(response);
  } on SocketException {
    debugPrint('No Internet connection');
    return {
      'status': false,
      'message':
          'No Internet connection. Please check your network and try again.',
    };
  } on TimeoutException {
    debugPrint('Request timed out');
    return {
      'status': false,
      'message': 'Request timed out. Please try again later.',
    };
  } catch (e) {
    debugPrint('Unexpected error: $e');
    return {
      'status': false,
      'message': 'Something went wrong. Please try again.',
    };
  }
}

Future callGETMethod({
  required String url,
  Map<String, String>? queryParams,
  String? key,
}) async {
  final uri = Uri.parse(url).replace(queryParameters: queryParams);
  debugPrint('==GET Method==$url');

  try {
    final response = await http
        .get(uri, headers: await ApiConfig.getCommonHeaders())
        .timeout(const Duration(seconds: 30)); // timeout

    return getResponse(response);
  } on SocketException {
    debugPrint('No Internet connection');
    return {
      'status': false,
      'message':
          'No Internet connection. Please check your network and try again.',
    };
  } on TimeoutException {
    debugPrint('Request timed out');
    return {
      'status': false,
      'message': 'Request timed out. Please try again later.',
    };
  } catch (e) {
    debugPrint('Unexpected error: $e');
    return {
      'status': false,
      'message': 'Something went wrong. Please try again.',
    };
  }
}*/

enum HttpMethod { GET, POST, PUT, PATCH, DELETE }

Future callApi({
  required String url,
  HttpMethod method = HttpMethod.GET,
  Map<String, dynamic>? body,
  Map<String, String>? headers,
  Map<String, String>? queryParams,
  Duration timeout = const Duration(seconds: 30),
}) async {
  try {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final requestHeaders = headers ?? await ApiConfig.getCommonHeaders();

    late http.Response response;

    switch (method) {
      case HttpMethod.GET:
        response =
        await http.get(uri, headers: requestHeaders).timeout(timeout);
        break;
      case HttpMethod.POST:
        response = await http
            .post(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.PUT:
        response = await http
            .put(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.PATCH:
        response = await http
            .patch(uri, headers: requestHeaders, body: jsonEncode(body ?? {}))
            .timeout(timeout);
        break;
      case HttpMethod.DELETE:
        if (body != null) {
          final request = http.Request("DELETE", uri);
          request.headers.addAll(requestHeaders);
          request.body = jsonEncode(body);
          final streamedResponse = await request.send().timeout(timeout);
          response = await http.Response.fromStream(streamedResponse);
        } else {
          response =
          await http.delete(uri, headers: requestHeaders).timeout(timeout);
        }
        break;
    }

    return getResponse(response);
  } on SocketException {
    errorMessage =
    "No Internet connection. Please check your network and try again.";
    //_showErrorDialog(errorMessage ?? '');
    return {
      'status': false,
      'message': errorMessage
    };
  } on TimeoutException {
    errorMessage = "Request timed out. Please try again later.";
    //_showErrorDialog(errorMessage ?? '');
    return {
      'status': false,
      'message': errorMessage
    };
  } catch (e) {
    errorMessage = "Something went wrong. Please try again.";
    //_showErrorDialog(errorMessage ?? '');
    return {
      'status': false,
      'message': errorMessage
    };
  }
}

Future getResponse(Response response) async {
  globalStatusCode = response.statusCode;

  if (globalStatusCode == 500 ||
      globalStatusCode == 502 ||
      globalStatusCode == 503) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"false\",\"message\":\"Internal server issue\"}";
  } else if (globalStatusCode == 401) {
    final parsedJson = jsonDecode(response.body.toString());
    final message = parsedJson['message'].toString();
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"false\",\"message\":\"$message\"}";
  } else if (globalStatusCode == 403) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"false\",\"message\":\"Internal server issue\"}";
  } else if (globalStatusCode == 405) {
    //assolyr
    String error = "This Method not allowed.";

    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"0\",\"message\":\"$error\"}";
  } else if (globalStatusCode == 400) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return response.body;
  } else if (globalStatusCode == 404) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"419\",\"message\":\"${errorMessage
        .toString()
        .replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";
    //return response.body;
  } else if (globalStatusCode == 419) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();

    return "{\"status\":\"false\",\"message\":\"${errorMessage
        .toString()
        .replaceAll(RegExp(r'[^\w\s]+'), '')}\"}";
    //return response.body;
  } else if (globalStatusCode == 422) {
    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();
    final message = parsedJson['message'].toString();
    return "{\"status\":\"false\",\"message\":\"${message.replaceAll(
        RegExp(r'[^\w\s]+'), '')}\"}";
  } else if (globalStatusCode == 204) {
    final parsedJson = jsonDecode(response.body.toString());
    final message = parsedJson['message'].toString();
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"false\",\"message\":\"${message.replaceAll(
        RegExp(r'[^\w\s]+'), '')}\"}";
  } else if (globalStatusCode < 200 || globalStatusCode > 404) {
    String error = response.headers['message'].toString();

    final parsedJson = jsonDecode(response.body.toString());
    errorMessage = parsedJson['message'].toString();
    return "{\"status\":\"0\",\"message\":\"$error\"}";
  }
  return response.body;
}

void _showErrorDialog(String message) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      );
    },
  );}