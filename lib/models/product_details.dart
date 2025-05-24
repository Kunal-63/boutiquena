class ProductDetail {
  int? id;
  String? categoryId;
  int? vendorId;
  int? adminId;
  int? storeId;
  String? productName;
  String? productNameArabic;
  String? productNameHebrew;
  String? shortDescription;
  String? shortDescriptionHebrew;
  String? shortDescriptionArabic;
  String? productImage;
  String? productVideo;
  String? description;
  String? descriptionHebrew;
  String? descriptionArabic;
  String? metaTitle;
  String? metaTitleHebrew;
  String? metaTitleArabic;
  String? metaKeywords;
  String? metaKeywordsHebrew;
  String? metaKeywordsArabic;
  String? metaDescription;
  String? metaDescriptionHebrew;
  String? metaDescriptionArabic;
  String? isFeatured;
  String? isBestseller;
  String? isFavourite;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? statusId;
  String? isPinned;
  String? isSuggested;
  String? vendorPrice;
  String? adminCommission;
  String? totalPrice;
  String? storeName;
  String? imageUrl;
  String? imagesLargeUrl;
  String? imagesSmallUrl;
  String? imagesMediumUrl;
  List<ProductImage>? images;
  final List<Category>? categories;
  Map<String, List<SkuRecord>>? skuRecords;
  List<ProductAttribute>? productAttributes;
  bool? isInCart;
  CartData? cartData;
  bool? isInWishlist;
  WishlistData? wishlistData;

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
    this.storeName,
    this.imageUrl,
    this.imagesLargeUrl,
    this.imagesSmallUrl,
    this.imagesMediumUrl,
    this.images,
    this.categories,
    this.skuRecords,
    this.productAttributes,
    this.isInCart,
    this.cartData,
    this.isInWishlist,
    this.wishlistData,
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
      storeName: json['store_name'],
      imageUrl: json['image_url'],
      imagesLargeUrl: json['images_large_url'],
      imagesSmallUrl: json['images_small_url'],
      imagesMediumUrl: json['images_medium_url'],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList(),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],

      skuRecords: (json['sku'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => SkuRecord.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      productAttributes:
          (json['product_attributes'] as List<dynamic>?)
              ?.map((e) => ProductAttribute.fromJson(e))
              .toList(),
      isInCart: json['is_in_cart'],
      cartData:
          json['cart_data'] != null
              ? CartData.fromJson(json['cart_data'])
              : null,
      isInWishlist: json['is_in_wishlist'],
      wishlistData:
          json['wishlist_data'] != null
              ? WishlistData.fromJson(json['wishlist_data'])
              : null,
    );
  }
}

// Nested Models:

class ProductImage {
  int? id;
  int? productId;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

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

class SkuRecord {
  int? id;
  int? productId;
  int? productAttributeId;
  int? colorId;
  int? attributeTypeValueId;
  String? createdAt;
  String? updatedAt;
  String? attributeValueName;
  String? colorName;
  String? colorHex;
  int? price;
  String? sku;
  int? stock;
  int? attributeId;

  SkuRecord({
    this.id,
    this.productId,
    this.productAttributeId,
    this.colorId,
    this.attributeTypeValueId,
    this.createdAt,
    this.updatedAt,
    this.attributeValueName,
    this.colorName,
    this.colorHex,
    this.price,
    this.sku,
    this.stock,
    this.attributeId,
  });

  factory SkuRecord.fromJson(Map<String, dynamic> json) {
    return SkuRecord(
      id: json['id'],
      productId: json['product_id'],
      productAttributeId: json['product_attribute_id'],
      colorId: json['color_id'],
      attributeTypeValueId: json['attribute_type_value_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      attributeValueName: json['attribute_value_name'],
      colorName: json['color_name'],
      colorHex: json['color_hex'],
      price: json['price'],
      sku: json['sku'],
      stock: json['stock'],
      attributeId: json['attribute_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_attribute_id': productAttributeId,
      'color_id': colorId,
      'attribute_type_value_id': attributeTypeValueId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'attribute_value_name': attributeValueName,
      'color_name': colorName,
      'color_hex': colorHex,
      'price': price,
      'sku': sku,
      'stock': stock,
      'attribute_id': attributeId,
    };
  }
}

class Attribute {
  String? attributeName;
  String? attributeValue;
  int? attributeTypeId;
  int? attributeValueId;

  Attribute({
    this.attributeName,
    this.attributeValue,
    this.attributeTypeId,
    this.attributeValueId,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      attributeName: json['attribute_name'],
      attributeValue: json['attribute_value'],
      attributeTypeId: json['attribute_type_id'],
      attributeValueId: json['attribute_value_id'],
    );
  }
}

class ProductAttribute {
  String? attributeName;
  int? attributeTypeId;
  List<AttributeValue>? values;

  ProductAttribute({this.attributeName, this.attributeTypeId, this.values});

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      attributeName: json['attribute_name'],
      attributeTypeId: json['attribute_type_id'],
      values:
          (json['values'] as List<dynamic>?)
              ?.map((e) => AttributeValue.fromJson(e))
              .toList(),
    );
  }
}

class AttributeValue {
  int? attributeValueId;
  String? value;

  AttributeValue({this.attributeValueId, this.value});

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      attributeValueId: json['attribute_value_id'],
      value: json['value'],
    );
  }
}

class CartData {
  int? id;
  int? userId;
  int? productId;
  int? attributeId;
  int? quantity;
  String? createdAt;
  String? updatedAt;

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

class WishlistData {
  int? id;
  int? userId;
  int? productId;
  int? storeId;
  String? createdAt;
  String? updatedAt;

  WishlistData({
    this.id,
    this.userId,
    this.productId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Category {
  final int id;
  final int parentId;
  final int sectionId;
  final String categoryName;
  final String categoryImage;
  final int categoryDiscount;
  final String url;
  final String metaTitle;
  final String metaDescription;
  final String metaKeywords;

  Category({
    required this.id,
    required this.parentId,
    required this.sectionId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryDiscount,
    required this.url,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeywords,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
      sectionId: json['section_id'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
      categoryDiscount: json['category_discount'],
      url: json['url'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      metaKeywords: json['meta_keywords'],
    );
  }
}
