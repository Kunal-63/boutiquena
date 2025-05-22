class CartProduct {
  final int? cartId;
  final int? productId;
  final String? productName;
  final String? productNameHebrew;
  final String? productNameArabic;
  final double? totalPrice;
  final String? productImageUrl;
  final String? productImage;
  final int? attributeId;
  final int? storeId;
  final String? attributeValue;
  final int? quantity;
  final double? finalPrice;
  final bool? qtyAvailable;
  final int? availableStock;

  CartProduct({
    this.cartId,
    this.productId,
    this.productName,
    this.productNameHebrew,
    this.productNameArabic,
    this.totalPrice,
    this.productImageUrl,
    this.productImage,
    this.attributeId,
    this.storeId,
    this.attributeValue,
    this.quantity,
    this.finalPrice,
    this.qtyAvailable,
    this.availableStock,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      cartId: json['cart_id'] as int?,
      productId: json['product_id'] as int?,
      productName: json['product_name'] as String?,
      productNameHebrew: json['product_name_hebrew'] as String?,
      productNameArabic: json['product_name_arabic'] as String?,
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      productImageUrl: json['product_image_url'] as String?,
      productImage: json['product_image'] as String?,
      attributeId: json['attribute_id'] as int?,
      storeId: json['store_id'] as int?,
      attributeValue: json['attribute_value'] as String?,
      quantity: json['quantity'] as int?,
      finalPrice: (json['final_price'] as num?)?.toDouble(),
      qtyAvailable: json['qty_available'] as bool?,
      availableStock: json['available_stock'] as int?,
    );
  }
}
