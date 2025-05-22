class TopCategory {
  final int? id;
  final int? parentId;
  final int? sectionId;
  final String? categoryName;
  final String? categoryNameHebrew;
  final String? categoryNameArabic;
  final String? categoryImage;
  final int? categoryDiscount;
  final String? description;
  final String? url;
  final String? metaTitle;
  final String? metaTitleHebrew;
  final String? metaTitleArabic;
  final String? metaDescription;
  final String? metaDescriptionHebrew;
  final String? metaDescriptionArabic;
  final String? metaKeywords;
  final String? metaKeywordsHebrew;
  final String? metaKeywordsArabic;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final List<TopCategory>? subCategories;

  TopCategory({
    this.id,
    this.parentId,
    this.sectionId,
    this.categoryName,
    this.categoryNameHebrew,
    this.categoryNameArabic,
    this.categoryImage,
    this.categoryDiscount,
    this.description,
    this.url,
    this.metaTitle,
    this.metaTitleHebrew,
    this.metaTitleArabic,
    this.metaDescription,
    this.metaDescriptionHebrew,
    this.metaDescriptionArabic,
    this.metaKeywords,
    this.metaKeywordsHebrew,
    this.metaKeywordsArabic,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.subCategories,
  });

  factory TopCategory.fromJson(Map<String, dynamic> json) {
    return TopCategory(
      id: json['id'],
      parentId: json['parent_id'],
      sectionId: json['section_id'],
      categoryName: json['category_name'],
      categoryNameHebrew: json['category_name_hebrew'],
      categoryNameArabic: json['category_name_arabic'],
      categoryImage: json['category_image'],
      categoryDiscount: json['category_discount'],
      description: json['description'],
      url: json['url'],
      metaTitle: json['meta_title'],
      metaTitleHebrew: json['meta_title_hebrew'],
      metaTitleArabic: json['meta_title_arabic'],
      metaDescription: json['meta_description'],
      metaDescriptionHebrew: json['meta_description_hebrew'],
      metaDescriptionArabic: json['meta_description_arabic'],
      metaKeywords: json['meta_keywords'],
      metaKeywordsHebrew: json['meta_keywords_hebrew'],
      metaKeywordsArabic: json['meta_keywords_arabic'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subCategories:
          (json['sub_categories'] as List<dynamic>?)
              ?.map((e) => TopCategory.fromJson(e))
              .toList(),
    );
  }
}
