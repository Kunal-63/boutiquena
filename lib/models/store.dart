class Store {
  final int? id;
  final String? name;
  final String? logo;
  final String? coverImage;
  final String? address;
  final String? detailedAddress;
  final int? storeType;
  final int? vendorId;
  final String? description;
  final int? pincode;
  final String? businessHours;
  final String? categoryIds;
  final String? storeLink;
  final int? isFeatured;
  final int? status;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final bool? isFollowed;
  final String? imagePath;
  final String? coverImageUrl;

  Store({
    this.id,
    this.name,
    this.logo,
    this.coverImage,
    this.address,
    this.detailedAddress,
    this.storeType,
    this.vendorId,
    this.description,
    this.pincode,
    this.businessHours,
    this.categoryIds,
    this.storeLink,
    this.isFeatured,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.isFollowed,
    this.imagePath,
    this.coverImageUrl,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json['id'],
    name: json['name'],
    logo: json['logo'],
    coverImage: json['cover_image'],
    address: json['address'],
    detailedAddress: json['detailed_address'],
    storeType: json['store_type'],
    vendorId: json['vendor_id'],
    description: json['description'],
    pincode: json['pincode'],
    businessHours: json['business_hours'],
    categoryIds: json['category_ids'],
    storeLink: json['store_link'],
    isFeatured: json['is_featured'],
    status: json['status'],
    createdBy: json['created_by'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    isFollowed: json['is_followed'],
    imagePath: json['image_path'],
    coverImageUrl: json['cover_image_url'],
  );
}
