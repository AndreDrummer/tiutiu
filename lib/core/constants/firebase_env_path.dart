import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter/foundation.dart';

class FirebaseEnvPath {
  static const String allowUseWhatsappProdNumber = 'USE_WHATSAPP_PROD_NUMBER';
  static const String whatsappNumberIdDebug = 'WHATSAPP_NUMBER_ID_DEBUG';
  static const String whatsappTemplateDebug = 'WHATSAPP_TEMPLATE_DEBUG';
  static const String whatsappNumberIdProd = 'WHATSAPP_NUMBER_ID_PROD';
  static const String whatsappTemplateProd = 'WHATSAPP_TEMPLATE_PROD';
  static const String environment = kDebugMode ? 'debug' : 'prod';
  static const String usersFavoritesCollection = 'favorites';
  static const String whatsappToken = 'WHATSAPP_TOKEN';
  static const String whatsappCodes = 'whatsappCodes';
  static const String notifications = 'Notifications';
  static const String disappeared = 'Disappeared';
  static const String favorites = 'Favorites';
  static const String projectName = 'tiutiu';
  static const String messages = 'messages';
  static const String contacts = 'contacts';
  static const String adopted = 'Adopted';
  static const String donate = 'Donate';
  static const String users = 'Users';
  static const String posts = 'posts';
  static const String keys = 'KEYS';
  static const String chat = 'chat';
  static const String env = 'env';
}

enum FileType {
  images,
  video,
}

String get pathToPosts {
  return FirebaseEnvPath.projectName
      .concat(FirebaseEnvPath.env, joiner: '/')
      .concat(FirebaseEnvPath.environment, joiner: '/')
      .concat(FirebaseEnvPath.posts, joiner: '/')
      .concat(FirebaseEnvPath.posts, joiner: '/');
}

String pathToPost(String postId) {
  return FirebaseEnvPath.projectName
      .concat(FirebaseEnvPath.env, joiner: '/')
      .concat(FirebaseEnvPath.environment, joiner: '/')
      .concat(FirebaseEnvPath.posts, joiner: '/')
      .concat(FirebaseEnvPath.posts, joiner: '/')
      .concat(postId, joiner: '/');
}

String get pathToUsers {
  return FirebaseEnvPath.projectName
      .concat(FirebaseEnvPath.env, joiner: '/')
      .concat(FirebaseEnvPath.environment, joiner: '/')
      .concat(FirebaseEnvPath.users.toLowerCase(), joiner: '/')
      .concat(FirebaseEnvPath.users.toLowerCase(), joiner: '/');
}

String pathToUser(String userId) {
  return FirebaseEnvPath.projectName
      .concat(FirebaseEnvPath.env, joiner: '/')
      .concat(FirebaseEnvPath.environment, joiner: '/')
      .concat(FirebaseEnvPath.users.toLowerCase(), joiner: '/')
      .concat(FirebaseEnvPath.users.toLowerCase(), joiner: '/')
      .concat(userId, joiner: '/');
}

String userProfileStoragePath(String userId) {
  return FirebaseEnvPath.projectName
      .concat(FirebaseEnvPath.environment, joiner: '/')
      .concat(FirebaseEnvPath.users.toLowerCase(), joiner: '/')
      .concat(userId, joiner: '/')
      .concat('avatar', joiner: '/')
      .concat('profile.png', joiner: '/');
}

String userPostsStoragePath({
  required String fileType,
  required String userId,
  required String postId,
}) {
  return FirebaseEnvPath.projectName
      .concat(FirebaseEnvPath.environment, joiner: '/')
      .concat(FirebaseEnvPath.users.toLowerCase(), joiner: '/')
      .concat(userId, joiner: '/')
      .concat(FirebaseEnvPath.posts, joiner: '/')
      .concat(postId, joiner: '/')
      .concat(fileType, joiner: '/');
}
