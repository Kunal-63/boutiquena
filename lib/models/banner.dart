class BannerModel {
  final String? id;
  final String? image;
  final String? type;
  final String? link;
  final String? title;
  final String? alt;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    this.id,
    this.image,
    this.type,
    this.link,
    this.title,
    this.alt,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString(),
      image: json['image']?.toString(),
      type: json['type']?.toString(),
      link: json['link']?.toString(),
      title: json['title']?.toString(),
      alt: json['alt']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
