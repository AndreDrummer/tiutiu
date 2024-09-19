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
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  _setupFlutterNotifications();

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('notification_icon'),
    ),
    onDidReceiveNotificationResponse: (_) =>
        chatController.setupInteractedMessage(message),
  );

  _showFlutterNotification(message);

  if (kDebugMode) if (kDebugMode)
    debugPrint('TiuTiuApp: Handling a foreground message ${message.messageId}');
}

Future<void> _setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

Future<void> _requireNotificationPermission() async {
  notificationSettings = await messaging.requestPermission(
    criticalAlert: false,
    announcement: false,
    provisional: false,
    carPlay: false,
    alert: true,
    badge: true,
    sound: true,
  );

  if (kDebugMode)
    debugPrint(
        'TiuTiuApp: User granted permission: ${notificationSettings.authorizationStatus}');
}

void _showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
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
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    SystemInitializer.initDependencies();

    if (Platform.isIOS) await _requireNotificationPermission();

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
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
          scaffoldBackgroundColor: Color(0XFFF9F9F9),
          primarySwatch: AppColors.secondary,
          primaryColor: AppColors.primary,
        ),
        onGenerateInitialRoutes: (initialRoute) =>
            [RouterGenerator.createCustomTransition(LoadingStartScreen())],
        onGenerateRoute: RouterGenerator.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.root,
      ),
    );
  }
}
