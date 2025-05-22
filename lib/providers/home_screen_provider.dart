import 'dart:convert';

import 'package:customer_app/models/banner.dart';
import 'package:customer_app/models/product_details.dart';
import 'package:customer_app/models/store.dart';
import 'package:customer_app/models/top_category.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:flutter/widgets.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool isTopCategoriesLoading = false;
  bool isBannersLoading = false;
  bool isBestSellersLoading = false;
  bool isSuggestedProductsLoading = false;
  bool isDiscountedProductsLoading = false;
  bool isStoresLoading = false;

  List<TopCategory> topCategories = [];
  String? topCategoriesImageUrl;

  List<BannerModel> banners = [];
  String? bannerImageUrl;

  List<ProductDetail> bestSellerProducts = [];
  String? bestSellerImageUrl;

  List<ProductDetail> suggestedProducts = [];
  String? suggestedProductImageUrl;

  List<ProductDetail> discountedProducts = [];
  String? discountedProductImageUrl;
  String? discountedProductTitle;

  List<Store> featuredStores = [];
  String? storeImageUrl;
  String? storeCoverImageUrl;

  Future<void> fetchTopCategories() async {
    isTopCategoriesLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('get-category');

      if (response != null && response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        topCategoriesImageUrl = jsonData['data']?['image_url']?.toString();

        final List<dynamic> categoriesJson =
            jsonData['data']?['categories'] ?? [];

        topCategories =
            categoriesJson
                .map((categoryJson) => TopCategory.fromJson(categoryJson))
                .toList();
      } else {
        LogService.error(
          "Failed to fetch top categories: ${response?.statusCode}",
        );
      }
    } catch (e) {
      LogService.error("Error fetching top categories: $e");
    } finally {
      isTopCategoriesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBanners() async {
    isBannersLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('get-home-banners');

      if (response != null && response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          final data = decoded['data'];

          bannerImageUrl = data['image_url']?.toString();

          final bannerList = data['banners'] as List<dynamic>;
          banners = bannerList.map((e) => BannerModel.fromJson(e)).toList();
        }
      } else {
        debugPrint("Failed to fetch banners: ${response?.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching banners: $e");
    } finally {
      isBannersLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBestSellerProducts() async {
    isBestSellersLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth(
        'get-home-best-seller-products',
      );

      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == true) {
          final data = decoded['data'];

          bestSellerImageUrl = data['image_url'];
          final List<dynamic> productList = data['products'] ?? [];

          bestSellerProducts =
              productList.map((e) => ProductDetail.fromJson(e)).toList();
        }
      } else {
        LogService.error(
          "Failed to fetch best seller products: ${response?.statusCode}",
        );
      }
    } catch (e) {
      LogService.error("Error fetching best seller products: $e");
    } finally {
      isBestSellersLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSuggestedProducts() async {
    isSuggestedProductsLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth(
        'get-home-suggested-products',
      );

      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == true) {
          final data = decoded['data'];

          suggestedProductImageUrl = data['image_url'];
          final List<dynamic> productList = data['products'] ?? [];

          suggestedProducts =
              productList.map((e) => ProductDetail.fromJson(e)).toList();
        }
      } else {
        LogService.error(
          "Failed to fetch suggested products: ${response?.statusCode}",
        );
      }
    } catch (e) {
      LogService.error("Error fetching suggested products: $e");
    } finally {
      isSuggestedProductsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDiscountedProducts() async {
    isDiscountedProductsLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('home-discount-products');

      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == true) {
          final data = decoded['data'];

          discountedProductImageUrl = data['image_url'];
          discountedProductTitle = data['discount'];
          final List<dynamic> productList = data['products'] ?? [];

          discountedProducts =
              productList.map((e) => ProductDetail.fromJson(e)).toList();
        }
      } else {
        LogService.error(
          "Failed to fetch discounted products: ${response?.statusCode}",
        );
      }
    } catch (e) {
      LogService.error("Error fetching discounted products: $e");
    } finally {
      isDiscountedProductsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFeaturedStores() async {
    isStoresLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('featured-stores');

      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == true) {
          final data = decoded['data'];
          storeImageUrl = data['image_url'];
          storeCoverImageUrl = data['cover_image_url'];

          final storeList = data['stores'] as List<dynamic>;
          featuredStores = storeList.map((e) => Store.fromJson(e)).toList();
        }
      } else {
        LogService.error(
          "Failed to fetch featured stores: ${response?.statusCode}",
        );
      }
    } catch (e) {
      LogService.error("Error fetching featured stores: $e");
    } finally {
      isStoresLoading = false;
      notifyListeners();
    }
  }

  void toggleWishlistStatus(int productId) {
    void _toggleInList(List<ProductDetail> list) {
      for (var product in list) {
        if (product.id == productId) {
          product.isInWishlist = !(product.isInWishlist ?? false);
          break;
        }
      }
    }

    _toggleInList(bestSellerProducts);
    _toggleInList(suggestedProducts);
    _toggleInList(discountedProducts);

    notifyListeners();
  }
}
