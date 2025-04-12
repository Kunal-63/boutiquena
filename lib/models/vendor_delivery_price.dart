class VendorDeliveryPrice {
  final int? id;
  final int? vendor;
  final int? regionId;
  final double? price;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VendorDeliveryPrice({
    this.id,
    this.vendor,
    this.regionId,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON
  factory VendorDeliveryPrice.fromJson(Map<String, dynamic> json) {
    return VendorDeliveryPrice(
      id: json["id"] as int?,
      vendor: json["vendor"] as int?,
      regionId: _parseRegionId(json["regions"]),
      price: _parsePrice(json["price"]),
      status: json["status"] as int?,
      createdAt:
          json["created_at"] != null
              ? DateTime.tryParse(json["created_at"])
              : null,
      updatedAt:
          json["updated_at"] != null
              ? DateTime.tryParse(json["updated_at"])
              : null,
    );
  }

  // Helper function to parse regionId safely
  static int? _parseRegionId(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return int.tryParse(value);
    }
    return value as int?;
  }

  // Helper function to parse price safely as num (String or double)
  static double? _parsePrice(dynamic value) {
    if (value == null) return null;

    // If the value is a String, try to parse it as a double
    if (value is String) {
      return double.tryParse(value);
    }

    // If the value is already an int, convert it to double
    if (value is int) {
      return value.toDouble();
    }

    // Otherwise, assume it's a valid double or return null if not
    return value as double?;
  }

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vendor": vendor,
      "regions": regionId, // Sending `regionId` as `regions`
      "price": price,
      "status": status,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  // Convert list from JSON
  static List<VendorDeliveryPrice> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => VendorDeliveryPrice.fromJson(json)).toList();
  }
}
