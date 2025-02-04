class Category {
  final int id;
  final String title;
  final String? parentCategory;
  final String thumb;

  Category({
    required this.id,
    required this.title,
    this.parentCategory,
    required this.thumb,
  });

  // Factory constructor to create a Category from a JSON object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      parentCategory: json['parent_category'],
      thumb: 'https://cnis.smartbizz.xyz/storage/app/${json['thumb']}',
    );
  }


}
