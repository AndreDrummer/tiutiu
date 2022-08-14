import 'package:flutter/foundation.dart';

class FirebaseEnvPath {
  static const String usersFavoritesCollection = 'favorites';
  static const String env = kDebugMode ? 'debug' : 'prod';
  // static const String env = 'prod';
  static const String notifications = 'Notifications';
  static const String disappeared = 'Disappeared';
  static const String favorites = 'Favorites';
  static const String adopted = 'Adopted';
  static const String donate = 'Donate';
  static const String users = 'Users';
}

enum FileType {
  images,
  videos,
}
