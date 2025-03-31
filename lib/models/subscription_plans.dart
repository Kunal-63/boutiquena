
class SubscriptionPlan {
  final int id;
  final String name;
  final String description;
  final int limit;
  final int commission;
  final double price;
  final double offerPrice;
  final bool featuredProducts;
  final bool customerSupport;
  final bool orderTracking;
  final bool notifications;
  final bool promotions;
  final bool homePromotions;
  final bool socialPromotions;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.limit,
    required this.commission,
    required this.price,
    required this.offerPrice,
    required this.featuredProducts,
    required this.customerSupport,
    required this.orderTracking,
    required this.notifications,
    required this.promotions,
    required this.homePromotions,
    required this.socialPromotions,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      limit: json['limit'],
      commission: json['commission'],
      price: json['price'].toDouble(),
      offerPrice: json['offer_price'].toDouble(),
      featuredProducts: json['featured_products'] == 1,
      customerSupport: json['customer_support'] == 1,
      orderTracking: json['order_tracking'] == 1,
      notifications: json['notifications'] == 1,
      promotions: json['promotions'] == 1,
      homePromotions: json['home_promotions'] == 1,
      socialPromotions: json['social_promotions'] == 1,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'limit': limit,
      'commission': commission,
      'price': price,
      'offer_price': offerPrice,
      'featured_products': featuredProducts ? 1 : 0,
      'customer_support': customerSupport ? 1 : 0,
      'order_tracking': orderTracking ? 1 : 0,
      'notifications': notifications ? 1 : 0,
      'promotions': promotions ? 1 : 0,
      'home_promotions': homePromotions ? 1 : 0,
      'social_promotions': socialPromotions ? 1 : 0,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
