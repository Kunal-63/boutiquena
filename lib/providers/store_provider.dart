import 'dart:convert';

import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/models/store.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isFetchingMore = false;
  List<ProductDetail> storeProducts = [];
  String productBaseImageUrl = '';
  int totalCount = 0;
  int limit = 5;
  int currentPage = 1;
  int totalPages = 1;

  Store? storeDetails;

  Future<void> fetchStoreDetails(int storeId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth(
        'get-store-detail/$storeId',
      );
      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == false) {
          LogService.error('Store details fetch failed: ${decoded['message']}');
          return;
        }
        final storeData = decoded['data'];
        storeDetails = Store.fromJson(storeData);
        productBaseImageUrl = storeData['image_path'] ?? '';
      } else {
        LogService.error('Failed to fetch store details: ${response?.body}');
      }
    } catch (e) {
      LogService.error('Store details fetch error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStoreProducts(int? id, {int page = 1}) async {
    if (page == 1) {
      isLoading = true;
    } else {
      isFetchingMore = true;
    }
    notifyListeners();

    try {
      final response = await ApiService.postWithAuth('get-products-by-store', {
        'offset': (page - 1) * limit,
        'limit': limit,
      });

      if (response != null) {
        if (response['status'] == true) {
          final data = response['data'];
          productBaseImageUrl = data['image_url'] ?? '';
          totalCount = data['total_count'] ?? 0;
          limit = data['limit'] ?? 5;
          currentPage = data['current_page'] ?? 1;
          totalPages = data['total_pages'] ?? 1;

          final productsData = data['products'] as List<dynamic>;

          final newProducts =
              productsData
                  .map<ProductDetail>((item) => ProductDetail.fromJson(item))
                  .toList();

          if (page == 1) {
            storeProducts = newProducts;
          } else {
            storeProducts.addAll(newProducts);
          }
        }
      } else {
        LogService.error(
          'Store products fetch failed: ${response?.statusCode}',
        );
      }
    } catch (e) {
      LogService.error('Store products fetch error: $e');
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMore(int? id) async {
    if (currentPage < totalPages && !isFetchingMore) {
      await fetchStoreProducts(id, page: currentPage + 1);
    }
  }

  Future<bool> followStore(int storeId) async {
    try {
      final response = await ApiService.postWithAuth('follow-store', {
        'store_id': storeId,
      });

      if (response != null && response['status'] == true) {
        return true;
      } else {
        LogService.error('Follow store failed: ${response?['message']}');
        return false;
      }
    } catch (e) {
      LogService.error('Follow store error: $e');
      return false;
    }
  }

  Future<bool> unfollowStore(int storeId) async {
    try {
      final response = await ApiService.postWithAuth('unfollow-store', {
        'store_id': storeId,
      });

      if (response != null && response['status'] == true) {
        return true;
      } else {
        LogService.error('Unfollow store failed: ${response?['message']}');
        return false;
      }
    } catch (e) {
      LogService.error('Unfollow store error: $e');
      return false;
    }
  }
}
