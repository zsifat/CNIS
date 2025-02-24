/// id : 0
/// title : "medicine"
/// category_id : "1"
/// image : "public/images/5Y6egpl30UqKfyy6evKaDPQgfGgIHw7MqXpZ7U1w.png"
/// created_at : "2025-02-20T04:21:29.000000Z"
/// updated_at : "2025-02-20T04:21:29.000000Z"

class SubCategory {
  SubCategory({
      num? id, 
      String? title, 
      String? categoryId,
      String? image, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _title = title;
    _categoryId = categoryId;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  SubCategory.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _categoryId = json['category_id'];
    _image = 'https://cnis.smartbizz.xyz/storage/app/${json['image']}';
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _title;
  String? _categoryId;
  String? _image;
  String? _createdAt;
  String? _updatedAt;
SubCategory copyWith({  num? id,
  String? title,
  String? categoryId,
  String? image,
  String? createdAt,
  String? updatedAt,
}) => SubCategory(  id: id ?? _id,
  title: title ?? _title,
  categoryId: categoryId ?? _categoryId,
  image: image ?? _image,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get title => _title;
  String? get categoryId => _categoryId;
  String? get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['category_id'] = _categoryId;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}