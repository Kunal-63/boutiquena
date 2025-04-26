import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:customer_app/models/product.dart';
import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? productImageURL;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductDetail? _selectedProductDetail;
  ProductDetail? get selectedProductDetail => _selectedProductDetail;
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
}
