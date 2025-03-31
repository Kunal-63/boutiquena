class VendorProfile {
  final String? id;
  final String? name;
  final String? image;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? mobile;
  final String? otp;
  final String? accessToken;
  final String? storeId;
  final String? email;
  final String? password;
  final int? subscriptionId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? imagePath;
  final String? subscriptionsName;
  final StoreDetails? storeDetails;

  VendorProfile({
    this.id,
    this.name,
    this.image,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.mobile,
    this.otp,
    this.accessToken,
    this.storeId,
    this.email,
    this.password,
    this.subscriptionId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
    this.subscriptionsName,
    this.storeDetails,
  });

  factory VendorProfile.fromJson(Map<String, dynamic> json) {
    return VendorProfile(
      id: json['id']?.toString(),
      name: json['name'],
      image: json['image'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode']?.toString(),
      mobile: json['mobile'],
      otp: json['otp']?.toString(),
      accessToken: json['access_token'],
      storeId: json['store_id']?.toString(),
      email: json['email'],
      password: json['password'],
      subscriptionId: json['subscription_id'],
      status: json['status']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      imagePath: json['image_path'],
      subscriptionsName: json['subscriptions_name'],
      storeDetails:
          json['store_details'] != null
              ? StoreDetails.fromJson(json['store_details'])
              : null,
    );
  }
}

class StoreDetails {
  final String? id;
  final String? name;
  final String? logo;
  final String? coverImage;
  final String? address;
  final String? detailedAddress;
  final String? storeType;
  final String? vendorId;
  final String? description;
  final String? pincode;
  final String? businessHours;
  final String? categoryIds;
  final String? storeLink;
  final String? status;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  StoreDetails({
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
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreDetails.fromJson(Map<String, dynamic> json) {
    return StoreDetails(
      id: json['id']?.toString(),
      name: json['name'],
      logo: json['logo'],
      coverImage: json['cover_image'],
      address: json['address'],
      detailedAddress: json['detailed_address'],
      storeType: json['store_type']?.toString(),
      vendorId: json['vendor_id']?.toString(),
      description: json['description'],
      pincode: json['pincode']?.toString(),
      businessHours: json['business_hours'],
      categoryIds: json['category_ids'],
      storeLink: json['store_link'],
      status: json['status']?.toString(),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
