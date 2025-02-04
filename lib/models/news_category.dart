class NewsCategory {
  final int id;
  final String title;

  // Constructor
  NewsCategory({
    required this.id,
    required this.title,
  });

  // Factory method to create an instance from a JSON map
  factory NewsCategory.fromJson(Map<String, dynamic> json) {
    return NewsCategory(
      id: json['id'],
      title: json['title'],
    );
  }
}
