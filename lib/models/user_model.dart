class UserModel {
  static const String COLLECTIN_NAME = "Users";
  String? id;
  String? name;
  String? email;
  int? age;

  UserModel({this.id, this.name, this.email, this.age});

  UserModel.fromJson(dynamic json) {
    id = json['id'] as String;
    name = json['name'] as String;
    email = json['email'] as String;
    age = json['age'] as int;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["email"] = email;
    map["age"] = age;
    return map;
  }
}
