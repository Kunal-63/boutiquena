import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/vendor_profile.dart';
import 'package:vendor_app/services/api_service.dart';
import 'package:vendor_app/services/log_service.dart';
import 'package:vendor_app/utils/utils.dart';

class VendorProfileProvider with ChangeNotifier {
  VendorProfile? _vendorProfile;
  bool _isLoading = false;

  VendorProfile? get vendorProfile => _vendorProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchVendorProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('get-vendor-profile');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          _vendorProfile = VendorProfile.fromJson(data['data']);
        }
      } else {
        throw Exception(
          "API Error: ${response?.statusCode} - ${response?.body}",
        );
      }
    } catch (e) {
      LogService.error("fetchVendorProfile() Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateVendorProfile({
    required String name,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pincode,
    required String mobile,
    String password = "123456",
    File? image,
  }) async {
    _isLoading = true;
    notifyListeners();

    final body = {
      if (password.isNotEmpty) "password": password,

      "name": name,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
      "pincode": pincode,
      "mobile": mobile,
    };
    File? convertedImage;
    if (image != null) {
      convertedImage = await Utils.convertToJpgIfWebp(image);
    }
    final fileBody = {if (convertedImage != null) "image": convertedImage};

    try {
      LogService.info("Updating Vendor Profile...");
      LogService.info("Request Body: $body");

      final response = await ApiService.postWithAuth(
        'update-vendor-profile',
        body,
        files: fileBody,
      );
      LogService.info('body$body');
      LogService.info('fileBody$fileBody');

      if (response == null) {
        LogService.error("No response from server");
        return false;
      }

      LogService.info("Response Data: $response");

      if (response["status"] == true) {
        _vendorProfile = VendorProfile.fromJson(response["data"]);
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
