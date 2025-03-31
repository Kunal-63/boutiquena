class Product {
  final String? id;
  final String? categoryId;
  final String? vendorId;
  final String? adminId;
  final String? productName;
  final String? productCode;
  final String? productColor;
  final String? productPrice;
  final String? productDiscount;
  final String? productWeight;
  final String? productImage;
  final String? productVideo;
  final String? description;
  final String? newmancol;
  final String? operatingSystem;
  final String? screenSize;
  final String? occasion;
  final String? fit;
  final String? pattern;
  final String? sleeve;
  final String? ram;
  final String? fabric;
  final String? metaTitle;
  final String? metaKeywords;
  final String? metaDescription;
  final bool? isFeatured;
  final bool? isBestseller;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? statusId;
  final bool? isPinned;
  final bool isFavorite;

  // 🆕 Additional Fields
  final String? brand;
  final String? stock;
  final List<String>? tags;
  final String? tax;
  final String? warrantyPeriod;

  Product({
    this.id,
    this.categoryId,
    this.vendorId,
    this.adminId,
    this.productName,
    this.productCode,
    this.productColor,
    this.productPrice,
    this.productDiscount,
    this.productWeight,
    this.productImage,
    this.productVideo,
    this.description,
    this.newmancol,
    this.operatingSystem,
    this.screenSize,
    this.occasion,
    this.fit,
    this.pattern,
    this.sleeve,
    this.ram,
    this.fabric,
    this.metaTitle,
    this.metaKeywords,
    this.metaDescription,
    this.isFeatured,
    this.isBestseller,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.statusId,
    this.isPinned,
    this.brand,
    this.stock,
    this.tags,
    this.tax,
    this.warrantyPeriod,
    this.isFavorite = false,
  });

  // ✅ Convert Product to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category_id": categoryId,
      "vendor_id": vendorId,
      "admin_id": adminId,
      "product_name": productName,
      "product_code": productCode,
      "product_color": productColor,
      "product_price": productPrice?.toString(),
      "product_discount": productDiscount?.toString(),
      "product_weight": productWeight?.toString(),
      "product_image": productImage,
      "product_video": productVideo,
      "description": description,
      "newmancol": newmancol,
      "operating_system": operatingSystem,
      "screen_size": screenSize,
      "occasion": occasion,
      "fit": fit,
      "pattern": pattern,
      "sleeve": sleeve,
      "ram": ram,
      "fabric": fabric,
      "meta_title": metaTitle,
      "meta_keywords": metaKeywords,
      "meta_description": metaDescription,
      "is_featured": isFeatured == true ? "1" : "0",
      "is_bestseller": isBestseller == true ? "1" : "0",
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "status_id": statusId,
      "is_pinned": isPinned == true ? "1" : "0",
      "brand": brand,
      "stock": stock?.toString(),
      "tags": tags?.join(","),
      "tax": tax?.toString(),
      "warranty_period": warrantyPeriod,
    };
  }

  // ✅ Convert JSON to Product (for API response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      vendorId: json['vendor_id'],
      adminId: json['admin_id'],
      productName: json['product_name'],
      productCode: json['product_code'],
      productColor: json['product_color'],
      productPrice: json['product_price']?.toString(),
      productDiscount: json['product_discount']?.toString(),
      productWeight: json['product_weight'].toString(),

      productImage: json['product_image'],
      productVideo: json['product_video'],
      description: json['description'],
      newmancol: json['newmancol'],
      operatingSystem: json['operating_system'],
      screenSize: json['screen_size'],
      occasion: json['occasion'],
      fit: json['fit'],
      pattern: json['pattern'],
      sleeve: json['sleeve'],
      ram: json['ram'],
      fabric: json['fabric'],
      metaTitle: json['meta_title'],
      metaKeywords: json['meta_keywords'],
      metaDescription: json['meta_description'],
      isFeatured: json['is_featured'] == "1",
      isBestseller: json['is_bestseller'] == "1",
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      statusId: json['status_id'],
      isPinned: json['is_pinned'] == "1",
      brand: json['brand'],
      stock: (json['stock'].toString()),
      tags: json['tags'] != null ? json['tags'].split(",") : [],
      tax: json['tax'].toString(),
      warrantyPeriod: json['warranty_period'],
    );
  }

  // ✅ Copy Product with Updated Fields
  Product copyWith({
    String? id,
    String? categoryId,
    String? vendorId,
    String? adminId,
    String? productName,
    String? productCode,
    String? productColor,
    String? productPrice,
    String? productDiscount,
    String? productWeight,
    String? productImage,
    String? productVideo,
    String? description,
    String? newmancol,
    String? operatingSystem,
    String? screenSize,
    String? occasion,
    String? fit,
    String? pattern,
    String? sleeve,
    String? ram,
    String? fabric,
    String? metaTitle,
    String? metaKeywords,
    String? metaDescription,
    bool? isFeatured,
    bool? isBestseller,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? statusId,
    bool? isPinned,
    String? brand,
    String? stock,
    List<String>? tags,
    String? tax,
    String? warrantyPeriod,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      vendorId: vendorId ?? this.vendorId,
      adminId: adminId ?? this.adminId,
      productName: productName ?? this.productName,
      productCode: productCode ?? this.productCode,
      productColor: productColor ?? this.productColor,
      productPrice: productPrice ?? this.productPrice,
      productDiscount: productDiscount ?? this.productDiscount,
      productWeight: productWeight ?? this.productWeight,
      productImage: productImage ?? this.productImage,
      productVideo: productVideo ?? this.productVideo,
      description: description ?? this.description,
      newmancol: newmancol ?? this.newmancol,
      operatingSystem: operatingSystem ?? this.operatingSystem,
      screenSize: screenSize ?? this.screenSize,
      occasion: occasion ?? this.occasion,
      fit: fit ?? this.fit,
      pattern: pattern ?? this.pattern,
      sleeve: sleeve ?? this.sleeve,
      ram: ram ?? this.ram,
      fabric: fabric ?? this.fabric,
      metaTitle: metaTitle ?? this.metaTitle,
      metaKeywords: metaKeywords ?? this.metaKeywords,
      metaDescription: metaDescription ?? this.metaDescription,
      isFeatured: isFeatured ?? this.isFeatured,
      isBestseller: isBestseller ?? this.isBestseller,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusId: statusId ?? this.statusId,
      isPinned: isPinned ?? this.isPinned,
      brand: brand ?? this.brand,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
      tax: tax ?? this.tax,
      warrantyPeriod: warrantyPeriod ?? this.warrantyPeriod,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
