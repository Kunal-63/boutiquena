import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductDetail> _products = [];
  final bool _isLoading = false;
  String? productImageURL;

  List<ProductDetail> get products => _products;
  bool get isLoading => _isLoading;

  ProductDetail? _selectedProductDetail;
  ProductDetail? get selectedProductDetail => _selectedProductDetail;

  // ✅ New: Similar products
  List<ProductDetail> _similarProducts = [];
  String? similarProductImageURL;

  List<ProductDetail> get similarProducts => _similarProducts;

  Future<void> fetchProductDetailById(int id) async {
    try {
      final response = await ApiService.getWithAuth('get-product-detail/$id');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          _selectedProductDetail = ProductDetail.fromJson(data['data']);
          notifyListeners();
        } else {
          LogService.error(
            "Failed to fetch product detail: ${data['message']}",
          );
        }
      } else {
        throw Exception(
          "API Error: ${response?.statusCode} - ${response?.body}",
        );
      }
    } catch (e) {
      LogService.error("fetchProductDetailById() Error: $e");
    }
  }

  // ✅ New: Fetch similar products
  Future<void> fetchSimilarProducts(int id) async {
    try {
      final response = await ApiService.getWithAuth('get-similar-products/$id');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          similarProductImageURL = data['data']['image_url'];
          final List<dynamic> rawProducts = data['data']['products'] ?? [];

          _similarProducts =
              rawProducts
                  .map((productJson) => ProductDetail.fromJson(productJson))
                  .toList();

          notifyListeners();
        } else {
          LogService.error(
            "Failed to fetch similar products: ${data['message']}",
          );
        }
      } else {
        throw Exception(
          "API Error: ${response?.statusCode} - ${response?.body}",
        );
      }
    } catch (e) {
      LogService.error("fetchSimilarProducts() Error: $e");
    }
  }
}
