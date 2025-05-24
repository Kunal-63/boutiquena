import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:customer_app/models/customer_profile.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class CustomerProfileProvider with ChangeNotifier {
  CustomerProfile? _customerProfile;
  bool _isLoading = false;
  int _coinBalance = 0; // <- Added

  CustomerProfile? get customerProfile => _customerProfile;
  bool get isLoading => _isLoading;
  int get coinBalance => _coinBalance; // <- Added

  Future<void> fetchCustomerProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('get-profile');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          _customerProfile = CustomerProfile.fromJson(data['data']);
        }
      } else {
        throw Exception(
          "API Error: ${response?.statusCode} - ${response?.body}",
        );
      }
    } catch (e) {
      LogService.error("fetchCustomerProfile() Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCoinBalance() async {
    // <- Added this method
    try {
      final response = await ApiService.getWithAuth('get-coin-balance');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _coinBalance = data['data'] ?? 0;
        } else {
          LogService.error("Failed to fetch coin balance: ${data['message']}");
        }
      } else {
        LogService.error(
          "API Error: ${response?.statusCode} - ${response?.body}",
        );
      }
    } catch (e, stackTrace) {
      LogService.error("fetchCoinBalance() Error: $e\n$stackTrace");
    }
    notifyListeners();
  }

  Future<bool> updateCustomerProfile({
    required String name,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String mobile,
    String password = "123456",
    File? profileImage,
  }) async {
    _isLoading = true;
    notifyListeners();

    final body = {
      "password": password,
      "name": name,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "pincode": pincode,
      "mobile": mobile,
    };

    try {
      LogService.info("Updating Customer Profile...");
      LogService.info("Request Body: $body");

      final response = await ApiService.postWithAuth(
        'update-profile',
        body,
        files: {'image': profileImage},
      );

      if (response == null) {
        LogService.error("No response from server");
        return false;
      }

      LogService.info("Response Data: $response");

      if (response["status"] == true) {
        _customerProfile = CustomerProfile.fromJson(response["data"]);
        fetchCustomerProfile();
        _isLoading = false;
        LogService.info(
          "Profile updated successfully: ${_customerProfile?.name}",
        );

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
