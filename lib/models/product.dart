class Product {
  final int? id;
  final int? categoryId;
  final int? vendorId;
  final int? adminId;
  final String? productName;
  final String? productNameArabic;
  final String? productNameHebrew;
  final String? shortDescription;
  final String? shortDescriptionArabic;
  final String? shortDescriptionHebrew;
  final String?
  productImage; // Originally a list in string format (e.g. "[]"), still using String
  final String? productVideo;
  final String? description;
  final String? descriptionArabic;
  final String? descriptionHebrew;
  final String? metaTitle;
  final String? metaTitleArabic;
  final String? metaTitleHebrew;
  final String? metaKeywords;
  final String? metaKeywordsArabic;
  final String? metaKeywordsHebrew;
  final String? metaDescription;
  final String? metaDescriptionArabic;
  final String? metaDescriptionHebrew;
  final String? isFeatured;
  final String? isBestseller;
  final String? isFavourite;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? statusId;
  final String? isPinned;
  final String? isSuggested;
  final double? vendorPrice;
  final String? adminCommission;
  final String? totalPrice;

  Product({
    this.id,
    this.categoryId,
    this.vendorId,
    this.adminId,
    this.productName,
    this.productNameArabic,
    this.productNameHebrew,
    this.shortDescription,
    this.shortDescriptionArabic,
    this.shortDescriptionHebrew,
    this.productImage,
    this.productVideo,
    this.description,
    this.descriptionArabic,
    this.descriptionHebrew,
    this.metaTitle,
    this.metaTitleArabic,
    this.metaTitleHebrew,
    this.metaKeywords,
    this.metaKeywordsArabic,
    this.metaKeywordsHebrew,
    this.metaDescription,
    this.metaDescriptionArabic,
    this.metaDescriptionHebrew,
    this.isFeatured,
    this.isBestseller,
    this.isFavourite,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.statusId,
    this.isPinned,
    this.isSuggested,
    this.vendorPrice,
    this.adminCommission,
    this.totalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      vendorId: json['vendor_id'],
      adminId: json['admin_id'],
      productName: json['product_name'],
      productNameArabic: json['product_name_arabic'],
      productNameHebrew: json['product_name_hebrew'],
      shortDescription: json['short_description'],
      shortDescriptionArabic: json['short_description_arabic'],
      shortDescriptionHebrew: json['short_description_hebrew'],
      productImage: json['product_image'],
      productVideo: json['product_video'],
      description: json['description'],
      descriptionArabic: json['description_arabic'],
      descriptionHebrew: json['description_hebrew'],
      metaTitle: json['meta_title'],
      metaTitleArabic: json['meta_title_arabic'],
      metaTitleHebrew: json['meta_title_hebrew'],
      metaKeywords: json['meta_keywords'],
      metaKeywordsArabic: json['meta_keywords_arabic'],
      metaKeywordsHebrew: json['meta_keywords_hebrew'],
      metaDescription: json['meta_description'],
      metaDescriptionArabic: json['meta_description_arabic'],
      metaDescriptionHebrew: json['meta_description_hebrew'],
      isFeatured: json['is_featured'] ?? 'No',
      isBestseller: json['is_bestseller'] ?? 'No',
      isFavourite: json['is_favourite'] ?? 'No',
      status: json['status'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      statusId: json['status_id'],
      isPinned: json['is_pinned'] ?? 'No',
      isSuggested: json['is_suggested'] ?? 'No',
      vendorPrice: double.parse(json['vendor_price'].toString()),
      adminCommission: json['admin_commission'],
      totalPrice: json['total_price'],
    );
  }
}
