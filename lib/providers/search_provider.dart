import 'dart:convert';

import 'package:customer_app/models/product.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:flutter/widgets.dart';

class SearchScreenProvider extends ChangeNotifier {
  bool isLoading = false;
  String? imagePath;
  List<Product> filteredProducts = [];

  Future<void> fetchSearchedProducts(String? value) async {
    if (value == null || value.isEmpty) {
      LogService.error("Search value cannot be null or empty");
      return; // Exit early if the value is null or empty
    }

    isLoading = true;
    notifyListeners();

    try {
      final decoded = await ApiService.postWithAuth('search-products', {
        'key': value,
      });

      if (decoded != null && decoded['status'] == true) {
        final data = decoded['data'];

        // Safely access `image_url` and `products` from the response
        imagePath = data['image_url'] ?? ''; // Default to empty string if null
        final productList = data['products'] as List<dynamic>?;

        if (productList != null) {
          filteredProducts =
              productList.map((e) => Product.fromJson(e)).toList();
        } else {
          filteredProducts = [];
        }
      } else {
        LogService.error("Failed to fetch searched products");
      }
    } catch (e) {
      LogService.error("Error fetching searched products: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
