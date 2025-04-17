import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/store_category.dart';
import '../services/api_service.dart';
import '../services/log_service.dart';

class StoreCategoryProvider with ChangeNotifier {
  List<StoreCategory>? _categories;
  bool _isLoading = false;

  List<StoreCategory>? get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchStoreCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      LogService.info("Fetching store categories...");

      final response = await ApiService.getWithAuth('store-category');

      if (response == null) {
        LogService.error("No response from server");
        _isLoading = false;
        notifyListeners();
        return;
      }

      LogService.info("Response Data: $response");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'].toString() == 'true' &&
            data['store_categories'] != null) {
          _categories =
              (data["store_categories"] as List)
                  .map((e) => StoreCategory.fromJson(e))
                  .toList();
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
