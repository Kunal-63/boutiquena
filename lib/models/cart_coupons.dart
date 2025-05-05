class CartCouponResponse {
  final bool? status;
  final String? message;
  final List<CartCoupon>? coupons;

  CartCouponResponse({this.status, this.message, this.coupons});

  factory CartCouponResponse.fromJson(Map<String, dynamic> json) {
    return CartCouponResponse(
      status: json['status'],
      message: json['message'],
      coupons:
          (json['data']?['coupons'] as List<dynamic>?)
              ?.map((e) => CartCoupon.fromJson(e))
              .toList(),
    );
  }
}

class CartCoupon {
  final int? id;
  final String? code;
  final int? discountTypeId;
  final String? discountValue;
  final String? maxDiscount;
  final String? categoryId;
  final int? cityId;
  final String? expiryDate;
  final bool? isDeliveryFree;
  final String? description;

  CartCoupon({
    this.id,
    this.code,
    this.discountTypeId,
    this.discountValue,
    this.maxDiscount,
    this.categoryId,
    this.cityId,
    this.expiryDate,
    this.isDeliveryFree,
    this.description,
  });

  factory CartCoupon.fromJson(Map<String, dynamic> json) {
    return CartCoupon(
      id: json['id'],
      code: json['code'],
      discountTypeId: json['discount_type_id'],
      discountValue: json['discount_value'],
      maxDiscount: json['max_discount'],
      categoryId: json['category_id'],
      cityId: json['city_id'],
      expiryDate: json['expiry_date'],
      isDeliveryFree: json['is_delivery_free'] == 1,
      description: json['description'],
    );
  }
}
