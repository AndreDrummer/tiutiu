import 'package:tiutiu/features/auth/models/email_password_auth.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/auth/service/auth_service.dart';
import 'package:tiutiu/core/Exceptions/tiutiu_exceptions.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/models/whatsapp_token.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:math';

const int WHATSAPP_EXPIRATION_TOKEN_TIMER = 120;

enum AuthKeys {
  password,
  token,
  email,
}

class AuthController extends GetxController {
  AuthController({required AuthService authService}) : _authService = authService;

  final AuthService _authService;

  final Rx<EmailAndPasswordAuth> _emailAndPasswordAuth = EmailAndPasswordAuth().obs;
  final RxBool _isUpdatingUserDataOnServer = false.obs;
  final RxBool _isCreatingNewAccount = false.obs;
  final RxBool _isWhatsappTokenValid = true.obs;
  final RxBool _isResetingPassword = false.obs;
  final RxBool _isShowingPassword = false.obs;
  final RxBool _allowResendEmail = false.obs;
  final RxBool _numberVerified = false.obs;
  final RxInt _secondsToExpireCode = 0.obs;
  final RxString _feedbackText = ''.obs;
  final RxBool _userExists = false.obs;
  final RxBool _isLoading = false.obs;

  EmailAndPasswordAuth get emailAndPasswordAuth => _emailAndPasswordAuth.value;
  bool get isWhatsappTokenValid => _isWhatsappTokenValid.value;
  bool get isCreatingNewAccount => _isCreatingNewAccount.value;
  int get secondsToExpireCode => _secondsToExpireCode.value;
  bool get isResetingPassword => _isResetingPassword.value;
  bool get isShowingPassword => _isShowingPassword.value;
  bool get allowResendEmail => _allowResendEmail.value;
  bool get numberVerified => _numberVerified.value;
  String get feedbackText => _feedbackText.value;
  bool get userExists => _userExists.value;
  bool get isLoading => _isLoading.value;

  User? get user => _authService.authUser;

  void set _setEmailAndPasswordAuth(EmailAndPasswordAuth newValue) {
    _emailAndPasswordAuth(newValue);
  }

  void set isCreatingNewAccount(bool value) => _isCreatingNewAccount(value);
  void set isResetingPassword(bool value) => _isResetingPassword(value);
  void set isShowingPassword(bool value) => _isShowingPassword(value);
  void set feedbackText(String text) => _feedbackText(text);
  void set isLoading(bool value) => _isLoading(value);

  void clearEmailAndPassword() {
    _emailAndPasswordAuth(EmailAndPasswordAuth());
  }

  void setLoading(bool loadingValue, String loadingText) {
    _isLoading(loadingValue);
    _feedbackText(loadingText);
  }

  void updateEmailAndPasswordAuth(EmailAndPasswordAuthEnum property, dynamic data) {
    final map = emailAndPasswordAuth.toMap();
    map[property.name] = data;

    _setEmailAndPasswordAuth = EmailAndPasswordAuth().fromMap(map);
  }

  void userStateChanges() {
    _authService.userStream().listen((newUser) {
      _userExists(newUser != null);
    });
  }

  Future<void> sendWhatsAppCode() async {
    await verifyIfWhatsappTokenIsStillValid();

    if (!isWhatsappTokenValid) {
      final code = _generateCode();
      final whatsappTokenData = WhatsAppToken(
        expirationDate: DateTime.now().add(Duration(seconds: WHATSAPP_EXPIRATION_TOKEN_TIMER)).toIso8601String(),
        code: code,
      );

      _secondsToExpireCode(WHATSAPP_EXPIRATION_TOKEN_TIMER);

      LocalStorage.setDataUnderKey(
        key: LocalStorageKey.whatsappTokenData,
        data: whatsappTokenData.toMap(),
      );

      final phoneNumber = Formatters.unmaskNumber(tiutiuUserController.tiutiuUser.phoneNumber);
      final countryCode = tiutiuUserController.tiutiuUser.countryCode ?? '+55';

      if (phoneNumber != null) {
        if (kDebugMode) debugPrint('TiuTiuApp: sending Whatsapp token...');
        _authService.sendWhatsAppCode(countryCode, phoneNumber, code);
        tiutiuUserController.whatsappNumberHasBeenUpdated = false;
      }
    }
  }

  String _generateCode() {
    if (kDebugMode) debugPrint('TiuTiuApp: Generating code..');
    String code = '';
    for (int i = 0; i < 6; i++) {
      final digit = Random().nextInt(9);
      code += '$digit';
    }

    if (kDebugMode) debugPrint('TiuTiuApp: Code generated $code..');
    return code;
  }

  Future<bool> whatsAppCodeIsValid(String insertedCode) async {
    bool success = false;
    final whatsAppTokenData = await _getWhatsappStorageToken();
    if (kDebugMode) debugPrint('TiuTiuApp: Whatsapp tokenData ${whatsAppTokenData?.toMap()}..');

    if (whatsAppTokenData != null) {
      final codeSent = (whatsAppTokenData as WhatsAppToken).code;
      if (codeSent == insertedCode) {
        success = codeSent == insertedCode;
        _numberVerified(success);

        if (kDebugMode) debugPrint('TiuTiuApp: Valid inserted code $codeSent == $insertedCode');
      } else {
        if (kDebugMode) debugPrint('TiuTiuApp: INVALID CODE $codeSent != $insertedCode');
        _feedbackText(AppLocalizations.of(Get.context!).invalidCode);
      }
    } else {
      _feedbackText(AppLocalizations.of(Get.context!).tryVerifyCodeAgain);
    }

    return success;
  }

  void continueAfterValidateNumber() {
    tiutiuUserController.updateTiutiuUser(
      TiutiuUserEnum.phoneVerified,
      true,
    );

    LocalStorage.deleteDataUnderLocalStorageKey(LocalStorageKey.whatsappTokenData);
    _numberVerified(false);
    updateUserInfo();
  }

  Future<void> verifyIfWhatsappTokenIsStillValid() async {
    final whatsAppTokenData = await _getWhatsappStorageToken();

    if (whatsAppTokenData == null) {
      if (kDebugMode) debugPrint('TiuTiuApp: Token expired: No data');
      _isWhatsappTokenValid(false);
    } else if (tiutiuUserController.whatsappNumberHasBeenUpdated) {
      if (kDebugMode) debugPrint('TiuTiuApp: Token expired: Number has been updated');
      _isWhatsappTokenValid(false);
    } else {
      if (kDebugMode) debugPrint('TiuTiuApp: Whatsapp tokenData ${whatsAppTokenData?.toMap()}..');
      final expirationDate = (whatsAppTokenData as WhatsAppToken).expirationDate!;
      final isTokenExpired = DateTime.now().isAfter(DateTime.parse(expirationDate));

      _isWhatsappTokenValid(!isTokenExpired);

      if (isWhatsappTokenValid) {
        final seconds = DateTime.parse(expirationDate).difference(DateTime.now()).inSeconds;
        _secondsToExpireCode(seconds);
      } else {
        LocalStorage.deleteDataUnderLocalStorageKey(LocalStorageKey.whatsappTokenData);
      }

      if (kDebugMode) debugPrint('TiuTiuApp: Token still valid $isWhatsappTokenValid');
    }
  }

  Future<void> verifyShouldShowResendEmailButton() async {
    checkIfEmailWasVerified();

    if (!tiutiuUserController.tiutiuUser.emailVerified) {
      final lastSendEmailTime = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.lastSendEmailTime);
      if (kDebugMode) debugPrint('TiuTiuApp: verify should resend email storage data $lastSendEmailTime');

      if (lastSendEmailTime != null) {
        final minutes = DateTime.now().difference(DateTime.parse(lastSendEmailTime)).inMinutes;

        if (minutes >= 2) {
          if (kDebugMode) debugPrint('TiuTiuApp: last sent email is expired...');
          await LocalStorage.deleteDataUnderLocalStorageKey(LocalStorageKey.lastSendEmailTime);
          _allowResendEmail(true);
        } else {
          _allowResendEmail(false);
        }
      } else {
        _allowResendEmail(true);
      }
    }
  }

  Future<void> checkIfEmailWasVerified() async {
    await user?.reload();

    final isEmailVerified = user?.emailVerified ?? false;

    if (isEmailVerified) {
      tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.emailVerified, isEmailVerified);
    }
  }

  Future<void> sendEmail() async {
    if (user != null && !user!.emailVerified) {
      _allowResendEmail(false);
      if (kDebugMode) debugPrint('TiuTiuApp: resending Email verification...');

      await user?.sendEmailVerification();
      await LocalStorage.setValueUnderLocalStorageKey(
        key: LocalStorageKey.lastSendEmailTime,
        value: DateTime.now().toIso8601String(),
      );
    }
  }

  Future _getWhatsappStorageToken() async {
    return await LocalStorage.getDataUnderKey(
      key: LocalStorageKey.whatsappTokenData,
      mapper: WhatsAppToken(),
    );
  }

  Future<bool> createUserWithEmailAndPassword() async {
    bool success = false;

    if (emailAndPasswordAuth.password == emailAndPasswordAuth.repeatPassword) {
      setLoading(true, AppLocalizations.of(Get.context!).registeringUser);
      success = await _authService.createUserWithEmailAndPassword(
        password: emailAndPasswordAuth.password!,
        email: emailAndPasswordAuth.email!,
      );

      if (success) {
        await loadUserData();
        saveEmailAndPasswordAuthData();
        tiutiuUserController.checkUserRegistered();
      }

      isCreatingNewAccount = false;
      isShowingPassword = false;
      setLoading(false, '');
    }

    return success;
  }

  Future<bool> loginWithEmailAndPassword() async {
    setLoading(true, AppLocalizations.of(Get.context!).loginInProgress);

    final bool success = await _authService.loginWithEmailAndPassword(
      password: emailAndPasswordAuth.password!,
      email: emailAndPasswordAuth.email!,
    );

    if (success) {
      await loadUserData();
      saveEmailAndPasswordAuthData();
      tiutiuUserController.checkUserRegistered();
    }

    isShowingPassword = false;
    setLoading(false, '');

    if (kDebugMode) debugPrint('TiuTiuApp: ${success ? 'Successfully' : 'Not'} authenticated');

    return success;
  }

  Future<bool> loginWithFacebook({bool firstLogin = true}) async {
    setLoading(true, AppLocalizations.of(Get.context!).loginInProgress);

    final bool success = await _authService.loginWithFacebook(
      firstLogin: firstLogin,
    );

    if (success) {
      await loadUserData();
      registerFirstLogin();
      tiutiuUserController.checkUserRegistered();
    }

    setLoading(false, '');
    return success;
  }

  Future<bool> loginWithGoogle({bool firstLogin = true}) async {
    setLoading(true, AppLocalizations.of(Get.context!).loginInProgress);

    final bool success = await _authService.loginWithGoogle();

    if (success) {
      await loadUserData();
      registerFirstLogin();
      tiutiuUserController.checkUserRegistered();
    }

    setLoading(false, '');

    return success;
  }

  Future<bool> loginWithApple() async {
    setLoading(true, AppLocalizations.of(Get.context!).loginInProgress);

    final bool success = await _authService.loginWithApple();

    if (success) {
      await loadUserData();
      registerFirstLogin();
      tiutiuUserController.checkUserRegistered();
    }

    setLoading(false, '');

    return success;
  }

  Future<void> passwordReset() async {
    setLoading(true, AppLocalizations.of(Get.context!).wait);
    await _authService.passwordReset(emailAndPasswordAuth.email!);
    isResetingPassword = false;
    clearEmailAndPassword();
    setLoading(false, '');
    isLoading = false;
  }

  Future<bool> tryAutoLoginIn() async {
    bool success = user != null;
    if (kDebugMode) debugPrint('TiuTiuApp: trying automatically login...');

    if (user == null) {
      final hosters = [
        await trySignInWithEmailAndPassword(),
        await tryLoginWithFacebook(),
      ];

      int count = 0;
      while (!success && count < hosters.length) {
        success = hosters[count];
        count++;
      }
    } else {
      await loadUserData();
    }

    if (kDebugMode) debugPrint('TiuTiuApp: Successfull login? $success');
    return success;
  }

  Future<void> recordLogoutTimeNow() async {
    final lastLogoutTime = DateTime.now().toIso8601String();
    await LocalStorage.setValueUnderLocalStorageKey(
      key: LocalStorageKey.lastLogoutTime,
      value: lastLogoutTime,
    );
  }

  Future<bool> trySignInWithEmailAndPassword() async {
    if (kDebugMode) debugPrint('TiuTiuApp: trying log in using email and password');
    final emailPasswordAuthData = await LocalStorage.getDataUnderKey(
      key: LocalStorageKey.emailPasswordAuthData,
      mapper: EmailAndPasswordAuth(),
    ) as EmailAndPasswordAuth?;

    if (emailPasswordAuthData != null) {
      _setEmailAndPasswordAuth = EmailAndPasswordAuth(
        password: (emailPasswordAuthData).password,
        email: emailPasswordAuthData.email,
      );

      return loginWithEmailAndPassword();
    }

    if (kDebugMode) debugPrint('TiuTiuApp: trying log in using email and password failed');
    return false;
  }

  Future<bool> tryLoginWithFacebook() async {
    if (kDebugMode) debugPrint('TiuTiuApp: trying log in with facebook');

    final firstLogin = await LocalStorage.getUnderBooleanKey(
      key: LocalStorageKey.facebookAuthData,
      standardValue: true,
    );

    if (kDebugMode) debugPrint('TiuTiuApp: First Login? $firstLogin');

    if (!firstLogin) {
      return loginWithFacebook(firstLogin: firstLogin);
    }

    if (kDebugMode) debugPrint('TiuTiuApp: trying log in with facebook failed');
    return false;
  }

  void saveEmailAndPasswordAuthData() {
    LocalStorage.setDataUnderKey(
      key: LocalStorageKey.emailPasswordAuthData,
      data: {
        AuthKeys.password.name: emailAndPasswordAuth.password!,
        AuthKeys.email.name: emailAndPasswordAuth.email!,
      },
    );
  }

  void registerFirstLogin() {
    LocalStorage.setBooleanUnderKey(
      key: LocalStorageKey.facebookAuthData,
      value: false,
    );
  }

  Future<void> loadUserData() async {
    await tiutiuUserController.updateLoggedUserData(
      authController.user!.uid,
    );

    updateUserInfo();
  }

  Future<void> updateUserInfo() async {
    try {
      if (!_isUpdatingUserDataOnServer.value) {
        final isAppleUser = user?.providerData.first.providerId == 'apple.com';
        final lastSignInTime = user?.metadata.lastSignInTime;
        final creationTime = user?.metadata.creationTime;
        final loggedUser = tiutiuUserController.tiutiuUser;

        _isUpdatingUserDataOnServer(true);
        await user?.reload();

        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (kDebugMode) debugPrint('TiuTiuApp: Updating FCM Token $fcmToken');
        tiutiuUserController.updateTiutiuUser(
          TiutiuUserEnum.notificationToken,
          fcmToken,
        );

        if (creationTime != null) {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating createAt...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.createdAt,
            creationTime.toIso8601String(),
          );
        }

        if (lastSignInTime != null) {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating lastSeen...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.lastLogin,
            lastSignInTime.toIso8601String(),
          );
        }

        if (isAppleUser) {
          tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.email, user?.providerData.first.email);
          tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.emailVerified, true);
        } else {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating emailVerified... ${user?.emailVerified}');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.emailVerified,
            user?.emailVerified ?? false,
          );
        }

        if (loggedUser.displayName == null) {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating displayName...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.displayName,
            user?.displayName,
          );
        }

        if (loggedUser.avatar == null) {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating avatar...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.avatar,
            user?.photoURL,
          );
        }

        if (loggedUser.phoneNumber == null) {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating phoneNumber...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.phoneNumber,
            user?.phoneNumber,
          );
        }

        if (loggedUser.uid == null) {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating uid...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.uid,
            loggedUser.uid ?? user!.uid,
          );
        }

        if (loggedUser.email == null) {
          if (kDebugMode) debugPrint('TiuTiuApp: Updating email...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.email,
            authController.user!.email,
          );
        }
        if (kDebugMode) debugPrint('TiuTiuApp: timesOpenedTheApp...');
        tiutiuUserController.updateTiutiuUser(
          TiutiuUserEnum.email,
          authController.user!.email,
        );

        if (!isAppleUser && !user!.emailVerified && allowResendEmail) {
          sendEmail();
        }

        await tiutiuUserController.updateUserDataOnServer();
        _isUpdatingUserDataOnServer(false);
      }
    } on FirebaseAuthException catch (exception) {
      crashlyticsController.reportAnError(
        message: 'An error ocurred when updating user info: ${exception.message}',
        exception: exception,
      );
      throw TiuTiuAuthException(exception.code);
    }
  }

  Future<void> saveUserTermsAndConditionsChoice() async {
    if (userExists) {
      await tiutiuUserController.updateUserDataOnServer();
    } else {
      await LocalStorage.setBooleanUnderKey(key: LocalStorageKey.termsAndConditions, value: true);
    }
  }

  Future<void> signOut() async {
    if (kDebugMode) debugPrint('TiuTiuApp: Login out...');
    await _authService.logOut();
    if (kDebugMode) debugPrint('TiuTiuApp: User $user');
    clearAllAuthData();
    clearEmailAndPassword();
    if (kDebugMode) debugPrint('TiuTiuApp: Cleaning cache...');
    tiutiuUserController.checkUserRegistered();
    if (kDebugMode) debugPrint('TiuTiuApp: Logout done!');
    recordLogoutTimeNow();
    setLoading(false, '');
    if (kDebugMode) debugPrint('TiuTiuApp: User still exists? $userExists');
  }

  void clearAllAuthData() {
    tiutiuUserController.resetUserWithThisUser();
    LocalStorage.clearStorage();
  }

  final _startScreenImages = [
    StartScreenAssets.munkun,
    StartScreenAssets.greyCat,
    StartScreenAssets.whiteCat,
    StartScreenAssets.hairy2,
    StartScreenAssets.pinscher,
    StartScreenAssets.oldMel,
    StartScreenAssets.liu,
    StartScreenAssets.husky,
    StartScreenAssets.hairy,
  ];

  List<String> get startScreenImages => _startScreenImages;
}
