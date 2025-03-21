// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../config/app_routes.dart';
// import '../config/app_urls.dart';
// import 'shared_preferences_helper.dart';
//
// enum HttpMethod { GET, POST, PUT, PATCH, DELETE }
//
// class HttpsCalls {
//   final _ongoingRequests = <String, Future<http.Response>>{};
//   final Duration _timeoutDuration = const Duration(seconds: 20);
//   final int _maxRetries = 2;
//
//   Future<http.Response> _performRequest(
//     String key,
//     Future<http.Response> Function() request,
//   ) async {
//     if (_ongoingRequests.containsKey(key)) {
//       return _ongoingRequests[key]!;
//     }
//
//     for (int retryCount = 0; retryCount <= _maxRetries; retryCount++) {
//       try {
//         final responseFuture = request().timeout(_timeoutDuration);
//         _ongoingRequests[key] = responseFuture;
//         final response = await responseFuture;
//         _ongoingRequests.remove(key);
//         return response;
//       } on TimeoutException catch (e) {
//         if (retryCount == _maxRetries) {
//           _ongoingRequests.remove(key);
//           throw Exception('Request timed out after $_maxRetries retries: $e');
//         }
//         await Future.delayed(Duration(seconds: 2 * retryCount));
//       } catch (e, stackTrace) {
//         if (retryCount == _maxRetries) {
//           _ongoingRequests.remove(key);
//           throw Exception('Request failed after $_maxRetries retries: $e\n$stackTrace');
//         }
//         await Future.delayed(Duration(seconds: 2 * retryCount));
//       }
//     }
//
//     _ongoingRequests.remove(key);
//     throw Exception('Failed to perform request');
//   }
//
//   Future<Map<String, String>> _getDefaultHeaders() async {
//     final token = await SharedPreferencesService().readToken();
//     return {
//       HttpHeaders.contentTypeHeader: 'application/json',
//       HttpHeaders.acceptHeader: 'application/json',
//       if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
//     };
//   }
//
//   Future<http.Response> _sendRequest(
//     HttpMethod method,
//     String lControllerUrl, {
//     List<int>? body,
//   }) async {
//     final headers = await _getDefaultHeaders();
//     final url = Uri.parse(ApiUrls.baseAPIURL + lControllerUrl);
//
//     late http.Response response;
//     switch (method) {
//       case HttpMethod.GET:
//         response = await http.get(url, headers: headers);
//         break;
//       case HttpMethod.POST:
//         response = await http.post(url, headers: headers, body: body);
//         break;
//       case HttpMethod.PUT:
//         response = await http.put(url, headers: headers, body: body);
//         break;
//       case HttpMethod.PATCH:
//         response = await http.patch(url, headers: headers, body: body);
//         break;
//       case HttpMethod.DELETE:
//         response = await http.delete(url, headers: headers, body: body);
//         break;
//     }
//
//     if (response.statusCode == 401) {
//       Get.offAllNamed(AppRoutes.signInView);
//       throw Exception("Unauthorized access. Please log in.");
//     }
//
//     return response;
//   }
//
//   Future<http.Response> getApiHits(String lControllerUrl) {
//     return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.GET, lControllerUrl));
//   }
//
//   Future<http.Response> postApiHits(String lControllerUrl, List<int>? lUtfContent) {
//     return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.POST, lControllerUrl, body: lUtfContent));
//   }
//
//   Future<http.Response> putApiHits(String lControllerUrl, List<int> lUtfContent) {
//     return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.PUT, lControllerUrl, body: lUtfContent));
//   }
//
//   Future<http.Response> patchApiHits(String lControllerUrl, List<int> lUtfContent) {
//     return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.PATCH, lControllerUrl, body: lUtfContent));
//   }
//
//   Future<http.Response> deleteApiHits(String lControllerUrl, List<int>? lUtfContent) {
//     return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.DELETE, lControllerUrl, body: lUtfContent));
//   }
//
//   // Future<http.Response> _multipartRequest(
//   //   String lControllerUrl,
//   //   dynamic model, {
//   //   String? fileKey,
//   //   String? filePath,
//   // }) async {
//   //   final token = await SharedPreferencesService().readToken();
//   //   final url = Uri.parse(ApiUrls.baseAPIURL + lControllerUrl);
//   //   var request = http.MultipartRequest('POST', url);
//   //
//   //   request.headers.addAll({
//   //     HttpHeaders.contentTypeHeader: 'multipart/form-data',
//   //     HttpHeaders.acceptHeader: 'application/json',
//   //     if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
//   //   });
//   //
//   //   final modelJson = model.toJson();
//   //   modelJson.forEach((key, value) {
//   //     if (value is String || value is int || value is double) {
//   //       request.fields[key] = value.toString();
//   //     }
//   //   });
//   //
//   //   if (fileKey != null && filePath != null) {
//   //     var file = await http.MultipartFile.fromPath(fileKey, filePath);
//   //     request.files.add(file);
//   //   }
//   //
//   //   var streamedResponse = await request.send();
//   //   return await http.Response.fromStream(streamedResponse);
//   // }
//   //
//   // Future<http.Response> multipartApiHits(
//   //   String lControllerUrl,
//   //   dynamic model, {
//   //   String? fileKey,
//   //   String? filePath,
//   // }) {
//   //   return _performRequest(
//   //     lControllerUrl,
//   //     () => _multipartRequest(
//   //       lControllerUrl,
//   //       model,
//   //       fileKey: fileKey,
//   //       filePath: filePath,
//   //     ),
//   //   );
//   // }
// }
