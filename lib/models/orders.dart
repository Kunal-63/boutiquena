class Order {
  final String? id;
  final String? userId;
  final String? name;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? mobile;
  final String? email;
  final String? shippingCharges;
  final String? couponCode;
  final String? couponAmount;
  final String? orderStatus;
  final String? paymentMethod;
  final String? paymentGateway;
  final String? grandTotal;
  final String? courierName;
  final String? trackingNumber;
  final bool? isPushed;
  final String? createdAt;
  final String? updatedAt;
  final String? vendorId;
  final String? storeId;

  Order({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.mobile,
    this.email,
    this.shippingCharges,
    this.couponCode,
    this.couponAmount,
    this.orderStatus,
    this.paymentMethod,
    this.paymentGateway,
    this.grandTotal,
    this.courierName,
    this.trackingNumber,
    this.isPushed,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
    this.storeId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"]?.toString(),
      userId: json["user_id"]?.toString(),
      name: json["name"] as String?,
      address: json["address"] as String?,
      city: json["city"] as String?,
      state: json["state"] as String?,
      country: json["country"] as String?,
      pincode: json["pincode"] as String?,
      mobile: json["mobile"] as String?,
      email: json["email"] as String?,
      shippingCharges: json["shipping_charges"]?.toString(),
      couponCode: json["coupon_code"] as String?,
      couponAmount: json["coupon_amount"]?.toString(),
      orderStatus: json["order_status"] as String?,
      paymentMethod: json["payment_method"] as String?,
      paymentGateway: json["payment_gateway"] as String?,
      grandTotal: json["grand_total"]?.toString(),
      courierName: json["courier_name"] as String?,
      trackingNumber: json["tracking_number"] as String?,
      isPushed: json["is_pushed"] == "1" || json["is_pushed"] == 1,
      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),
      vendorId: json["vendor_id"]?.toString(),
      storeId: json["store_id"]?.toString(),
    );
  }

  static List<Order> listFromJson(List<dynamic> list) {
    return list
        .map((json) => Order.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
