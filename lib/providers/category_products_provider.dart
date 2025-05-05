import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:flutter/material.dart';

class CategoryProductsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isFetchingMore = false;
  List<ProductDetail> categoryProducts = [];
  String productBaseImageUrl = '';
  int totalCount = 0;
  int limit = 5;
  int currentPage = 1;
  int totalPages = 1;

  Future<void> fetchCateogryProducts(int categoryId, {int page = 1}) async {
    if (page == 1) {
      isLoading = true;
    } else {
      isFetchingMore = true;
    }
    notifyListeners();

    try {
      final response = await ApiService.postWithAuth(
        'get-products-by-category/$categoryId',
        {'offset': (page - 1) * limit, 'limit': limit},
      );

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
            categoryProducts = newProducts;
          } else {
            categoryProducts.addAll(newProducts);
          }
        }
      } else {
        LogService.error(
          'Suggested products fetch failed: ${response?.statusCode}',
        );
      }
    } catch (e) {
      LogService.error('Suggested products fetch error: $e');
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMore(int categoryId) async {
    if (currentPage < totalPages && !isFetchingMore) {
      await fetchCateogryProducts(page: currentPage + 1, categoryId);
    }
  }
}
