import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:customer_app/models/product.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

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
          _products = (data['data'] as List)
              .map(
                (item) => Product(
                  id: item['id'],
                  categoryId: item['category_id'],
                  vendorId: item['vendor_id'],
                  adminId: item['admin_id'],
                  productName: item['product_name'],
                  productCode: item['product_code'],
                  productColor: item['product_color'],
                  productPrice: item['product_price'],
                  productDiscount: item['product_discount'],
                  productWeight: item['product_weight'],
                  productImage: item['product_image'],
                  productVideo: item['product_video'],
                  description: item['description'],
                  newmancol: item['newmancol'],
                  operatingSystem: item['operating_system'],
                  screenSize: item['screen_size'],
                  occasion: item['occasion'],
                  fit: item['fit'],
                  pattern: item['pattern'],
                  sleeve: item['sleeve'],
                  ram: item['ram'],
                  fabric: item['fabric'],
                  metaTitle: item['meta_title'],
                  metaKeywords: item['meta_keywords'],
                  metaDescription: item['meta_description'],
                  isFeatured: item['is_featured'],
                  isBestseller: item['is_bestseller'],
                  status: item['status'],
                  createdAt: item['created_at'],
                  updatedAt: item['updated_at'],
                  statusId: item['status_id'],
                  isPinned: item['is_pinned'],
                ),
              )
              .toList();
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

  Future<bool> addProduct(Product product) async {
    try {
      final response = await ApiService.postWithAuth('add-vendor-products', {
        "category_id": product.categoryId ?? "1",
        "product_name": product.productName ?? "Testing",
        "product_code": product.productCode ?? "",
        "product_color": product.productColor ?? "Black",
        "product_price": product.productPrice ?? "100",
        "product_discount": product.productDiscount ?? "10",
        "product_weight": product.productWeight ?? "15",
        "product_video": product.productVideo ?? "",
        "description": product.description ?? "description",
        "newmancol": product.newmancol ?? "",
        "operating_system": product.operatingSystem ?? "testing",
        "screen_size": product.screenSize ?? "",
        "occasion": product.occasion ?? "tesitng",
        "fit": product.fit ?? "testing",
        "pattern": product.pattern ?? "testing",
        "sleeve": product.sleeve ?? "testing",
        "ram": product.ram ?? "testing",
        "fabric": product.fabric ?? "testing",
        "is_featured": product.isFeatured ?? "0",
        "is_bestseller": product.isBestseller ?? "0",
        "is_pinned": product.isPinned ?? "0",
      });

      if (response['status'] == true) {
        final newProduct = Product(
          id: response['data']['id'].toString(),
          categoryId: product.categoryId,
          productName: product.productName,
          productCode: product.productCode,
          productColor: product.productColor,
          productPrice: product.productPrice,
          productDiscount: product.productDiscount,
          productWeight: product.productWeight,
          productVideo: product.productVideo,
          description: product.description,
          newmancol: product.newmancol,
          operatingSystem: product.operatingSystem,
          screenSize: product.screenSize,
          occasion: product.occasion,
          fit: product.fit,
          pattern: product.pattern,
          sleeve: product.sleeve,
          ram: product.ram,
          fabric: product.fabric,
          isFeatured: product.isFeatured,
          isBestseller: product.isBestseller,
          isPinned: product.isPinned,
        );

        _products.add(newProduct);
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

  void toggleFavorite(String productId) {
    int index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        isFavorite: !_products[index].isFavorite,
      );
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
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
