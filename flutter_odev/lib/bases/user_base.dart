class User {
  late String username, profileUrl, password;
  late List<String>? products;

  User({
    required this.profileUrl,
    required this.username,
    required this.password,
    required this.products,
  });

  User.fromMap(Map<String, dynamic> map)
      : username = map["username"],
        password = map["password"],
        products= (map['products']!=null?(map['products']).toList().cast<String>():null),
        profileUrl = map["profileUrl"];

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "profileUrl": profileUrl,
      "password": password,
      "products": products,
    };
  }
}
