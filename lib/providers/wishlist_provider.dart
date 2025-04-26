import 'dart:convert';

import 'package:customer_app/models/product.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  bool isWishlistLoading = false;
  List<Product> wishlistProducts = [];
  String productBaseImageUrl = '';

  Future<void> fetchWishlist() async {
    isWishlistLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('get-wishtlists');
      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == true) {
          productBaseImageUrl = decoded['data']['product_image'] ?? '';

          final wishlistData = decoded['data']['wishlist'] as List<dynamic>;

          wishlistProducts =
              wishlistData.map<Product>((item) {
                final productJson = item['product'];
                return Product.fromJson(productJson);
              }).toList();
        }
      } else {
        wishlistProducts = [];
        LogService.error('Wishlist fetch failed: ${response?.statusCode}');
      }
    } catch (e) {
      LogService.error('Wishlist fetch error: $e');
    } finally {
      isWishlistLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleWishlist(String productId) async {
    try {
      final response = await ApiService.postWithAuth('add-remove-wishtlist', {
        'product_id': productId,
      });

      if (response != null) {
        if (response['status'] == true) {
          await fetchWishlist();
        } else {
          LogService.error('Toggle wishlist failed: ${response['message']}');
        }
      } else {
        LogService.error('Toggle wishlist failed: Response is null');
      }
    } catch (e) {
      LogService.error('Toggle wishlist error: $e');
    } finally {
      await fetchWishlist();
      LogService.info("fetching wishlist in finally");
    }
  }
}
