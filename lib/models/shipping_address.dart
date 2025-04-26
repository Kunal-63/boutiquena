class ShippingAddress {
  final int? id;
  final int? userId;
  final String? name;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? mobile;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShippingAddress({
    this.id,
    this.userId,
    this.name,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.mobile,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      pincode: json['pincode'] as String?,
      mobile: json['mobile'] as String?,
      status: json['status'] as int?,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'mobile': mobile,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
