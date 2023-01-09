import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/delete_account/service/delete_account_service.dart';
import 'package:tiutiu/features/delete_account/model/delete_account.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

class DeleteAccountController extends GetxController with TiuTiuPopUp {
  DeleteAccountController({
    required DeleteAccountService deleteAccountService,
  }) : _deleteAccountService = deleteAccountService;

  final DeleteAccountService _deleteAccountService;

  final RxString _deleteAccountMotive = DeleteAccountStrings.other.obs;
  final RxString _deleteAccountMotiveDescribed = ''.obs;
  final RxInt _deleteAccountGroupValue = 7.obs;
  final RxString _loadingText = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;

  String get deleteAccountMotiveDescribed => _deleteAccountMotiveDescribed.value;
  int get deleteAccountGroupValue => _deleteAccountGroupValue.value;
  List<String> get deleteAccountMotives => _deleteAccountMotives;
  String get deleteAccountMotive => _deleteAccountMotive.value;
  String get loadingText => _loadingText.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;

  void set deleteAccountMotiveDescribed(String value) => _deleteAccountMotiveDescribed(value);
  void set deleteAccountGroupValue(int value) => _deleteAccountGroupValue(value);
  void set deleteAccountMotive(String motive) => _deleteAccountMotive(motive);
  void set hasError(bool value) => _hasError(value);

  Future<bool> canDeleteAccount() async {
    String? lastLogoutTime = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.lastLogoutTime);
    bool logoutTimeOver2Minutes = true;

    if (lastLogoutTime != null) {
      final lastLogoutDateTime = DateTime.parse(lastLogoutTime);
      logoutTimeOver2Minutes = DateTime.now().difference(lastLogoutDateTime).inMinutes >= 2;

      return !logoutTimeOver2Minutes;
    }

    return false;
  }

  Future<void> deleteAccountForever() async {
    _setLoading(true, DeleteAccountStrings.deletingAccountStarting);

    final loggedUser = tiutiuUserController.tiutiuUser;
    final DeleteAccount deleteAccountData = DeleteAccount(
      descrivedMotive: deleteAccountMotiveDescribed,
      displayName: 'Usuário Excluído',
      userEmail: loggedUser.email!,
      motive: deleteAccountMotive,
      userDeleted: true,
    );

    await _deleteAccountService.deleteAccountForever(
      deleteAccountData: deleteAccountData,
      onPostsDeletionStarts: () {
        _setLoading(true, DeleteAccountStrings.deletingAds);
      },
      userId: loggedUser.uid!,
      onFinishing: () {
        _setLoading(true, DeleteAccountStrings.finishing);
      },
    );

    _setLoading(false, '');
    await showAccountDeletedFeedbackPopup();
  }

  Future<void> showDeleteAccountLogoutWarningPopup() async {
    await showPopUp(
      secondaryAction: () {
        Get.back();
        authController.signOut();
      },
      message: AuthStrings.demandRecentLoginWarning,
      backGroundColor: AppColors.warning,
      title: AuthStrings.doLogin,
      confirmText: AppStrings.yes,
      textColor: AppColors.black,
      barrierDismissible: false,
      denyText: AppStrings.no,
      mainAction: Get.back,
    );
  }

  Future<void> showAccountDeletedFeedbackPopup() async {
    await showPopUp(
      message: DeleteAccountStrings.foreverDeletedAccount,
      title: DeleteAccountStrings.deleteAccount,
      confirmText: AppStrings.ok,
      barrierDismissible: false,
      mainAction: () {
        Get.back();
        Get.offNamedUntil(Routes.startScreen, (route) {
          return route.settings.name == Routes.home;
        });
      },
      backGroundColor: AppColors.danger,
    );
  }

  void _setLoading(bool value, String loadingText) {
    _isLoading(value);
    _loadingText(loadingText);
  }

  void reset() {
    deleteAccountMotive = DeleteAccountStrings.other;
    deleteAccountMotiveDescribed = '';
    deleteAccountGroupValue = 7;
  }

  List<String> _deleteAccountMotives = [
    DeleteAccountStrings.alreadyAdopted,
    DeleteAccountStrings.alreadyDonated,
    DeleteAccountStrings.noPetInMyRegion,
    DeleteAccountStrings.alreadyFoundPet,
    DeleteAccountStrings.cannotUse,
    DeleteAccountStrings.muchAds,
    DeleteAccountStrings.bugs,
    DeleteAccountStrings.other,
  ];
}
