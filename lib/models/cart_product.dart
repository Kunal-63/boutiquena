class CartProduct {
  final int cartId;
  final int productId;
  final String productName;
  final double totalPrice;
  final String productImageUrl;
  final int attributeId;
  final String? attributeValue;
  int quantity; // Make mutable so you can update locally

  CartProduct({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.totalPrice,
    required this.productImageUrl,
    required this.attributeId,
    required this.attributeValue,
    required this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      cartId: json['cart_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      totalPrice:
          (json['total_price'] is String)
              ? double.tryParse(json['total_price']) ?? 0.0
              : json['total_price'] as double,
      productImageUrl: json['product_image_url'],
      attributeId: json['attribute_id'],
      attributeValue: json['attribute_value'],
      quantity: json['quantity'],
    );
  }
}
