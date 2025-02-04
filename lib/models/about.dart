class About {
  final String name;
  final String logo;
  final String phone;
  final String email;
  final String address;
  final String facebook;
  final String linkdin;
  final String instagram;
  final String twitter;

  About({
    required this.name,
    required this.logo,
    required this.phone,
    required this.email,
    required this.address,
    required this.facebook,
    required this.linkdin,
    required this.instagram,
    required this.twitter,
  });

  // Factory method to create an About object from JSON
  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      name: json['name'],
      logo: 'https://cnis.smartbizz.xyz/storage/app/public/${json['logo']}',
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      facebook: json['facebook'],
      linkdin: json['linkdin'],
      instagram: json['instagram'],
      twitter: json['twitter'],
    );
  }
}
