// import 'dart:convert';
// import 'package:logger/logger.dart';
// import '../config/global_variables.dart';
//
// class MessageExtractor {
//   final Logger _logger = Logger();
//
//   void extractAndStoreMessage(String endPoint, String responseBody) {
//     try {
//       _logger.i("Api EndPoint: $endPoint - Body: $responseBody");
//
//       final Map<String, dynamic> jsonMap = jsonDecode(responseBody);
//
//       GlobalVariables.errorMessages.clear();
//
//       if (jsonMap['errors'] is List) {
//         GlobalVariables.errorMessages = List<String>.from(jsonMap['errors']);
//       } else if (jsonMap['message'] != null) {
//         GlobalVariables.errorMessages.add(jsonMap['message']);
//       } else {
//         GlobalVariables.errorMessages.add("Unknown error occurred.");
//       }
//
//       _logger.i("Stored Error Messages: ${GlobalVariables.errorMessages}");
//     } catch (e) {
//       _logger.e('Error extracting and storing message: $e');
//       GlobalVariables.errorMessages.add("Error extracting message.");
//     }
//   }
// }
