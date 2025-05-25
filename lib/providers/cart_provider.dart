import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:customer_app/models/cart_coupons.dart';
import 'package:customer_app/models/cart_group.dart';
import 'package:customer_app/models/cart_product.dart';
import 'package:customer_app/services/api_service.dart';
import 'package:customer_app/services/log_service.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  bool isLoading = false;
  static List<CartProduct> cartItems = [];

  double deliveryCharges = 0;
  double cartValue = 0;
  double tax = 0;
  double totalCartValue = 0;

  static List<int> selectedGroupIds = [];
  static List<int> selectedStoreIds = [];
  static int? selectedCouponId;
  static int? selectedShippingId;
  static String? selectedPaymentMethod;
  static int? selectedVoucherId;

  List<CartGroup>? mergeableGroups;
  List<CartCoupon>? coupons;

  Future<void> fetchCart() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.postWithAuth('listCart', {
        if (selectedShippingId != null) 'shipping_id': selectedShippingId,
        if (selectedGroupIds.isNotEmpty)
          'group_ids': selectedGroupIds.join(','),
        if (selectedStoreIds.isNotEmpty)
          'store_ids': selectedStoreIds.join(','),
        if (selectedCouponId != null) 'discount': selectedCouponId,
        if (selectedVoucherId != null) 'voucher_id': selectedVoucherId,
      });

      if (response != null && response['status'] == true) {
        final data = response['data'] ?? {};
        final List<dynamic> items = data['cartData'] ?? [];

        cartItems = items.map((item) => CartProduct.fromJson(item)).toList();

        deliveryCharges = (data['deliveryCharges'] as num?)?.toDouble() ?? 0;
        cartValue = (data['cart_value'] as num?)?.toDouble() ?? 0;
        tax = (data['tax'] as num?)?.toDouble() ?? 0;
        totalCartValue = (data['total_cart_value'] as num?)?.toDouble() ?? 0;
      } else {
        LogService.error('Cart fetch failed: ${response?['message']}');
      }
    } catch (e, stackTrace) {
      LogService.error('Cart fetch error: $e\n$stackTrace');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCartGroups() async {
    try {
      final response = await ApiService.getWithAuth('ListCartGroups');

      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> groupsData =
            decoded['data']?['mergeable_groups'] ?? [];

        mergeableGroups = groupsData.map((g) => CartGroup.fromJson(g)).toList();
        notifyListeners();
      } else {
        LogService.error('Cart groups fetch failed: ${response?.body}');
      }
    } catch (e, stackTrace) {
      LogService.error('Cart groups fetch error: $e\n$stackTrace');
    }
  }

  Future<void> fetchCartCoupons() async {
    try {
      final response = await ApiService.getWithAuth('ListCartCoupons');

      if (response != null && response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == false) {
          LogService.error('Coupons fetch failed: ${decoded['message']}');
          return;
        }
        final List<dynamic> couponList = decoded['data']?['coupons'] ?? [];
        coupons = couponList.map((e) => CartCoupon.fromJson(e)).toList();
        notifyListeners();
      } else {
        LogService.error('Coupons fetch failed: ${response?.body}');
      }
    } catch (e, stackTrace) {
      LogService.error('Coupons fetch error: $e\n$stackTrace');
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
        await fetchCart();
      } else {
        LogService.error('Add to cart failed: ${response?['message']}');
      }
    } catch (e, stackTrace) {
      LogService.error('Add to cart error: $e\n$stackTrace');
    }
  }

  Future<bool> updateCart({required int cartId, required int quantity}) async {
    try {
      final response = await ApiService.postWithAuth(
        'update-quantity/$cartId',
        {'quantity': quantity},
      );

      if (response != null && response['status'] == true) {
        await fetchCart();
        return true;
      } else {
        LogService.error('Update cart failed: ${response?['message']}');
      }
    } catch (e, stackTrace) {
      LogService.error('Update cart error: $e\n$stackTrace');
    }
    return false;
  }

  Future<void> deleteCart({required int cartId}) async {
    try {
      final response = await ApiService.deleteWithAuth('deleteCart/$cartId');

      if (response != null && response.statusCode == 200) {
        cartItems.removeWhere((item) => item.cartId == cartId);
        notifyListeners();
      } else {
        LogService.error('Delete cart failed: ${response?.body}');
      }
    } catch (e, stackTrace) {
      LogService.error('Delete cart error: $e\n$stackTrace');
    }
  }

  Future<void> nullifyCart() async {
    cartItems = [];
    deliveryCharges = 0;
    cartValue = 0;
    tax = 0;
    totalCartValue = 0;
    selectedGroupIds = [];
    selectedStoreIds = [];
    selectedCouponId = null;
    selectedShippingId = null;
    mergeableGroups = null;
    coupons = null;
    selectedPaymentMethod = null;
    notifyListeners();
  }

  Future<bool> checkout({
    required String paymentId,
    required String additionalComments,
  }) async {
    try {
      final body = {
        if (selectedShippingId != null) 'shipping_id': selectedShippingId,
        if (selectedGroupIds.isNotEmpty)
          'group_ids': selectedGroupIds.join(','),
        if (selectedStoreIds.isNotEmpty)
          'store_ids': selectedStoreIds.join(','),
        if (selectedCouponId != null) 'discount_id': selectedCouponId,
        if (selectedPaymentMethod != null)
          'payment_method': selectedPaymentMethod,
        'payment_id': paymentId,
        'payment_gateway': 'PayPal', // Replace with dynamic if needed later
        'additional_comments': additionalComments,
        if (selectedVoucherId != null) 'voucher_id': selectedVoucherId,
        // if (coins != null) 'coins': coins, // Uncomment if coins implemented
      };

      final response = await ApiService.postWithAuth('checkout', body);

      if (response != null && response['status'] == true) {
        LogService.info('Checkout successful');
        return true;
      } else {
        LogService.error('Checkout failed: ${response?['message']}');
      }
    } catch (e, stackTrace) {
      LogService.error('Checkout error: $e\n$stackTrace');
    } finally {
      return false;
    }
  }
}
