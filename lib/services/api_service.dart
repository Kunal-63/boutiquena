import 'dart:convert';
import 'dart:io';
import 'package:customer_app/services/mavigation_service.dart';
import 'package:customer_app/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import 'log_service.dart';
// import '../utils/auth_token_util.dart';

class ApiService {
  static Future<void> _handleUnauthorized() async {
    LogService.warning("Unauthorized access detected. Logging out...");

    await LoginStatusUtil.clearLoginStatus();
    NavigationService.navigateToLogin();
  }

  static Future<http.Response?> get(String endpoint) async {
    final url = "${Env.apiBaseUrl}$endpoint";
    LogService.info("GET Request: $url");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 401 || response.statusCode == 404) {
        await _handleUnauthorized();
        return null;
      }
      LogService.info("Response Status: \${response.statusCode}");
      LogService.info("Response Body: \${response.body}");

      return response; // Return response regardless of status
    } catch (e) {
      LogService.error("Network Error: $e");
      return null; // Network failure, return null
    }
  }

  static Future<http.Response?> getWithAuth(String endpoint) async {
    final url = "${Env.apiBaseUrl}$endpoint";
    LogService.info("GET Request with Auth: $url");

    try {
      String? token = await AuthTokenUtil.getToken();
      if (token == null || token.isEmpty) {
        LogService.error("Auth Token is missing or empty");
        return null;
      }

      LogService.info("Using Auth Token: $token"); // Debugging

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // Ensure correct format
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 401 || response.statusCode == 404) {
        await _handleUnauthorized();
        return null;
      }

      LogService.info("Response Status: ${response.statusCode}");
      LogService.info("Response Body: ${response.body}");

      return response;
    } catch (e) {
      LogService.error("Network Error: $e");
      return null;
    }
  }

  /// POST Request with optional File Upload
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, File?>? files, // Accept a single file per key
  }) async {
    final url = Uri.parse("${Env.apiBaseUrl}$endpoint");
    LogService.info("POST Request: $url");
    LogService.info("Request Body: $body");

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({"Content-Type": "multipart/form-data"});

      // Add form fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files (one per key)
      if (files != null && files.isNotEmpty) {
        for (var entry in files.entries) {
          String keyName = entry.key;
          File? file = entry.value;

          if (file != null && await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath(keyName, file.path),
            );
            LogService.info("Added file: ${file.path} with key: $keyName");
          } else {
            LogService.warning(
              "Skipping null or non-existent file for key: $keyName",
            );
          }
        }
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401 || response.statusCode == 404) {
        await _handleUnauthorized();
        return null;
      }

      LogService.info("Response Status: ${response.statusCode}");
      LogService.info("Response Body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      LogService.error("POST Request Error: $e");
      return {"error": "Something went wrong", "exception": e.toString()};
    }
  }

  static Future<dynamic> postWithAuth(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, File?>? files,
  }) async {
    final url = Uri.parse("${Env.apiBaseUrl}$endpoint");
    LogService.info("POST Request: $url");
    LogService.info("Request Body: $body");
    String? token = await AuthTokenUtil.getToken();

    if (token == null || token.isEmpty) {
      LogService.error("Auth Token is missing or empty");
      return null;
    }
    try {
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        "Authorization": "Bearer $token", // Ensure correct format
        "Content-Type": "application/json",
      });

      // Add form fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add files (one per key)
      if (files != null && files.isNotEmpty) {
        for (var entry in files.entries) {
          String keyName = entry.key;
          File? file = entry.value;

          if (file != null && await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath(keyName, file.path),
            );
            LogService.info("Added file: ${file.path} with key: $keyName");
          } else {
            LogService.warning(
              "Skipping null or non-existent file for key: $keyName",
            );
          }
        }
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401 || response.statusCode == 404) {
        await _handleUnauthorized();
        return null;
      }

      LogService.info("Response Status: ${response.statusCode}");
      LogService.info("Response Body: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      LogService.error("POST Request Error: $e");
      return {"error": "Something went wrong", "exception": e.toString()};
    }
  }

  static Future<http.Response?> deleteWithAuth(String endpoint) async {
    final url = "${Env.apiBaseUrl}$endpoint";
    LogService.info("DELETE Request with Auth: $url");

    try {
      String? token = await AuthTokenUtil.getToken();
      if (token == null || token.isEmpty) {
        LogService.error("Auth Token is missing or empty");
        return null;
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 401 || response.statusCode == 404) {
        await _handleUnauthorized();
        return null;
      }

      LogService.info("Response Status: ${response.statusCode}");
      LogService.info("Response Body: ${response.body}");

      return response;
    } catch (e) {
      LogService.error("Network Error during DELETE: $e");
      return null;
    }
  }
}
