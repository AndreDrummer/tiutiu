import 'package:tiutiu/core/system/model/local_env.dart';

class EnvVariables {
  EnvVariables._({
    required this.firebaseOptionsIosAndroidClientId,
    required this.firebaseOptionsMessagingSenderId,
    required this.firebaseOptionsIosIosClientId,
    required this.firebaseOptionsAndroidApiKey,
    required this.firebaseOptionsAndroidAppId,
    required this.firebaseOptionsIosApiKey,
    required this.firebaseOptionsProjectId,
    required this.firebaseOptionsIosAppId,
  });

  static EnvVariables _init() {
    print('CODEMAGIC: ${String.fromEnvironment("CI")} - ${String.fromEnvironment("CI").runtimeType}');

    if (String.fromEnvironment("CI") == 'true') {
      return EnvVariables._(
        firebaseOptionsIosAndroidClientId: String.fromEnvironment('FIREBASE_OPTIONS_IOS_ANDROID_CLIENT_ID'),
        firebaseOptionsMessagingSenderId: String.fromEnvironment('FIREBASE_OPTIONS_MESSAGING_SENDER_ID'),
        firebaseOptionsIosIosClientId: String.fromEnvironment('FIREBASE_OPTIONS_IOS_IOS_CLIENT_ID'),
        firebaseOptionsAndroidApiKey: String.fromEnvironment('FIREBASE_OPTIONS_ANDROID_API_KEY'),
        firebaseOptionsAndroidAppId: String.fromEnvironment('FIREBASE_OPTIONS_ANDROID_APP_ID'),
        firebaseOptionsIosApiKey: String.fromEnvironment('FIREBASE_OPTIONS_IOS_API_KEY'),
        firebaseOptionsProjectId: String.fromEnvironment('FIREBASE_OPTIONS_IOS_APP_ID'),
        firebaseOptionsIosAppId: String.fromEnvironment('FIREBASE_OPTIONS_PROJECT_ID'),
      );
    } else {
      return EnvVariables._(
        firebaseOptionsIosAndroidClientId: LocalEnv.firebaseOptionsIosAndroidClientId,
        firebaseOptionsMessagingSenderId: LocalEnv.firebaseOptionsMessagingSenderId,
        firebaseOptionsIosIosClientId: LocalEnv.firebaseOptionsIosIosClientId,
        firebaseOptionsAndroidApiKey: LocalEnv.firebaseOptionsAndroidApiKey,
        firebaseOptionsAndroidAppId: LocalEnv.firebaseOptionsAndroidAppId,
        firebaseOptionsIosApiKey: LocalEnv.firebaseOptionsIosApiKey,
        firebaseOptionsProjectId: LocalEnv.firebaseOptionsProjectId,
        firebaseOptionsIosAppId: LocalEnv.firebaseOptionsIosAppId,
      );
    }
  }

  static EnvVariables? _instance;

  static EnvVariables get instance {
    if (_instance == null) {
      _instance = _init();
    }

    return _instance!;
  }

  final String firebaseOptionsIosAndroidClientId;
  final String firebaseOptionsMessagingSenderId;
  final String firebaseOptionsIosIosClientId;
  final String firebaseOptionsAndroidApiKey;
  final String firebaseOptionsAndroidAppId;
  final String firebaseOptionsIosApiKey;
  final String firebaseOptionsProjectId;
  final String firebaseOptionsIosAppId;
}
