// import '../Database/database.dart';
// import '../Model/user_model.dart';

// class UserController {
//   DataBaseHandler db = DataBaseHandler.instance;

//   Future getUser(String id) async {
//     List<Map<String, dynamic>> map = await db.getById('user', id);

//     if (map.isNotEmpty) {
//       User user = User(
//         id: map[0]['id'],
//         name: map[0]['name'],
//         avatar: map[0]['avatar'],
//         adopted: map[0]['adopted: '],
//         donated: map[0]['donated'],
//         email: map[0]['email'],
//         password: map[0]['password'],
//         phone: map[0]['phone'],
//         whatsapp: map[0]['whatsapp'],
//       );
//       return user;
//     }

//     return [];
//   }

//   Future<List<User>> getAllUsers() async {
//     List<Map<String, dynamic>> userList = await db.getAll('user');

//     return List.generate(
//       userList.length,
//       (i) {
//         return User(
//           id: userList[0]['id'],
//           name: userList[0]['name'],
//           avatar: userList[0]['avatar'],
//           adopted: userList[0]['adopted: '],
//           donated: userList[0]['donated'],
//           email: userList[0]['email'],
//           password: userList[0]['password'],
//           phone: userList[0]['phone'],
//           whatsapp: userList[0]['whatsapp'],
//         );
//       },
//     );
//   }

//   Future<void> insertUser(User user) async {
//     await db.insert('user', user);
//   }

//   Future<void> updateUser(User user) async {
//     await db.update('user', user);
//   }

//   Future<void> deleteUser(String id) async {
//     await db.delete('user', id);
//   }
// }
