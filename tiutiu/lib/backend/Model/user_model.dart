import './dog_model.dart';

class User {
  String id;
  String name;
  String avatar;
  String email;
  String password;
  String whatsapp;
  String phone;
  List<Dog> adopted;
  List<Dog> donated;

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
