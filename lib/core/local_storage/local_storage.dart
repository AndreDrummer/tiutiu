import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiutiu/core/models/mapper.dart';
import 'dart:convert';

class LocalStorage {
  static Future<bool> setDataUnderKey({required Map<String, dynamic> data, required LocalStorageKey key}) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.setString(key.name, jsonEncode(data));
    } on Exception catch (error) {
      throw Exception('An error has occurred during saving auth data: $error');
    }
  }

  static Future<Mapper?> getDataUnderKey({required LocalStorageKey key, required Mapper mapper}) async {
    try {
      final data = await _getString(key.name);
      if (data != null) {
        return mapper.fromMap(jsonDecode(data));
      }
    } on Exception catch (error) {
      throw Exception('An error has occurred when try to get auth data: $error');
    }
    return null;
  }

  static Future<bool> setBooleanUnderKey({required LocalStorageKey key, required bool value}) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.setString(key.name, value.toString());
    } on Exception catch (error) {
      throw Exception('An error has occurred during saving auth data: $error');
    }
  }

  static Future<bool> getUnderBooleanKey({required LocalStorageKey key, bool standardValue = true}) async {
    try {
      final value = await _getString(key.name);
      return value == null ? standardValue : value == 'true';
    } on Exception catch (error) {
      throw Exception(
        'An error has occurred when try to get auth data: $error',
      );
    }
  }

  static Future<bool> setValueUnderLocalStorageKey({required LocalStorageKey key, dynamic value}) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.setString(key.name, jsonEncode(value));
    } on Exception catch (error) {
      throw Exception(
        'An error has occurred when setting data under key String: $key. $error',
      );
    }
  }

  static Future<dynamic> getValueUnderLocalStorageKey(LocalStorageKey key) async {
    try {
      final value = await _getString(key.name);
      if (value != null) return jsonDecode(value);
    } on Exception catch (error) {
      throw Exception(
        'An error has occurred when try to get data under key String: $key: $error',
      );
    }
  }

  static Future<bool> setValueUnderStringKey({required String key, dynamic value}) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.setString(key, jsonEncode(value));
    } on Exception catch (error) {
      throw Exception(
        'An error has occurred when setting data under key String: $key. $error',
      );
    }
  }

  static Future<dynamic> getValueUnderStringKey(String key) async {
    try {
      final value = await _getString(key);
      if (value != null) return jsonDecode(value);
    } on Exception catch (error) {
      throw Exception(
        'An error has occurred when try to get data under key String: $key: $error',
      );
    }
  }

  static Future<bool> deleteDataUnderLocalStorageKey(LocalStorageKey key) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.remove(key.name);
    } on Exception catch (error) {
      throw Exception('An error has occurred when try delete auth data: $error');
    }
  }

  static Future<bool> deleteValueUnderStringKey(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      return _prefs.remove(key);
    } on Exception catch (error) {
      throw Exception('An error has occurred when try delete auth data: $error');
    }
  }

  static Future<String?> _getString(String key) async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key);
  }

  static Future<void> clearStorage() async {
    final _prefs = await SharedPreferences.getInstance();
    LocalStorageKey.values.forEach((key) {
      _prefs.remove(key.name);
    });
  }
}
