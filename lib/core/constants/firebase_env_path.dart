import 'package:flutter/foundation.dart';

class FirebaseEnvPath {
  static const String allowUseWhatsappProdNumber = 'USE_WHATSAPP_PROD_NUMBER';
  static const String whatsappNumberIdDebug = 'WHATSAPP_NUMBER_ID_DEBUG';
  static const String whatsappTemplateDebug = 'WHATSAPP_TEMPLATE_DEBUG';
  static const String whatsappNumberIdProd = 'WHATSAPP_NUMBER_ID_PROD';
  static const String whatsappTemplateProd = 'WHATSAPP_TEMPLATE_PROD';
  static const String environment = kDebugMode ? 'debug' : 'prod';
  static const String usersFavoritesCollection = 'favorites';
  // static const String environment = 'prod';
  static const String whatsappToken = 'WHATSAPP_TOKEN';
  static const String whatsappCodes = 'whatsappCodes';
  static const String notifications = 'Notifications';
  static const String disappeared = 'Disappeared';
  static const String favorites = 'Favorites';
  static const String projectName = 'tiutiu';
  static const String adopted = 'Adopted';
  static const String donate = 'Donate';
  static const String users = 'Users';
  static const String keys = 'KEYS';
  static const String env = 'env';

  // Quando a migração estiver completa e o app v2.0 lançado, remover o user com U maiusculo.
  static const String messages = 'messages';
  static const String contacts = 'contacts';
  static const String posts = 'posts';
  static const String chat = 'chat';
}

enum FileType {
  images,
  video,
}

String get pathToPosts =>
    '${FirebaseEnvPath.projectName}/${FirebaseEnvPath.env}/${FirebaseEnvPath.environment}/${FirebaseEnvPath.posts}/${FirebaseEnvPath.posts}';

String get newPathToUser =>
    '${FirebaseEnvPath.projectName}/${FirebaseEnvPath.env}/${FirebaseEnvPath.environment}/${FirebaseEnvPath.users.toLowerCase()}/${FirebaseEnvPath.users.toLowerCase()}';

String userProfileStoragePath(String userId) =>
    '${FirebaseEnvPath.projectName}/${FirebaseEnvPath.env}/${FirebaseEnvPath.users.toLowerCase()}/$userId/avatar/profile.png';

String userPostsStoragePath({
  required String fileType,
  required String userId,
  required String postId,
}) {
  return '${FirebaseEnvPath.projectName}/${FirebaseEnvPath.env}/${FirebaseEnvPath.users.toLowerCase()}/$userId/${FirebaseEnvPath.posts}/$postId/$fileType';
}
