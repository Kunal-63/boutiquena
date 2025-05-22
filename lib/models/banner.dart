class BannerModel {
  final int? id;
  final String? image;
  final String? type;
  final String? link;
  final String? title;
  final String? titleHebrew;
  final String? titleArabic;
  final String? alt;
  final String? altHebrew;
  final String? altArabic;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    this.id,
    this.image,
    this.type,
    this.link,
    this.title,
    this.titleHebrew,
    this.titleArabic,
    this.alt,
    this.altHebrew,
    this.altArabic,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      type: json['type'],
      link: json['link'],
      title: json['title'],
      titleHebrew: json['title_hebrew'],
      titleArabic: json['title_arabic'],
      alt: json['alt'],
      altHebrew: json['alt_hebrew'],
      altArabic: json['alt_arabic'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
