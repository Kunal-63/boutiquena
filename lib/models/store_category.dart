class StoreCategory {
  final int? id;
  final String? name;
  final String? status;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  StoreCategory({
    this.id,
    this.name,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      id: json['id'],
      name: json['name'].toString(),
      status: json['status'].toString(),
      createdBy: json['created_by'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
    );
  }
}
