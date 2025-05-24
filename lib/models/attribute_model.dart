class AttributeType {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AttributeType({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory AttributeType.fromJson(Map<String, dynamic> json) {
    return AttributeType(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  static List<AttributeType> listFromJson(List<dynamic> list) {
    return list.map((e) => AttributeType.fromJson(e)).toList();
  }
}
