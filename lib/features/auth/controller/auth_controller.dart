import 'package:tiutiu/features/auth/models/email_password_auth.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/auth/service/auth_service.dart';
import 'package:tiutiu/core/Exceptions/tiutiu_exceptions.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/models/whatsapp_token.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:math';

const int WHATSAPP_EXPIRATION_TOKEN_TIMER = 20;

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
  bool get userExists => _authService.userExists;
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

      if (phoneNumber != null) {
        debugPrint('>> sending Whatsapp token...');
        _authService.sendWhatsAppCode(phoneNumber, code);
        tiutiuUserController.whatsappNumberHasBeenUpdated = false;
      }
    }
  }

  String _generateCode() {
    debugPrint('>> Generating code..');
    String code = '';
    for (int i = 0; i < 6; i++) {
      final digit = Random().nextInt(9);
      code += '$digit';
    }

    debugPrint('>> Code generated $code..');
    return code;
  }

  Future<bool> whatsAppCodeIsValid(String insertedCode) async {
    bool success = false;
    final whatsAppTokenData = await _getWhatsappStorageToken();
    debugPrint('>> Whatsapp tokenData ${whatsAppTokenData?.toMap()}..');

    if (whatsAppTokenData != null) {
      final codeSent = (whatsAppTokenData as WhatsAppToken).code;
      if (codeSent == insertedCode) {
        success = codeSent == insertedCode;
        _numberVerified(success);

        debugPrint('>> Valid inserted code $codeSent == $insertedCode');
      } else {
        debugPrint('>> INVALID CODE $codeSent != $insertedCode');
        _feedbackText(AuthStrings.invalidCode);
      }
    } else {
      _feedbackText(AuthStrings.tryVerifyCodeAgain);
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
      debugPrint('>> Token expired: No data');
      _isWhatsappTokenValid(false);
    } else if (tiutiuUserController.whatsappNumberHasBeenUpdated) {
      debugPrint('>> Token expired: Number has been updated');
      _isWhatsappTokenValid(false);
    } else {
      debugPrint('>> Whatsapp tokenData ${whatsAppTokenData?.toMap()}..');
      final expirationDate = (whatsAppTokenData as WhatsAppToken).expirationDate!;
      final isTokenExpired = DateTime.now().isAfter(DateTime.parse(expirationDate));

      _isWhatsappTokenValid(!isTokenExpired);

      if (isWhatsappTokenValid) {
        final seconds = DateTime.parse(expirationDate).difference(DateTime.now()).inSeconds;
        _secondsToExpireCode(seconds);
      } else {
        LocalStorage.deleteDataUnderLocalStorageKey(LocalStorageKey.whatsappTokenData);
      }

      debugPrint('>> Token still valid $isWhatsappTokenValid');
    }
  }

  Future<void> verifyShouldShowResendEmailButton() async {
    checkIfEmailWasVerified();

    if (!tiutiuUserController.tiutiuUser.emailVerified) {
      final lastSendEmailTime = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.lastSendEmailTime);
      debugPrint('>> verify should resend email storage data $lastSendEmailTime');

      if (lastSendEmailTime != null) {
        final minutes = DateTime.now().difference(DateTime.parse(lastSendEmailTime)).inMinutes;

        if (minutes >= 2) {
          debugPrint('>> last sent email is expired...');
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
      debugPrint('>> resending Email verification...');

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
      setLoading(true, AuthStrings.registeringUser);
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
    setLoading(true, AuthStrings.loginInProgress);

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

    debugPrint('${success ? 'Successfully' : 'Not'} authenticated');

    return success;
  }

  Future<bool> loginWithFacebook({bool firstLogin = true}) async {
    setLoading(true, AuthStrings.loginInProgress);

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
    setLoading(true, AuthStrings.loginInProgress);

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
    setLoading(true, AuthStrings.loginInProgress);

    await _authService.loginWithApple();

    if (isLoading) {
      await loadUserData();
      registerFirstLogin();
    }

    setLoading(false, '');

    return isLoading;
  }

  Future<void> passwordReset() async {
    setLoading(true, AppStrings.wait);
    await _authService.passwordReset(emailAndPasswordAuth.email!);
    isResetingPassword = false;
    clearEmailAndPassword();
    setLoading(false, '');
    isLoading = false;
  }

  Future<bool> tryAutoLoginIn() async {
    bool success = user != null;
    debugPrint('>> trying automatically login...');

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

    debugPrint('>> Successfull login? $success');
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
    debugPrint('>> trying log in using email and password');
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

    debugPrint('>> trying log in using email and password failed');
    return false;
  }

  Future<bool> tryLoginWithFacebook() async {
    debugPrint('>> trying log in with facebook');

    final firstLogin = await LocalStorage.getBooleanKey(
      key: LocalStorageKey.facebookAuthData,
      standardValue: true,
    );

    debugPrint('>> First Login? $firstLogin');

    if (!firstLogin) {
      return loginWithFacebook(firstLogin: firstLogin);
    }

    debugPrint('>> trying log in with facebook failed');
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
        final lastSignInTime = _authService.authUser?.metadata.lastSignInTime;
        final creationTime = _authService.authUser?.metadata.creationTime;
        final loggedUser = tiutiuUserController.tiutiuUser;

        _isUpdatingUserDataOnServer(true);
        await user?.reload();

        final fcmToken = await FirebaseMessaging.instance.getToken();
        debugPrint('>> Updating FCM Token $fcmToken');
        tiutiuUserController.updateTiutiuUser(
          TiutiuUserEnum.notificationToken,
          fcmToken,
        );

        if (creationTime != null) {
          debugPrint('>> Updating createAt...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.createdAt,
            creationTime.toIso8601String(),
          );
        }

        if (lastSignInTime != null) {
          debugPrint('>> Updating lastSeen...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.lastLogin,
            lastSignInTime.toIso8601String(),
          );
        }

        debugPrint('>> Updating emailVerified... ${user?.emailVerified}');
        tiutiuUserController.updateTiutiuUser(
          TiutiuUserEnum.emailVerified,
          user?.emailVerified ?? false,
        );

        if (loggedUser.displayName == null) {
          debugPrint('>> Updating displayName...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.displayName,
            user?.displayName,
          );
        }

        if (loggedUser.avatar == null) {
          debugPrint('>> Updating avatar...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.avatar,
            user?.photoURL,
          );
        }

        if (loggedUser.phoneNumber == null) {
          debugPrint('>> Updating phoneNumber...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.phoneNumber,
            user?.phoneNumber,
          );
        }

        if (loggedUser.uid == null) {
          debugPrint('>> Updating uid...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.uid,
            loggedUser.uid ?? user!.uid,
          );
        }

        if (loggedUser.email == null) {
          debugPrint('>> Updating email...');
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.email,
            authController.user!.email,
          );
        }

        if (!user!.emailVerified && allowResendEmail) {
          sendEmail();
        }

        await tiutiuUserController.updateUserDataOnServer();
        _isUpdatingUserDataOnServer(false);
      }
    } on FirebaseAuthException catch (exception) {
      debugPrint('>> An error ocurred when updating user info: ${exception.message}');
      throw TiuTiuAuthException(exception.code);
    }
  }

  Future<void> signOut() async {
    debugPrint('>> Login out...');
    await _authService.logOut();
    debugPrint('>> User ${_authService.authUser}');
    clearAllAuthData();
    clearEmailAndPassword();
    debugPrint('>> Cleaning cache...');
    tiutiuUserController.checkUserRegistered();
    debugPrint('>> Logout done!');
    recordLogoutTimeNow();
    setLoading(false, '');
    debugPrint('>> User still exists? ${_authService.userExists}');
  }

  void clearAllAuthData() {
    tiutiuUserController.resetUserWithThisUser();
    LocalStorage.clearStorage();
  }

  final _startScreenImages = [
    StartScreenAssets.munkun,
    StartScreenAssets.greyCat,
    StartScreenAssets.whiteCat,
    StartScreenAssets.pinscher,
    StartScreenAssets.oldMel,
    StartScreenAssets.liu,
    StartScreenAssets.husky,
    StartScreenAssets.hairy,
  ];

  List<String> get startScreenImages => _startScreenImages;
}
