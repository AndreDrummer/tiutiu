import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/models/mapper.dart';

class LocalStorage {
  static Future<bool> setDataUnderKey({
    required Map<String, dynamic> map,
    required LocalStorageKey key,
  }) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.setString(key.getString(), jsonEncode(map));
    } on Exception catch (error) {
      throw Exception('An error has occurred during saving auth data: $error');
    }
  }

  static Future<Mapper?> getDataUnderKey({
    required LocalStorageKey key,
    required Mapper mapper,
  }) async {
    try {
      final data = await _getString(key.getString());
      if (data != null) {
        return mapper.fromMap(jsonDecode(data));
      }
    } on Exception catch (error) {
      throw Exception(
          'An error has occurred when try to get auth data: $error');
    }
    return null;
  }

  static Future<bool> deleteDataUnderKey(LocalStorageKey key) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.remove(key.getString());
    } on Exception catch (error) {
      throw Exception(
          'An error has occurred when try delete auth data: $error');
    }
  }

  static Future<String?> _getString(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key);
  }
}
