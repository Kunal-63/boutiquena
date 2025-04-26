class TopCategory {
  final String? id;
  final String? parentId;
  final String? sectionId;
  final String? categoryName;
  final String? categoryImage;
  final String? categoryDiscount;
  final String? description;
  final String? url;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaKeywords;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final List<TopCategory>? subCategories;

  TopCategory({
    this.id,
    this.parentId,
    this.sectionId,
    this.categoryName,
    this.categoryImage,
    this.categoryDiscount,
    this.description,
    this.url,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.subCategories,
  });

  factory TopCategory.fromJson(Map<String, dynamic> json) {
    return TopCategory(
      id: json['id']?.toString(),
      parentId: json['parent_id']?.toString(),
      sectionId: json['section_id']?.toString(),
      categoryName: json['category_name']?.toString(),
      categoryImage: json['category_image']?.toString(),
      categoryDiscount: json['category_discount']?.toString(),
      description: json['description']?.toString(),
      url: json['url']?.toString(),
      metaTitle: json['meta_title']?.toString(),
      metaDescription: json['meta_description']?.toString(),
      metaKeywords: json['meta_keywords']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      subCategories:
          (json['sub_categories'] as List<dynamic>?)
              ?.map((e) => TopCategory.fromJson(e))
              .toList(),
    );
  }
}
