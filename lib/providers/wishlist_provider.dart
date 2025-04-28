import 'dart:convert';
import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  bool isWishlistLoading = false;
  bool isFetchingMore = false;
  List<ProductDetail> wishlistProducts = [];
  String productBaseImageUrl = '';
  int totalCount = 0;
  int limit = 5; // Items per page
  int currentPage = 1;
  int totalPages = 1;

  // Fetch wishlist with pagination
  Future<void> fetchWishlist({int page = 1}) async {
    if (page == 1) {
      isWishlistLoading = true;
    } else {
      isFetchingMore = true;
    }
    notifyListeners();

    try {
      final response = await ApiService.postWithAuth('get-wishtlists', {
        'offset': (page - 1) * limit,
        'limit': limit,
      });

      if (response != null && response['status'] == true) {
        final data = response['data'];
        productBaseImageUrl = data['image_url'] ?? '';
        totalCount = data['total_count'] ?? 0;
        totalPages = data['total_pages'] ?? 1;

        final wishlistData = data['products'] as List<dynamic>;

        final newProducts =
            wishlistData.map<ProductDetail>((item) {
              final productJson = item['product'];
              if (productJson != null) {
                // Add extra fields from wishlist/cart info
                productJson['is_in_cart'] = item['is_in_cart'];
                productJson['is_in_wishlist'] = item['is_in_wishlist'];
                productJson['wishlist_id'] = item['wishlist_data']?['id'];
                productJson['cart_id'] = item['cart_data']?['id'];
              }
              return ProductDetail.fromJson(productJson);
            }).toList();

        if (page == 1) {
          wishlistProducts = newProducts;
        } else {
          wishlistProducts.addAll(newProducts);
        }

        currentPage = page;
      } else {
        wishlistProducts = [];
        LogService.error('Wishlist fetch failed: ${response?.statusCode}');
      }
    } catch (e) {
      LogService.error('Wishlist fetch error: $e');
    } finally {
      isWishlistLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  // Toggle product in wishlist
  Future<void> toggleWishlist(String productId) async {
    try {
      final response = await ApiService.postWithAuth('add-remove-wishtlist', {
        'product_id': productId,
      });

      if (response != null) {
        if (response['status'] == true) {
          await fetchWishlist(); // Refresh after toggle
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

  // Load more products if available
  Future<void> loadMore() async {
    if (currentPage < totalPages && !isFetchingMore) {
      await fetchWishlist(page: currentPage + 1);
    }
  }
}
