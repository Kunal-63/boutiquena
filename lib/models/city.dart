class City {
  final int? id;
  final String? name;
  final String? nameHebrew;
  final String? nameArabic;
  final int? regionId;
  final int? pincode;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  City({
    this.id,
    this.name,
    this.nameHebrew,
    this.nameArabic,
    this.regionId,
    this.pincode,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      nameHebrew: json['name_hebrew'],
      nameArabic: json['name_arabic'],
      regionId: json['region_id'],
      pincode: json['pincode'],
      status: json['status'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  static List<City> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => City.fromJson(e)).toList();
  }
}
