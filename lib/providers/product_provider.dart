import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/services/api_service.dart';
import 'package:vendor_app/services/log_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? productImageURL;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth('get-vendor-products');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final productMap = data['data'] as Map<String, dynamic>;

          _products =
              productMap.entries
                  .where((entry) => int.tryParse(entry.key) != null)
                  .map((entry) => Product.fromJson(entry.value))
                  .toList();

          productImageURL = data['data']['image_url'] ?? null;
          print("PRODUCT IMAGE URL: $productImageURL");
        } else {
          LogService.error("Invalid response format in product data");
        }
      } else {
        throw Exception(
          "API Error: ${response?.statusCode} - ${response?.body}",
        );
      }
    } catch (e) {
      LogService.error("fetchProducts() Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addProduct(
    Product product,
    List<File>? selectedIamges,
    File? selectedImage,
  ) async {
    try {
      final response = await ApiService.postWithAuth(
        'add-vendor-products',
        {
          "category_id": product.categoryId ?? "1",
          "product_name": product.productName ?? "",
          "vendor_price": product.vendorPrice ?? "0",
          "short_description": product.shortDescription ?? "",
          "description": product.description ?? "",
          "product_name_arabic": product.productNameArabic ?? "",
          "product_name_hebrew": product.productNameHebrew ?? "",
          "short_description_hebrew": product.shortDescriptionHebrew ?? "",
          "short_description_arabic": product.shortDescriptionArabic ?? "",
          "description_hebrew": product.descriptionHebrew ?? "",
          "description_arabic": product.descriptionArabic ?? "",
          "meta_title": product.metaTitle ?? "",
          "meta_title_hebrew": product.metaTitleHebrew ?? "",
          "meta_title_arabic": product.metaTitleArabic ?? "",
          "meta_description": product.metaDescription ?? "",
          "meta_description_hebrew": product.metaDescriptionHebrew ?? "",
          "meta_description_arabic": product.metaDescriptionArabic ?? "",
          "meta_keywords": product.metaKeywords ?? "",
          "meta_keywords_hebrew": product.metaKeywordsHebrew ?? "",
          "meta_keywords_arabic": product.metaKeywordsArabic ?? "",
          "is_pinned": product.isPinned ?? "0",
          "is_suggested": product.isSuggested ?? "0",
          "is_featured": product.isFeatured ?? "0",
          "is_bestseller": product.isBestseller ?? "0",
          "status": product.status ?? "1",
        },
        files: {"product_image": selectedImage},
        multipleFiles: {"product_images": selectedIamges ?? []},
      );

      if (response['status'] == true) {
        final newProduct = Product(
          id: response['data']['id'],
          categoryId: product.categoryId,
          productName: product.productName,
          vendorPrice: product.vendorPrice,
          shortDescription: product.shortDescription,
          description: product.description,
          productNameArabic: product.productNameArabic,
          productNameHebrew: product.productNameHebrew,
          shortDescriptionHebrew: product.shortDescriptionHebrew,
          shortDescriptionArabic: product.shortDescriptionArabic,
          descriptionHebrew: product.descriptionHebrew,
          descriptionArabic: product.descriptionArabic,
          metaTitle: product.metaTitle,
          metaTitleHebrew: product.metaTitleHebrew,
          metaTitleArabic: product.metaTitleArabic,
          metaDescription: product.metaDescription,
          metaDescriptionHebrew: product.metaDescriptionHebrew,
          metaDescriptionArabic: product.metaDescriptionArabic,
          metaKeywords: product.metaKeywords,
          metaKeywordsHebrew: product.metaKeywordsHebrew,
          metaKeywordsArabic: product.metaKeywordsArabic,
          isPinned: product.isPinned,
          isSuggested: product.isSuggested,
          isFeatured: product.isFeatured,
          isBestseller: product.isBestseller,
          status: product.status,
        );

        fetchProducts();
        notifyListeners();

        return true;
      } else {
        LogService.error("Failed to add product: ${response['message']}");
        return false;
      }
    } catch (e) {
      LogService.error("addProduct() Error: $e");
      return false;
    }
  }

  Future<bool> updateProduct(
    Product product,
    List<File>? selectedIamges,
  ) async {
    try {
      final response = await ApiService.postWithAuth(
        'update-vendor-products/${product.id}',
        {
          "category_id": product.categoryId ?? "1",
          "product_name": product.productName ?? "",
          "vendor_price": product.vendorPrice ?? "0",
          "short_description": product.shortDescription ?? "",
          "description": product.description ?? "",
          "product_name_arabic": product.productNameArabic ?? "",
          "product_name_hebrew": product.productNameHebrew ?? "",
          "short_description_hebrew": product.shortDescriptionHebrew ?? "",
          "short_description_arabic": product.shortDescriptionArabic ?? "",
          "description_hebrew": product.descriptionHebrew ?? "",
          "description_arabic": product.descriptionArabic ?? "",
          "meta_title": product.metaTitle ?? "",
          "meta_title_hebrew": product.metaTitleHebrew ?? "",
          "meta_title_arabic": product.metaTitleArabic ?? "",
          "meta_description": product.metaDescription ?? "",
          "meta_description_hebrew": product.metaDescriptionHebrew ?? "",
          "meta_description_arabic": product.metaDescriptionArabic ?? "",
          "meta_keywords": product.metaKeywords ?? "",
          "meta_keywords_hebrew": product.metaKeywordsHebrew ?? "",
          "meta_keywords_arabic": product.metaKeywordsArabic ?? "",
          "is_pinned": product.isPinned ?? "0",
          "is_suggested": product.isSuggested ?? "0",
          "is_featured": product.isFeatured ?? "0",
          "is_bestseller": product.isBestseller ?? "0",
          "status": product.status ?? "1",
        },
      );

      if (response['status'] == true) {
        final newProduct = Product(
          id: response['data']['id'],
          categoryId: product.categoryId,
          productName: product.productName,
          vendorPrice: product.vendorPrice,
          shortDescription: product.shortDescription,
          description: product.description,
          productNameArabic: product.productNameArabic,
          productNameHebrew: product.productNameHebrew,
          shortDescriptionHebrew: product.shortDescriptionHebrew,
          shortDescriptionArabic: product.shortDescriptionArabic,
          descriptionHebrew: product.descriptionHebrew,
          descriptionArabic: product.descriptionArabic,
          metaTitle: product.metaTitle,
          metaTitleHebrew: product.metaTitleHebrew,
          metaTitleArabic: product.metaTitleArabic,
          metaDescription: product.metaDescription,
          metaDescriptionHebrew: product.metaDescriptionHebrew,
          metaDescriptionArabic: product.metaDescriptionArabic,
          metaKeywords: product.metaKeywords,
          metaKeywordsHebrew: product.metaKeywordsHebrew,
          metaKeywordsArabic: product.metaKeywordsArabic,
          isPinned: product.isPinned,
          isSuggested: product.isSuggested,
          isFeatured: product.isFeatured,
          isBestseller: product.isBestseller,
          status: product.status,
        );
        fetchProducts();
        notifyListeners();

        return true;
      } else {
        LogService.error("Failed to add product: ${response['message']}");
        return false;
      }
    } catch (e) {
      LogService.error("addProduct() Error: $e");
      return false;
    }
  }

  // void toggleFavorite(String productId) {
  //   int index = _products.indexWhere((product) => product.id == productId);
  //   if (index != -1) {
  //     _products[index] = _products[index].copyWith(
  //       isFavorite: !_products[index].isFavorite,
  //     );
  //     notifyListeners();
  //   }
  // }

  Future<void> deleteProduct(int productId) async {
    try {
      final response = await ApiService.postWithAuth(
        'delete-vendor-products-details',
        {"id": productId},
      );

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          _products.removeWhere((product) => product.id == productId);
          notifyListeners();
        } else {
          throw Exception("Failed to delete product");
        }
      } else {
        throw Exception(
          "API Error: ${response?.statusCode} - ${response?.body}",
        );
      }
    } catch (e) {
      LogService.error("deleteProduct() Error: $e");
    }
  }
}
