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

class LoginStatusUtil {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';

  /// Set login status (true for logged in, false for logged out)
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    await _secureStorage.write(
      key: _isLoggedInKey,
      value: isLoggedIn ? 'true' : 'false',
    );
  }

  /// Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    String? loggedIn = await _secureStorage.read(key: _isLoggedInKey);
    return loggedIn == 'true';
  }

  /// Clear login status (for logout)
  static Future<void> clearLoginStatus() async {
    await _secureStorage.delete(key: _isLoggedInKey);
  }

  /// Set user ID
  static Future<void> setUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  static Future<int?> getUserId() async {
    return await _secureStorage
        .read(key: _userIdKey)
        .then((value) => value != null ? int.tryParse(value) : null);
  }

  /// Set user type
  static Future<void> setUserType(String userType) async {
    await _secureStorage.write(key: _userTypeKey, value: userType);
  }
}
