import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/region.dart';
import 'package:vendor_app/services/api_service.dart';
import 'package:vendor_app/services/log_service.dart';

class RegionProvider with ChangeNotifier {
  List<Region>? _regions;
  bool _isLoading = false;

  List<Region>? get regions => _regions;
  bool get isLoading => _isLoading;

  Future<void> fetchRegions() async {
    _isLoading = true;
    notifyListeners();

    try {
      LogService.info("Fetching regions...");

      final response = await ApiService.getWithAuth('get-regions');

      if (response == null) {
        LogService.error("No response from server");
        _isLoading = false;
        notifyListeners();
        return;
      }

      LogService.info("Response Data: $response");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          _regions = Region.fromJsonList(data["data"] ?? []);
        } else {
          throw Exception(
            "API Error: ${response.statusCode} - ${response.body}",
          );
        }
      }
    } catch (e, stacktrace) {
      LogService.error("Exception: $e\n$stacktrace");
    }

    _isLoading = false;
    notifyListeners();
  }
}
