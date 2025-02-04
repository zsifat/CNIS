class News {
  final int id;
  final String image;
  final String author;
  final String title;
  final String description;
  final String catId;
  final String? authImg;
  final String? video;
  final DateTime createdAt;
  final DateTime updatedAt;

  News({
    required this.id,
    required this.image,
    required this.author,
    required this.title,
    required this.description,
    required this.catId,
    required this.authImg,
    this.video,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a News instance from JSON
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      image: 'https://cnis.smartbizz.xyz/storage/app/${json['image']}',
      author: json['author'],
      title: json['title'],
      description: json['description'],
      catId: json['cat_id'],
      authImg: json['auth_img'] ==null ? null : 'https://cnis.smartbizz.xyz/storage/app/${json['auth_img']}',
      video: json['video'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

}
