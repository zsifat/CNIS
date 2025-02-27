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
  final String? degree;
  final String? address;
  final String? googleMap;
  final String? chamber;
  final String? price;
  final String? bloodGroup;
  final String? date;
  final String? email;
  final String? link;

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
    this.degree,
    this.address,
    this.googleMap,
    this.chamber,
    this.price,
    this.bloodGroup,
    this.date,
    this.email,
    this.link
  });

  // Factory method to create a Data object from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title: json['title'],
      department: json['depertment'],
      upazila: int.tryParse(json['upazilla'].toString()) ?? 0,
      details: json['details'],
      thumb: 'https://cnis.smartbizz.xyz/storage/app/${json['thumb']}',
      catId: json['cat_id'],
      contact: json['contact'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      degree: json['degree'],
      address: json['address'],
      googleMap: json['googlemap'],
      chamber: json['chamber'],
      price: json['price'],
      bloodGroup: json['blood_broup'],
      date: json['date'],
      email: json['email'],
      link: json['link']
    );
  }

  // Method to convert Data object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'depertment': department,
      'upazilla': upazila.toString(),
      'details': details,
      'thumb': thumb.replaceFirst('https://cnis.smartbizz.xyz/storage/app/', ''),
      'cat_id': catId,
      'contact': contact,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'degree': degree,
      'address': address,
      'googlemap': googleMap,
      'chamber': chamber,
      'price': price,
      'blood_broup': bloodGroup,
      'date': date,
      'email': email,
      'link':link
    };
  }
}
