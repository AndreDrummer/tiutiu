import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/system/initializer.dart';
import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/core/utils/routes/router.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

import 'firebase_options.dart';

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late NotificationSettings notificationSettings;

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel androidNotificationChannel;

const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');

bool isFlutterLocalNotificationsInitialized = false;

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationResponse = NotificationResponse(
    notificationResponseType: NotificationResponseType.selectedNotification,
    payload: message.notification?.body,
    input: message.notification?.title,
    actionId: message.messageId,
    id: message.hashCode,
  );

  print("XXXx ${notificationResponse.toString()}");
}

Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  _setupFlutterLocalNotifications();

  print("Message ${message.toMap()}");

  _showFlutterNotification(message);

  if (kDebugMode) if (kDebugMode) debugPrint('TiuTiuApp: Handling a foreground message ${message.messageId}');
}

Future<void> _initializeFlutterLocalNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    ),
  );

  isFlutterLocalNotificationsInitialized = true;
}

Future<void> _setupFlutterLocalNotifications() async {
  androidNotificationChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> _requireNotificationPermission() async {
  if (Platform.isIOS) {
    notificationSettings = await messaging.requestPermission(
      criticalAlert: false,
      announcement: false,
      provisional: false,
      carPlay: false,
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) debugPrint('TiuTiuApp: iOS User granted permission: ${notificationSettings.authorizationStatus}');
  } else {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (kDebugMode) debugPrint('TiuTiuApp: Android User granted permission');
  }
}

void _showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  print("Message ${message.toMap()} $kIsWeb");

  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: androidNotificationChannel.description,
          importance: Importance.high,
          color: AppColors.primary,
          icon: 'notification_icon',
        ),
      ),
    );
  }
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemInitializer.initDependencies();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await _initializeFlutterLocalNotifications();

    await _requireNotificationPermission();

    chatController.setupInteractedMessage();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

    if (Platform.isAndroid || Platform.isIOS) {
      MobileAds.instance.initialize();
    }

    runApp(TiuTiuApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class TiuTiuApp extends StatefulWidget {
  @override
  State<TiuTiuApp> createState() => _TiuTiuAppState();
}

class _TiuTiuAppState extends State<TiuTiuApp> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    systemController.handleInternetConnectivityStatus();
    systemController.onAppEndpointsChange();
    authController.userStateChanges();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    chatController.setupInteractedMessage();
    adMobController.loadOpeningAd();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => GetMaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
          scaffoldBackgroundColor: Color(0XFFF9F9F9),
          primarySwatch: AppColors.secondary,
          primaryColor: AppColors.primary,
        ),
        onGenerateInitialRoutes: (initialRoute) => [RouterGenerator.createCustomTransition(LoadingStartScreen())],
        onGenerateRoute: RouterGenerator.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.root,
      ),
    );
  }
}
