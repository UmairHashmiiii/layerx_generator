/// A Flutter package that auto-generates the LayerX directory structure for your project.
///
/// The `layerx_generator` package simplifies the setup of a scalable Flutter project by generating
/// a clean MVVM (Model-View-ViewModel) directory structure under `lib/app/`. It includes pre-configured
/// utilities for HTTP requests, local storage, and error handling, all integrated with the GetX package
/// for state management, navigation, and dependency injection.
///
/// ## Features
/// - Generates a well-organized MVVM directory structure.
/// - Includes pre-built services like `HttpsCalls`, `SharedPreferencesService`, and `MessageExtractor`.
/// - Integrates with GetX for navigation and state management.
/// - Supports responsive design with `flutter_screenutil`.
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
  ///
  /// This property specifies the root directory of the project. The generator will create
  /// the `lib/app/` directory structure within this path.
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
  ///
  /// ## Throws
  /// - [Exception]: If the project directory does not exist or if there are issues creating directories/files.
  ///
  /// ## Example
  /// ```dart
  /// final generator = LayerXGenerator(Directory.current.path);
  /// await generator.generate();
  /// ```
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
  static const String appSettings = 'settings';
}
''');

    await File(path.join(configDir.path, 'app_text_style.dart'))
        .writeAsString('''
import 'package:flutter/material.dart';

abstract class AppTextStyles {
  AppTextStyles._();
  static TextStyle bodyText({Color? color}) {
    return TextStyle(fontSize: 16, color: color ?? Colors.black);
  }
}
''');

    await File(path.join(configDir.path, 'global_variable.dart'))
        .writeAsString('''
class GlobalVariables {
  static List<String> errorMessages = [];
}
''');

    await File(path.join(configDir.path, 'padding_extensions.dart'))
        .writeAsString('''
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

    print('Created placeholder files in config/');
  }

  Future<void> _createModelFiles(String appDirPath) async {
    final bodyModelDir =
        Directory(path.join(appDirPath, 'mvvm', 'model', 'body_model'));
    final responseModelDir =
        Directory(path.join(appDirPath, 'mvvm', 'model', 'response_model'));
    final apiResponseModelDir =
        Directory(path.join(appDirPath, 'mvvm', 'model', 'api_response_model'));

    await File(path.join(bodyModelDir.path, 'example_body_model.dart'))
        .writeAsString('''
class ExampleBodyModel {
  String? field;

  ExampleBodyModel({this.field});

  Map<String, dynamic> toJson() => {'field': field};
}
''');

    await File(path.join(responseModelDir.path, 'example_response_model.dart'))
        .writeAsString('''
class ExampleResponseModel {
  String? field;

  ExampleResponseModel({this.field});

  factory ExampleResponseModel.fromJson(Map<String, dynamic> json) {
    return ExampleResponseModel(field: json['field'] as String?);
  }
}
''');

    await File(path.join(apiResponseModelDir.path, 'api_response.dart'))
        .writeAsString('''
class ApiResponse<T> {
  final bool? success;
  final String? message;
  final T? data;

  ApiResponse({this.success, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
''');

    print('Created placeholder files in mvvm/model/');
  }

  Future<void> _createServiceFiles(String appDirPath) async {
    final servicesDir = Directory(path.join(appDirPath, 'services'));

    await File(path.join(servicesDir.path, 'https_service.dart'))
        .writeAsString('''
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/app_routes.dart';
import '../config/app_urls.dart';
import 'shared_preferences_helper.dart';

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
    final url = Uri.parse(ApiUrls.baseAPIURL + lControllerUrl);

    late http.Response response;
    switch (method) {
      case HttpMethod.GET:
        response = await http.get(url, headers: headers);
        break;
      case HttpMethod.POST:
        response = await http.post(url, headers: headers, body: body);
        break;
      case HttpMethod.PUT:
        response = await http.put(url, headers: headers, body: body);
        break;
      case HttpMethod.PATCH:
        response = await http.patch(url, headers: headers, body: body);
        break;
      case HttpMethod.DELETE:
        response = await http.delete(url, headers: headers, body: body);
        break;
    }

    if (response.statusCode == 401) {
      Get.offAllNamed(AppRoutes.signInView);
      throw Exception("Unauthorized access. Please log in.");
    }

    return response;
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

  Future<http.Response> _multipartRequest(
    String lControllerUrl,
    dynamic model, {
    String? fileKey,
    String? filePath,
  }) async {
    final token = await SharedPreferencesService().readToken();
    final url = Uri.parse(ApiUrls.baseAPIURL + lControllerUrl);
    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.acceptHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer \$token',
    });

    final modelJson = model.toJson();
    modelJson.forEach((key, value) {
      if (value is String || value is int || value is double) {
        request.fields[key] = value.toString();
      }
    });

    if (fileKey != null && filePath != null) {
      var file = await http.MultipartFile.fromPath(fileKey, filePath);
      request.files.add(file);
    }

    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> multipartApiHits(
    String lControllerUrl,
    dynamic model, {
    String? fileKey,
    String? filePath,
  }) {
    return _performRequest(
      lControllerUrl,
      () => _multipartRequest(
        lControllerUrl,
        model,
        fileKey: fileKey,
        filePath: filePath,
      ),
    );
  }
}
''');

    await File(path.join(servicesDir.path, 'shared_preferences_helper.dart'))
        .writeAsString('''
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

    await File(path.join(servicesDir.path, 'json_extractor.dart'))
        .writeAsString('''
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

    print('Created placeholder files in services/');
  }

  Future<void> _createRepositoryFiles(String appDirPath) async {
    final authRepoDir =
        Directory(path.join(appDirPath, 'repository', 'auth_repo'));

    await File(path.join(authRepoDir.path, 'example_repo.dart'))
        .writeAsString('''
import 'package:get/get.dart';
import '../../services/https_service.dart';
import '../../services/json_extractor.dart';

class ExampleRepo {
  final HttpsCalls _httpsCalls = HttpsCalls();
  final MessageExtractor _messageExtractor = MessageExtractor();

  Future<void> fetchData(String endpoint) async {
    try {
      final response = await _httpsCalls.getApiHits(endpoint);
      _messageExtractor.extractAndStoreMessage(endpoint, response.body);
    } catch (e) {
      rethrow;
    }
  }
}
''');

    print('Created placeholder files in repository/');
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
}
