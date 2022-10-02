import 'package:flutter/foundation.dart';

class FirebaseEnvPath {
  static const String usersFavoritesCollection = 'favorites';
  static const String env = kDebugMode ? 'debug' : 'prod';
  static const String projectName = 'tiutiu';
  // static const String env = 'prod';
  static const String notifications = 'Notifications';
  static const String disappeared = 'Disappeared';
  static const String favorites = 'Favorites';
  static const String adopted = 'Adopted';
  static const String donate = 'Donate';
  static const String users = 'Users';

  // Quando a migração estiver completa e o app v2.0 lançado, remover o user com U maiusculo.
  static const String userss = 'users';
  static const String posts = 'posts';
  static const String chat = 'chat';
}

enum FileType {
  images,
  videos,
}

String get newPathToAds =>
    '${FirebaseEnvPath.projectName}/env/${FirebaseEnvPath.env}/${FirebaseEnvPath.posts}/${FirebaseEnvPath.posts}';

String get newPathToUser =>
    '${FirebaseEnvPath.projectName}/env/${FirebaseEnvPath.env}/${FirebaseEnvPath.userss}/${FirebaseEnvPath.userss}';

String userProfileStoragePath(String userId) =>
    '${FirebaseEnvPath.projectName}/${FirebaseEnvPath.env}/users/$userId/avatar/profile.png';
