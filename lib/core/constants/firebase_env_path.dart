import 'package:flutter/foundation.dart';

class FirebaseEnvPath {
  static String environment = kDebugMode ? _EnvironmentBuild.debug.name : _EnvironmentBuild.prod.name;
  static const String allowUseWhatsappProdNumber = 'USE_WHATSAPP_PROD_NUMBER';
  static const String whatsappNumberIdDebug = 'WHATSAPP_NUMBER_ID_DEBUG';
  static const String whatsappTemplateDebug = 'WHATSAPP_TEMPLATE_DEBUG';
  static const String whatsappNumberIdProd = 'WHATSAPP_NUMBER_ID_PROD';
  static const String whatsappTemplateProd = 'WHATSAPP_TEMPLATE_PROD';
  static const String whatsappTokenDebug = 'WHATSAPP_TOKEN_DEBUG';
  static const String whatsappTokenProd = 'WHATSAPP_TOKEN_PROD';
  static const String termsandconditions = 'termsandconditions';
  static const String privacypolicy = 'privacypolicy';
  static const String disappeared = 'Disappeared';
  static const String documents = 'documents';
  static const String endpoints = 'endpoints';
  static const String projectName = 'tiutiu';
  static const String donate = 'Donate';
  static const String users = 'Users';
  static const String posts = 'posts';
  static const String about = 'about';
  static const String keys = 'KEYS';
  static const String env = 'env';
}

enum _EnvironmentBuild {
  debug,
  prod,
}

enum FileType {
  images,
  video,
}
