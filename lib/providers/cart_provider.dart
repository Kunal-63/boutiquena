import 'dart:convert';

import 'package:customer_app/models/cart_product.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class CartProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CartProduct> cartItems = [];

  Future<void> fetchCart() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('listCart');

      if (response != null && response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        cartItems = data.map((item) => CartProduct.fromJson(item)).toList();
      } else {
        LogService.error('Cart fetch failed: ${response?.body}');
      }
    } catch (e, stackTrace) {
      LogService.error('Cart fetch error: $e\n$stackTrace');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart({
    required int productId,
    required int attributeId,
    required int quantity,
  }) async {
    try {
      final response = await ApiService.postWithAuth('addCart', {
        'product_id': productId,
        'attribute_id': attributeId,
        'quantity': quantity,
      });

      if (response != null && response['status'] == true) {
        await fetchCart(); // Refresh cart after adding
      } else {
        LogService.error('Add to cart failed: ${response?['message']}');
      }
    } catch (e, stackTrace) {
      LogService.error('Add to cart error: $e\n$stackTrace');
    }
  }

  Future<void> updateCart({required int cartId, required int quantity}) async {
    try {
      final response = await ApiService.postWithAuth('updateCart/$cartId', {
        'quantity': quantity,
      });

      if (response != null && response['status'] == true) {
        await fetchCart(); // Refresh cart after update
      } else {
        LogService.error('Update cart failed: ${response?['message']}');
      }
    } catch (e, stackTrace) {
      LogService.error('Update cart error: $e\n$stackTrace');
    }
  }

  Future<void> deleteCart({required int cartId}) async {
    try {
      final response = await ApiService.deleteWithAuth('deleteCart/$cartId');

      if (response != null && response.statusCode == 200) {
        cartItems.removeWhere((item) => item.cartId == cartId);
        notifyListeners(); // No need to re-fetch full cart
      } else {
        LogService.error('Delete cart failed: ${response?.body}');
      }
    } catch (e, stackTrace) {
      LogService.error('Delete cart error: $e\n$stackTrace');
    }
  }
}
