class ProductDetail {
  final int? id;
  final String? categoryId;
  final int? vendorId;
  final int? adminId;
  final int? storeId;
  final String? productName;
  final String? productNameArabic;
  final String? productNameHebrew;
  final String? shortDescription;
  final String? shortDescriptionHebrew;
  final String? shortDescriptionArabic;
  String? productImage;
  final String? productVideo;
  final String? description;
  final String? descriptionHebrew;
  final String? descriptionArabic;
  final String? metaTitle;
  final String? metaTitleHebrew;
  final String? metaTitleArabic;
  final String? metaKeywords;
  final String? metaKeywordsHebrew;
  final String? metaKeywordsArabic;
  final String? metaDescription;
  final String? metaDescriptionHebrew;
  final String? metaDescriptionArabic;
  final String? isFeatured;
  final String? isBestseller;
  final String? isFavourite;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final int? statusId;
  final String? isPinned;
  final String? isSuggested;
  final String? vendorPrice;
  final String? adminCommission;
  final String? totalPrice;
  final List<ProductImage>? images;
  final String? imageUrl;
  final String? imagesLargeUrl;
  final String? imagesSmallUrl;
  final String? imagesMediumUrl;
  final Map<String, int>? categories;
  final Map<String, List<AttributeValue>>? attributes;
  final bool? isInCart;
  final CartData? cartData;

  ProductDetail({
    this.id,
    this.categoryId,
    this.vendorId,
    this.adminId,
    this.storeId,
    this.productName,
    this.productNameArabic,
    this.productNameHebrew,
    this.shortDescription,
    this.shortDescriptionHebrew,
    this.shortDescriptionArabic,
    this.productImage,
    this.productVideo,
    this.description,
    this.descriptionHebrew,
    this.descriptionArabic,
    this.metaTitle,
    this.metaTitleHebrew,
    this.metaTitleArabic,
    this.metaKeywords,
    this.metaKeywordsHebrew,
    this.metaKeywordsArabic,
    this.metaDescription,
    this.metaDescriptionHebrew,
    this.metaDescriptionArabic,
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
    this.images,
    this.imageUrl,
    this.imagesLargeUrl,
    this.imagesSmallUrl,
    this.imagesMediumUrl,
    this.categories,
    this.attributes,
    this.isInCart,
    this.cartData,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      categoryId: json['category_id'],
      vendorId: json['vendor_id'],
      adminId: json['admin_id'],
      storeId: json['store_id'],
      productName: json['product_name'],
      productNameArabic: json['product_name_arabic'],
      productNameHebrew: json['product_name_hebrew'],
      shortDescription: json['short_description'],
      shortDescriptionHebrew: json['short_description_hebrew'],
      shortDescriptionArabic: json['short_description_arabic'],
      productImage: json['product_image'],
      productVideo: json['product_video'],
      description: json['description'],
      descriptionHebrew: json['description_hebrew'],
      descriptionArabic: json['description_arabic'],
      metaTitle: json['meta_title'],
      metaTitleHebrew: json['meta_title_hebrew'],
      metaTitleArabic: json['meta_title_arabic'],
      metaKeywords: json['meta_keywords'],
      metaKeywordsHebrew: json['meta_keywords_hebrew'],
      metaKeywordsArabic: json['meta_keywords_arabic'],
      metaDescription: json['meta_description'],
      metaDescriptionHebrew: json['meta_description_hebrew'],
      metaDescriptionArabic: json['meta_description_arabic'],
      isFeatured: json['is_featured'],
      isBestseller: json['is_bestseller'],
      isFavourite: json['is_favourite'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      statusId: json['status_id'],
      isPinned: json['is_pinned'],
      isSuggested: json['is_suggested'],
      vendorPrice: json['vendor_price'],
      adminCommission: json['admin_commission'],
      totalPrice: json['total_price'],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((image) => ProductImage.fromJson(image))
              .toList(),
      imageUrl: json['image_url'],
      imagesLargeUrl: json['images_large_url'],
      imagesSmallUrl: json['images_small_url'],
      imagesMediumUrl: json['images_medium_url'],
      categories:
          json['categories'] != null
              ? Map<String, int>.from(json['categories'])
              : null,
      attributes:
          (json['attritubes'] != null &&
                  json['attritubes'] != {} &&
                  json['attributes'] != [])
              ? (json['attritubes'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  (value as List<dynamic>)
                      .map((item) => AttributeValue.fromJson(item))
                      .toList(),
                ),
              )
              : null,
      isInCart: json['is_in_cart'],
      cartData:
          json['cart_data'] != null
              ? CartData.fromJson(json['cart_data'])
              : null,
    );
  }
}

class ProductImage {
  final int? id;
  final int? productId;
  final String? image;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  ProductImage({
    this.id,
    this.productId,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class AttributeValue {
  final int? id;
  final String? value;

  AttributeValue({this.id, this.value});

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(id: json['id'], value: json['value']);
  }
}

class CartData {
  final int? id;
  final int? userId;
  final int? productId;
  final int? attributeId;
  final int? quantity;
  final String? createdAt;
  final String? updatedAt;

  CartData({
    this.id,
    this.userId,
    this.productId,
    this.attributeId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      attributeId: json['attribute_id'],
      quantity: json['quantity'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
