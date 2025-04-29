/// A Flutter package that auto-generates the LayerX directory structure for your project.
///
/// The `layerx_generator` package simplifies the setup of a scalable Flutter project by generating
/// a clean MVVM (Model-View-ViewModel) directory structure under `lib/app/`. It includes pre-configured
/// utilities for HTTP requests, local storage, location services, and API response handling, all integrated
/// with the GetX package for state management, navigation, and dependency injection.
///
/// ## Features
/// - Generates a well-organized MVVM directory structure.
/// - Includes pre-built services like `HttpsCalls`, `SharedPreferencesService`, `LocationService`, and `ApiResponseHandler`.
/// - Integrates with GetX for navigation and state management.
/// - Supports responsive design with `flutter_screenutil`.
/// - Provides a dynamic `ApiResponse` model for flexible API data parsing.
///
/// ## Usage
/// You can use this package via the command line or programmatically:
///
/// ### Command-Line
/// ```bash
/// dart run layerx_generator --path .
/// ```
///
/// ### Programmatically
/// ```dart
/// import 'package:layerx_generator/layerx_generator.dart';
/// import 'dart:io';
///
/// void main() async {
///   final generator = LayerXGenerator(Directory.current.path);
///   await generator.generate();
/// }
/// ```
///
/// See the [README](https://pub.dev/packages/layerx_generator) for more details.
library layerx_generator;

import 'dart:io';
import 'package:path/path.dart' as path;

/// A class that generates the LayerX directory structure for a Flutter project.
///
/// The `LayerXGenerator` class is the main entry point for the `layerx_generator` package.
/// It creates a predefined directory structure under `lib/app/`, including configuration files,
/// MVVM directories, services, and repositories, all integrated with GetX for state management
/// and navigation.
///
/// ## Example
/// ```dart
/// import 'package:layerx_generator/layerx_generator.dart';
/// import 'dart:io';
///
/// void main() async {
///   final generator = LayerXGenerator(Directory.current.path);
///   await generator.generate();
///   print('LayerX structure generated successfully!');
/// }
/// ```
class LayerXGenerator {
  /// The path to the Flutter project directory where the LayerX structure will be generated.
  final String projectPath;

  /// Creates a new instance of [LayerXGenerator].
  ///
  /// ## Parameters
  /// - [projectPath]: The path to the Flutter project directory. This must be a valid directory path.
  ///
  /// ## Throws
  /// - [Exception]: If the specified [projectPath] does not exist.
  LayerXGenerator(this.projectPath);

  /// Generates the LayerX directory structure and updates necessary files.
  ///
  /// This method creates the following structure under `lib/app/`:
  /// - `config/`: Configuration files (e.g., colors, routes, strings).
  /// - `mvvm/`: MVVM directories for models, views, and view models.
  /// - `repository/`: Repository directories for API and local data access.
  /// - `services/`: Pre-built services for HTTP requests, local storage, and error handling.
  /// - `widgets/`: Directory for custom widgets.
  ///
  /// It also updates:
  /// - `lib/app/app_widget.dart`: The root widget with GetX and `flutter_screenutil` integration.
  /// - `lib/main.dart`: The entry point to use the `LayerXApp` widget.
  /// - `pubspec.yaml`: Adds required dependencies.
  ///
  /// ## Throws
  /// - [Exception]: If the project directory does not exist or if there are issues creating directories/files.
  Future<void> generate() async {
    try {
      final projectDir = Directory(projectPath);
      if (!await projectDir.exists()) {
        throw Exception('Project directory does not exist: $projectPath');
      }

      final appDir = Directory(path.join(projectPath, 'lib', 'app'));
      await appDir.create(recursive: true);

      final directories = [
        'config',
        'mvvm/model/body_model',
        'mvvm/model/response_model',
        'mvvm/model/api_response_model',
        'mvvm/view',
        'mvvm/view_model',
        'repository/auth_repo',
        'repository/firebase',
        'repository/local_db',
        'repository/apis',
        'services',
        'widgets',
      ];

      for (final dir in directories) {
        final fullPath = path.join(appDir.path, dir);
        await Directory(fullPath).create(recursive: true);
        print('Created directory: $fullPath');
      }

      await _createConfigFiles(appDir.path);
      await _createModelFiles(appDir.path);
      await _createServiceFiles(appDir.path);
      await _createRepositoryFiles(appDir.path);
      await _createAppWidgetFile(projectPath);
      await _updateMainFile(projectPath);
      await _updatePubspecFile(projectPath);
    } catch (e) {
      print('Error generating LayerX structure: $e');
      rethrow;
    }
  }

  Future<void> _createConfigFiles(String appDirPath) async {
    final configDir = Directory(path.join(appDirPath, 'config'));

    await File(path.join(configDir.path, 'app_assets.dart')).writeAsString('''
class AppAssets {
  static const String imagesPath = 'assets/images';
  static const String bgImage = '\$imagesPath/bg_image.png';
}
''');

    await File(path.join(configDir.path, 'app_colors.dart')).writeAsString('''
import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();
  static const Color primary = Color(0xFF24B986);
  static const Color getStartedBg = Color(0xFF874070);
  static const Color blueColor = Color(0xFF3DDED0);
}
''');

    await File(path.join(configDir.path, 'app_enums.dart')).writeAsString('''
enum UserRole { USER, BUSINESS }
''');

    await File(path.join(configDir.path, 'app_routes.dart')).writeAsString('''
abstract class AppRoutes {
  AppRoutes._();
  static const splashView = '/splashView';
  static const signInView = '/signInView';
  static const loginView = '/loginView';
}
''');

    await File(path.join(configDir.path, 'app_pages.dart')).writeAsString('''
import 'package:get/get.dart';

abstract class AppPages {
  AppPages._();
  static final routes = <GetPage>[
    // Example route:
    // GetPage(name: AppRoutes.splashView, page: () => const SplashView()),
  ];
}
''');

    await File(path.join(configDir.path, 'app_strings.dart')).writeAsString('''
abstract class AppStrings {
  AppStrings._();
  static const welcomeText = 'Welcome to LayerX';
}
''');

    await File(path.join(configDir.path, 'app_urls.dart')).writeAsString('''
abstract class AppUrls {
  AppUrls._();
  static const String baseAPIURL = 'https://api.example.com/';
  static const String signup = 'auth/signup';
  static const String updateAccount = 'auth/update';
  static const String appSettings = 'settings';
}
''');

    await File(path.join(configDir.path, 'app_text_style.dart')).writeAsString('''
import 'package:flutter/material.dart';

abstract class AppTextStyles {
  AppTextStyles._();
  static TextStyle bodyText({Color? color}) {
    return TextStyle(fontSize: 16, color: color ?? Colors.black);
  }
}
''');

    await File(path.join(configDir.path, 'global_variable.dart')).writeAsString('''
class GlobalVariables {
  static List<String> errorMessages = [];
}
''');

    await File(path.join(configDir.path, 'padding_extensions.dart')).writeAsString('''
import 'package:flutter/material.dart';

extension PaddingExtension on Widget {
  Widget paddingAll(double padding) => Padding(padding: EdgeInsets.all(padding), child: this);
}
''');

    await File(path.join(configDir.path, 'utils.dart')).writeAsString('''
class Utils {
  static String formatDate(DateTime date) => date.toIso8601String();
}
''');

    await File(path.join(configDir.path, 'config.dart')).writeAsString('''
class AppConfig {
  static const String appName = 'LayerX App';
}
''');

    print('Created config files in config/');
  }

  Future<void> _createModelFiles(String appDirPath) async {
    final bodyModelDir = Directory(path.join(appDirPath, 'mvvm', 'model', 'body_model'));
    final responseModelDir = Directory(path.join(appDirPath, 'mvvm', 'model', 'response_model'));
    final apiResponseModelDir = Directory(path.join(appDirPath, 'mvvm', 'model', 'api_response_model'));

    await File(path.join(bodyModelDir.path, 'driver_signup_body_model.dart')).writeAsString('''
class DriverSignupBodyModel {
  String? name;
  String? email;
  File? image;
  List<File>? documents;
  File? details;

  DriverSignupBodyModel({this.name, this.email, this.image, this.documents, this.details});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
''');

    await File(path.join(bodyModelDir.path, 'garage_signup_body_model.dart')).writeAsString('''
class GarageSignupBodyModel {
  String? name;
  File? image;

  GarageSignupBodyModel({this.name, this.image});

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
''');

    await File(path.join(bodyModelDir.path, 'add_car_body_model.dart')).writeAsString('''
class AddCarBodyModel {
  String? model;
  File? image;
  File? insuranceDocument;
  File? inspectionDocument;
  File? registrationDocument;
  List<File>? additionalDocuments;

  AddCarBodyModel({
    this.model,
    this.image,
    this.insuranceDocument,
    this.inspectionDocument,
    this.registrationDocument,
    this.additionalDocuments,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
      };
}
''');

    await File(path.join(bodyModelDir.path, 'buy_car_request.dart')).writeAsString('''
class BuyCarRequestModel {
  String? carId;
  File? image;

  BuyCarRequestModel({this.carId, this.image});

  Map<String, dynamic> toJson() => {
        'car_id': carId,
      };
}
''');

    await File(path.join(responseModelDir.path, 'example_response_model.dart')).writeAsString('''
class ExampleResponseModel {
  String? field;

  ExampleResponseModel({this.field});

  factory ExampleResponseModel.fromJson(Map<String, dynamic> json) {
    return ExampleResponseModel(field: json['field'] as String?);
  }
}
''');

    await File(path.join(apiResponseModelDir.path, 'api_response.dart')).writeAsString('''
class ApiResponse<T> {
  final bool? success;
  final String? message;
  final int? code;
  final T? data;
  final String? token;

  ApiResponse({
    this.success,
    this.message,
    this.code,
    this.data,
    this.token,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    final status = json['status'];
    final success = json['success'];
    final isSuccess = success == true || status == 'success';

    final skipKeys = {'status', 'success', 'code', 'error', 'message', 'token'};
    dynamic extractedData;

    // First try 'data' if it exists
    if (json['data'] != null) {
      extractedData = json['data'];
    } else {
      // Otherwise try to find any nested Map or List not part of skipKeys
      for (final entry in json.entries) {
        if (!skipKeys.contains(entry.key) &&
            (entry.value is Map<String, dynamic> || entry.value is List)) {
          extractedData = entry.value;
          break;
        }
      }
    }

    return ApiResponse(
      success: isSuccess,
      message: json['message'] as String?,
      code: json['code'] as int?,
      data: extractedData != null ? fromJsonT(extractedData) : null,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data != null ? toJsonT(data as T) : null,
      'token': token,
    };
  }
}
''');

    print('Created model files in mvvm/model/');
  }

  Future<void> _createServiceFiles(String appDirPath) async {
    final servicesDir = Directory(path.join(appDirPath, 'services'));

    await File(path.join(servicesDir.path, 'https_calls.dart')).writeAsString('''
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_urls.dart';
import '../mvvm/model/body_model/driver_signup_body_model.dart';
import '../mvvm/model/body_model/garage_signup_body_model.dart';
import '../mvvm/model/body_model/add_car_body_model.dart';
import '../mvvm/model/body_model/buy_car_request.dart';
import 'shared_preferences_service.dart';

enum HttpMethod { GET, POST, PUT, PATCH, DELETE }

class HttpsCalls {
  final _ongoingRequests = <String, Future<http.Response>>{};
  final Duration _timeoutDuration = const Duration(seconds: 20);
  final int _maxRetries = 2;

  Future<http.Response> _performRequest(
    String key,
    Future<http.Response> Function() request,
  ) async {
    if (_ongoingRequests.containsKey(key)) {
      return _ongoingRequests[key]!;
    }
    for (int retryCount = 0; retryCount <= _maxRetries; retryCount++) {
      try {
        final responseFuture = request().timeout(_timeoutDuration);
        _ongoingRequests[key] = responseFuture;
        final response = await responseFuture;
        _ongoingRequests.remove(key);
        return response;
      } on TimeoutException catch (e) {
        if (retryCount == _maxRetries) {
          _ongoingRequests.remove(key);
          throw Exception('Request timed out after \$_maxRetries retries: \$e');
        }
        await Future.delayed(Duration(seconds: 2 * retryCount));
      } catch (e, stackTrace) {
        if (retryCount == _maxRetries) {
          _ongoingRequests.remove(key);
          throw Exception('Request failed after \$_maxRetries retries: \$e\\n\$stackTrace');
        }
        await Future.delayed(Duration(seconds: 2 * retryCount));
      }
    }
    _ongoingRequests.remove(key);
    throw Exception('Failed to perform request');
  }

  Future<Map<String, String>> _getDefaultHeaders() async {
    final token = await SharedPreferencesService().readToken();
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer \$token',
    };
  }

  Future<http.Response> _sendRequest(
    HttpMethod method,
    String lControllerUrl, {
    List<int>? body,
  }) async {
    final headers = await _getDefaultHeaders();
    final url = Uri.parse(AppUrls.baseAPIURL + lControllerUrl);
    switch (method) {
      case HttpMethod.GET:
        return await http.get(url, headers: headers);
      case HttpMethod.POST:
        return await http.post(url, headers: headers, body: body);
      case HttpMethod.PUT:
        return await http.put(url, headers: headers, body: body);
      case HttpMethod.PATCH:
        return await http.patch(url, headers: headers, body: body);
      case HttpMethod.DELETE:
        return await http.delete(url, headers: headers, body: body);
    }
  }

  Future<http.Response> getApiHits(String lControllerUrl) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.GET, lControllerUrl));
  }

  Future<http.Response> postApiHits(String lControllerUrl, List<int>? lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.POST, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> putApiHits(String lControllerUrl, List<int> lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.PUT, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> patchApiHits(String lControllerUrl, List<int> lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.PATCH, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> deleteApiHits(String lControllerUrl, List<int>? lUtfContent) {
    return _performRequest(lControllerUrl, () => _sendRequest(HttpMethod.DELETE, lControllerUrl, body: lUtfContent));
  }

  Future<http.Response> _genericMultipartRequest(
      String endpointUrl,
      dynamic model, {
        Map<String, dynamic Function()>? fileExtractors,
      }) async {
    final token = await SharedPreferencesService().readToken();
    final url = Uri.parse(AppUrls.baseAPIURL + endpointUrl);
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.acceptHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer \$token',
    });
    final json = model.toJson();
    json.forEach((key, value) {
      if (value != null && (value is String || value is num || value is bool)) {
        request.fields[key] = value.toString();
      }
    });
    if (fileExtractors != null) {
      for (var entry in fileExtractors.entries) {
        final key = entry.key;
        final value = entry.value();
        if (value is File) {
          request.files.add(await http.MultipartFile.fromPath(key, value.path));
        } else if (value is List<File>) {
          for (int i = 0; i < value.length; i++) {
            request.files.add(await http.MultipartFile.fromPath('\$key[\$i]', value[i].path));
          }
        }
      }
    }
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> multipartDriverProfileApiHits(
      String lControllerUrl,
      DriverSignupBodyModel profileMultipart,
      ) {
    return _performRequest(
      lControllerUrl,
          () => _genericMultipartRequest(
        lControllerUrl,
        profileMultipart,
        fileExtractors: {
          'image': () => profileMultipart.image,
          'documents': () => profileMultipart.documents,
          'details': () => profileMultipart.details,
        },
      ),
    );
  }

  Future<http.Response> multipartGarageProfileApiHits(
      String lControllerUrl,
      GarageSignupBodyModel profileMultipart,
      ) {
    return _performRequest(
      lControllerUrl,
          () => _genericMultipartRequest(
        lControllerUrl,
        profileMultipart,
        fileExtractors: {
          'image': () => profileMultipart.image,
        },
      ),
    );
  }

  Future<http.Response> multipartBuyCarRequestApi(
      String lControllerUrl,
      BuyCarRequestModel buyRequestMultipart,
      ) {
    return _performRequest(
      lControllerUrl,
          () => _genericMultipartRequest(
        lControllerUrl,
        buyRequestMultipart,
        fileExtractors: {
          'image': () => buyRequestMultipart.image,
        },
      ),
    );
  }

  Future<http.Response> crudCarMultipartApi(
      String lControllerUrl,
      AddCarBodyModel carDataModel,
      ) {
    return _performRequest(
      lControllerUrl,
          () => _genericMultipartRequest(
        lControllerUrl,
        carDataModel,
        fileExtractors: {
          'image': () => carDataModel.image,
          'insuranceDocument': () => carDataModel.insuranceDocument,
          'inspectionDocument': () => carDataModel.inspectionDocument,
          'registrationDocument': () => carDataModel.registrationDocument,
          'additionalDocuments': () => carDataModel.additionalDocuments,
        },
      ),
    );
  }
}
''');

    await File(path.join(servicesDir.path, 'shared_preferences_service.dart')).writeAsString('''
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SharedPreferencesService {
  static const String _keyDataModel = 'data_model';
  static const String _keyUserData = 'user_data';
  static const String _deviceToken = 'deviceToken';
  static const String _apiToken = 'apiToken';

  static final logger = Logger();

  Future<void> saveDeviceToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceToken, token);
  }

  Future<String?> readDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceToken);
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiToken, token);
  }

  Future<String?> readToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiToken);
  }

  Future<void> saveUserData(dynamic userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = json.encode(userData.toJson());
    await prefs.setString(_keyUserData, data);
  }

  Future<dynamic> readUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_keyUserData);
    if (data != null) {
      Map<String, dynamic> jsonData = json.decode(data);
      return jsonData;
    }
    return null;
  }

  Future<void> clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.clear();
    if (result) {
      logger.i('All SharedPreferences data cleared successfully.');
    } else {
      logger.e('Failed to clear SharedPreferences data.');
    }
  }
}
''');

    await File(path.join(servicesDir.path, 'json_extractor.dart')).writeAsString('''
import 'dart:convert';
import 'package:logger/logger.dart';
import '../config/global_variables.dart';

class MessageExtractor {
  final Logger _logger = Logger();

  void extractAndStoreMessage(String endPoint, String responseBody) {
    try {
      _logger.i("Api EndPoint: \$endPoint - Body: \$responseBody");

      final Map<String, dynamic> jsonMap = jsonDecode(responseBody);

      GlobalVariables.errorMessages.clear();

      if (jsonMap['errors'] is List) {
        GlobalVariables.errorMessages = List<String>.from(jsonMap['errors']);
      } else if (jsonMap['message'] != null) {
        GlobalVariables.errorMessages.add(jsonMap['message']);
      } else {
        GlobalVariables.errorMessages.add("Unknown error occurred.");
      }

      _logger.i("Stored Error Messages: \${GlobalVariables.errorMessages}");
    } catch (e) {
      _logger.e('Error extracting and storing message: \$e');
      GlobalVariables.errorMessages.add("Error extracting message.");
    }
  }
}
''');

    await File(path.join(servicesDir.path, 'location_service.dart')).writeAsString('''
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// Retrieves the current location of the user.
  /// Returns a [Position] with latitude & longitude.
  /// Throws [Exception] with detailed messages on failure.
  Future<Position> getCurrentLocation() async {
    // Step 1: Check if location services are enabled
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    // Step 2: Check permission status
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await openAppSettings();
      throw Exception(
        'Location permission permanently denied. Please enable it in app settings.',
      );
    }

    // Step 3: Get current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception('Error fetching location: \$e');
    }
  }
}
''');

    await File(path.join(servicesDir.path, 'api_response_handler.dart')).writeAsString('''
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../config/app_routes.dart';
import '../mvvm/model/api_response_model/api_response.dart';
import 'json_extractor.dart';
import 'logger_service.dart';

class ApiResponseHandler {
  static Future<ApiResponse<T>> process<T>(
      dynamic response,
      String? endPoint,
      T Function(dynamic dataJson) fromJson,
      ) async {
    MessageExtractor().extractAndStoreMessage(endPoint ?? "", response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        final parsedJson = response.body.length > 100000
            ? await compute<String, dynamic>(_parseJson, response.body)
            : jsonDecode(response.body);

        return ApiResponse<T>.fromJson(parsedJson, fromJson);

      case 401:
        _handleUnauthorized();
        break;

      case 422:
        _handleError(response, "Validation Error");
        break;

      case 500:
        _handleError(response, "Internal Server Error");
        break;

      default:
        _handleError(
          response,
          "API Error: \${response.statusCode} - \${response.reasonPhrase}",
        );
    }
    throw Exception("Unexpected error occurred.");
  }

  static dynamic _parseJson(String responseBody) {
    return jsonDecode(responseBody);
  }

  static void _handleUnauthorized() {
    LoggerService.w("Unauthorized access. Redirecting to login.");
    Get.offAllNamed(AppRoutes.loginView);
    throw Exception("Unauthorized access. Please log in.");
  }

  static void _handleError(dynamic response, String errorMessage) {
    try {
      final errorResponse = jsonDecode(response.body);
      throw Exception("\$errorMessage: \${errorResponse['message'] ?? 'No details available'}");
    } catch (e, stack) {
      LoggerService.e('Error handling failed: \$e', error: e, stackTrace: stack);
      throw Exception(errorMessage);
    }
  }

  static void logUnhandledError(dynamic e, StackTrace stackTrace) {
    LoggerService.e('Unhandled error: \$e', error: e, stackTrace: stackTrace);
  }
}
''');

    await File(path.join(servicesDir.path, 'logger_service.dart')).writeAsString('''
import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message) => _logger.w(message);
  static void e(String message, {dynamic error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  static void v(String message) => _logger.v(message);
  static void wtf(String message) => _logger.wtf(message);
}
''');

    print('Created service files in services/');
  }

  Future<void> _createRepositoryFiles(String appDirPath) async {
    final authRepoDir = Directory(path.join(appDirPath, 'repository', 'auth_repo'));
    final apiRepoDir = Directory(path.join(appDirPath, 'repository', 'apis'));

    await File(path.join(authRepoDir.path, 'auth_repository.dart')).writeAsString('''
import 'package:http/http.dart' as http;
import '../../config/app_urls.dart';
import '../../mvvm/model/api_response_model/api_response.dart';
import '../../mvvm/model/body_model/driver_signup_body_model.dart';
import '../../mvvm/model/body_model/garage_signup_body_model.dart';
import '../../services/api_response_handler.dart';
import '../../services/https_calls.dart';

class AuthRepository {
  final HttpsCalls _httpsCalls = HttpsCalls();

  Future<ApiResponse<void>> driverSignUpApi(DriverSignupBodyModel signUpBodyModel) async {
    try {
      String endPoint = AppUrls.signup;
      final response = await _httpsCalls.multipartDriverProfileApiHits(endPoint, signUpBodyModel);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<void>> updateDriver(DriverSignupBodyModel signUpBodyModel) async {
    try {
      String endPoint = AppUrls.updateAccount;
      final response = await _httpsCalls.multipartDriverProfileApiHits(endPoint, signUpBodyModel);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<void>> garageSignUpApi(GarageSignupBodyModel signUpBodyModel) async {
    try {
      String endPoint = AppUrls.signup;
      final response = await _httpsCalls.multipartGarageProfileApiHits(endPoint, signUpBodyModel);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }
}
''');

    await File(path.join(apiRepoDir.path, 'data_repository.dart')).writeAsString('''
import 'package:http/http.dart' as http;
import '../../config/app_urls.dart';
import '../../mvvm/model/api_response_model/api_response.dart';
import '../../mvvm/model/body_model/add_car_body_model.dart';
import '../../mvvm/model/body_model/buy_car_request.dart';
import '../../services/api_response_handler.dart';
import '../../services/https_calls.dart';

class DataRepository {
  final HttpsCalls _httpsCalls = HttpsCalls();

  Future<ApiResponse<void>> addCarApi(AddCarBodyModel carDataModel) async {
    try {
      String endPoint = AppUrls.signup; // Update with correct endpoint
      final response = await _httpsCalls.crudCarMultipartApi(endPoint, carDataModel);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }

  Future<ApiResponse<void>> buyCarApi(BuyCarRequestModel buyRequestModel) async {
    try {
      String endPoint = AppUrls.signup; // Update with correct endpoint
      final response = await _httpsCalls.multipartBuyCarRequestApi(endPoint, buyRequestModel);
      return await ApiResponseHandler.process(response, endPoint, (dataJson) {});
    } catch (e, stackTrace) {
      ApiResponseHandler.logUnhandledError(e, stackTrace);
      rethrow;
    }
  }
}
''');

    print('Created repository files in repository/');
  }

  Future<void> _createAppWidgetFile(String projectPath) async {
    final appDir = Directory(path.join(projectPath, 'lib', 'app'));
    await File(path.join(appDir.path, 'app_widget.dart')).writeAsString('''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'config/app_colors.dart';
import 'config/app_routes.dart';

class LayerXApp extends StatelessWidget {
  const LayerXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.splashView,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
''');

    print('Created app_widget.dart');
  }

  Future<void> _updateMainFile(String projectPath) async {
    final mainFile = File(path.join(projectPath, 'lib', 'main.dart'));
    await mainFile.writeAsString('''
import 'package:flutter/material.dart';
import 'app/app_widget.dart';

void main() {
  runApp(const LayerXApp());
}
''');

    print('Updated main.dart');
  }

  Future<void> _updatePubspecFile(String projectPath) async {
    final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
    await pubspecFile.writeAsString('''
name: layerx_app
description: A Flutter project with LayerX architecture.
version: 1.0.0+1

environment:
  sdk: '>=2.12.0 <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  http: ^1.0.0
  shared_preferences: ^2.0.0
  logger: ^2.0.0
  flutter_screenutil: ^5.0.0
  geolocator: ^10.0.0
  permission_handler: ^10.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.0.0

flutter:
  uses-material-design: true
''');

    print('Updated pubspec.yaml');
  }
}