import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vendor_app/models/product.dart';
import 'package:vendor_app/models/product_details.dart';
import 'package:vendor_app/services/api_service.dart';
import 'package:vendor_app/services/log_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? productImageURL;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductDetail? _selectedProductDetail;
  ProductDetail? get selectedProductDetail => _selectedProductDetail;

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

          productImageURL = data['data']['image_url'];
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

  Future<void> fetchProductDetailById(int id) async {
    try {
      final response = await ApiService.getWithAuth(
        'get-vendor-products-details/$id',
      );

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
    ProductDetail product,
    List<File>? selectedImages,
    File? selectedImage,
    List<int>? keepImageIds,
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
          "is_pinned": product.isPinned ?? "No",
          "is_suggested": product.isSuggested ?? "No",
          "is_featured": product.isFeatured ?? "No",
          "is_bestseller": product.isBestseller ?? "No",
          "status": product.status ?? "1",
          if (keepImageIds != null && keepImageIds.isNotEmpty)
            "keep_image_ids": keepImageIds.map((id) => id.toString()).join(','),
        },
        files: {"product_image": selectedImage},
        multipleFiles: {"product_images": selectedImages ?? []},
      );

      if (response['status'] == true) {
        fetchProducts();
        notifyListeners();
        return true;
      } else {
        LogService.error("Failed to update product: ${response['message']}");
        return false;
      }
    } catch (e) {
      LogService.error("updateProduct() Error: $e");
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
