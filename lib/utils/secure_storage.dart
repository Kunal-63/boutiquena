import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class AuthTokenUtil {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _authTokenKey = 'auth_token';

  /// Save authentication token securely
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _authTokenKey, value: token);
  }

  /// Retrieve authentication token
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _authTokenKey);
  }

  /// Delete authentication token (for logout)
  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: _authTokenKey);
  }
}
