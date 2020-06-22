import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DataBaseHandler {  
  Future<Database> database;
  DataBaseHandler._constructor();
  static final DataBaseHandler instance = DataBaseHandler._constructor();

  Future initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
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
      version: 1
    );
  }

  // SQL QUERIES

  Future insert(String tableName, data) async {
    var retorno;
    final Database db = await database;
    await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((value) => retorno = value);

    return retorno;
  }

  Future<List> getAll(String tableName) async {
    final Database db = await database;

    final List<Map<String, dynamic>> data = await db.rawQuery(
      "SELECT * FROM $tableName"
    );

    return data;
  }

  Future<List<Map<String, dynamic>>> getById(String tableName, id) async {
    final db = await database;

    final List<Map<String, dynamic>> data = await db.rawQuery(
      "SELECT * FROM $tableName where id = $id"
    );

    return data;
  }

  Future<void> update(String tableName, data) async {
    final db = await database;

    await db.update(
      tableName,
      data.toJson(),
      where: "id = ?",
      whereArgs: [data.id]
    );
  }

  Future<void> delete(String tableName, id) async {
    final db = await database;

    await db.delete(
      tableName,      
      where: "id = ?",
      whereArgs: [id]
    );
  }
}