import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tiutiu/backend/Model/dog_model.dart';

class DataBaseHandler {
  Future<Database> database;

  void initDB() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'tiutiu.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS Dog(id TEXT, name TEXT, age INTEGER, breed TEXT, size TEXT, details TEXT, owner INTEGER)",
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS User(id TEXT, name TEXT, avatar TEXT, email TEXT, password TEXT, whatsapp TEXT, phone TEXT, donated INTEGER, adopted INTEGER, disappeared INTEGER)",
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS DogPhotos(id TEXT, dogId TEXT, photo TEXT)",
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS DogAdopted(ownerId TEXT, dogId TEXT, photo TEXT)",
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS DogDonated(ownerId TEXT, dogId TEXT, photo TEXT)",
        );
        await db.execute(
          "CREATE TABLE IF NOT EXISTS DogDisappeared(ownerId TEXT, dogId TEXT, photo TEXT)",
        );
      },
    );
  }

  // SQL QUERIES

  Future<void> insert(table, data) async {
    final Database db = await database;
    await db.insert(
      table,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getDog() async {
    final Database db = await database;

    final List<Map<String, dynamic>> map = await db.query('Dog');

    return List.generate(map.length, (index) {
      return Dog(
        id: map[index]['id'],
        name: map[index]['name'],
        age: map[index]['age'],
        photos: map[index]['photos'],
        breed: map[index]['breed'],
        size: map[index]['size'],
        details: map[index]['details'],
        owner: map[index]['owner'],
      );
    });
  }
}
