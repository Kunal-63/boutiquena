import 'package:flutter/material.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:customer_app/utils/secure_storage.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> logOutProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      LogService.info("Logging out vendor...");

      final response = await ApiService.postWithAuth('logout-vendor', {});

      if (response == null) {
        LogService.error("No response from server");
        _isLoading = false;
        notifyListeners();
        return false;
      }

      LogService.info("Response Data: $response");

      if (response["status"] == true) {
        await LoginStatusUtil.clearLoginStatus();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        LogService.error("API Error Message: ${response["message"]}");
      }
    } catch (e, stacktrace) {
      LogService.error("Exception: $e\n$stacktrace");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
