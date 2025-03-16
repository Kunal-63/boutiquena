import 'dart:convert';
import 'dart:io';
import 'package:boutiquena_vendor/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../services/log_service.dart';
// import '../utils/auth_token_util.dart';

class ApiService {
  static Future<http.Response?> get(String endpoint) async {
    final url = "${Env.apiBaseUrl}$endpoint";
    LogService.info("GET Request: $url");

    try {
      final response = await http.get(Uri.parse(url));
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
          "Content-Type": "application/json"
        },
      );

      LogService.info("Response Status: ${response.statusCode}");
      LogService.info("Response Body: ${response.body}");

      return response;
    } catch (e) {
      LogService.error("Network Error: $e");
      return null;
    }
  }

  /// POST Request with optional File Upload
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body,
      {File? file}) async {
    final url = Uri.parse("${Env.apiBaseUrl}$endpoint");
    LogService.info("POST Request: $url");
    LogService.info("Request Body: $body");

    try {
      if (file != null) {
        // Multipart Request for file upload
        var request = http.MultipartRequest('POST', url);
        request.headers.addAll({"Content-Type": "multipart/form-data"});

        // Add fields to the request
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // Debug: Ensure file exists
        if (!await file.exists()) {
          LogService.error("File does not exist: \${file.path}");
          return {"error": "Selected file not found!"};
        }

        // Attach file with correct field name (Ensure backend expects 'storeLogo')
        request.files
            .add(await http.MultipartFile.fromPath('store_image', file.path));

        LogService.info("Uploading file: \${file.path}");

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        LogService.info("Response Status: \${response.statusCode}");
        LogService.info("Response Body: \${response.body}");

        return jsonDecode(response.body);
      } else {
        // Normal JSON Request
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        LogService.info("Response Status: \${response.statusCode}");
        LogService.info("Response Body: \${response.body}");

        return jsonDecode(response.body);
      }
    } catch (e) {
      LogService.error("POST Request Error: $e");
      return {"error": "Something went wrong", "exception": e.toString()};
    }
  }
}
