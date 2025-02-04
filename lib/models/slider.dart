class Slider {
  final int id;
  final String title;
  final String details;
  final String thumb;

  Slider({
    required this.id,
    required this.title,
    required this.details,
    required this.thumb,
  });

  // Factory method to create a Slider object from JSON
  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      id: json['id'],
      title: json['title'],
      details: json['details'],
      thumb: 'https://cnis.smartbizz.xyz/storage/app/${json['thumb']}',
    );
  }
}
