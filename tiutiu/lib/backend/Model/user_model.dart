class User {
  String id;
  String name;
  String avatar;
  String email;
  String password;
  String whatsapp;
  String phone;
  int adopted;
  int donated;
  int disappeared;

  User({
    this.id,
    this.name,
    this.avatar,
    this.email,
    this.password,
    this.whatsapp,
    this.adopted,
    this.donated,
    this.phone,
    this.disappeared
  });

  toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'password': password,
      'whatsapp': whatsapp,
      'phone': phone,
      'adopted': adopted,
      'donated': donated,
    };
  }

  Map<String, Object> toMap() {
    Map<String, Object> userMap = Map<String, Object>();
    userMap["id"] = id;
    userMap["name"] = name;
    userMap["avatar"] = avatar;
    userMap["email"] = email;
    userMap["password"] = password;
    userMap["whatsapp"] = whatsapp;
    userMap["phone"] = phone;
    userMap["adopted"] = adopted;
    userMap["donated"] = donated;

    return userMap;
  }

  // User.fromSnapshot(DocumentSnapshot snpashot) {

  // }
}
