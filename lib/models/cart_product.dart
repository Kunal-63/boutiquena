class CartProduct {
  final int cartId;
  final int productId;
  final String productName;
  final String totalPrice;
  final String productImageUrl;
  final int attributeId;
  final int storeId;
  final String? attributeValue;
  final int quantity;
  final double finalPrice;

  CartProduct({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.totalPrice,
    required this.productImageUrl,
    required this.attributeId,
    required this.storeId,
    required this.attributeValue,
    required this.quantity,
    required this.finalPrice,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      cartId: json['cart_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      totalPrice: json['total_price'],
      productImageUrl: json['product_image_url'],
      attributeId: json['attribute_id'],
      storeId: json['store_id'],
      attributeValue: json['attribute_value'],
      quantity: json['quantity'],
      finalPrice: (json['final_price'] as num).toDouble(),
    );
  }
}
