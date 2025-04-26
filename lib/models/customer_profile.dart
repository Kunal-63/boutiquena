class CustomerProfile {
  final String? id;
  final String? name;
  final String? image;
  final String? address;
  final double? lat;
  final double? long;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? mobile;
  final String? otp;
  final String? email;
  final String? provider;
  final String? providerId;
  final String? status;
  final String? accessToken;
  final String? createdAt;
  final String? updatedAt;
  final String? imagePath;

  CustomerProfile({
    this.id,
    this.name,
    this.image,
    this.address,
    this.lat,
    this.long,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.mobile,
    this.otp,
    this.email,
    this.provider,
    this.providerId,
    this.status,
    this.accessToken,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json['id']?.toString(),
      name: json['name'],
      image: json['image'],
      address: json['address'],
      lat:
          (json['lat'] != null)
              ? double.tryParse(json['lat'].toString())
              : null,
      long:
          (json['long'] != null)
              ? double.tryParse(json['long'].toString())
              : null,
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      mobile: json['mobile'],
      otp: json['otp']?.toString(),
      email: json['email'],
      provider: json['provider'],
      providerId: json['provider_id']?.toString(),
      status: json['status']?.toString(),
      accessToken: json['access_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      imagePath: json['image_path'],
    );
  }
}
