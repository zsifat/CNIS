class Data {
  final int id;
  final String title;
  final String department;
  final int upazila;
  final String details;
  final String thumb;
  final String catId;
  final String contact;
  final String createdAt;
  final String updatedAt;

  Data({
    required this.id,
    required this.title,
    required this.department,
    required this.upazila,
    required this.details,
    required this.thumb,
    required this.catId,
    required this.contact,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Doctor object from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
      department: json['depertment'],
      upazila: int.tryParse(json['upazilla']) ?? 0,
      details: json['details'],
      thumb: 'https://cnis.smartbizz.xyz/storage/app/${json['thumb']}',
      catId: json['cat_id'],
      contact: json['contact'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }


}
