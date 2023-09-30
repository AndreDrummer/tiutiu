import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class Validators {
  static String? verifyEquity({String? repeatPassword, String? password}) {
    if (password != repeatPassword) return AppLocalizations.of(Get.context!)!.passwordNotMatch;
    return null;
  }

  static String? verifyLength(String? value, {String field = 'Senha', int length = 6}) {
    if (value != null && value.length < length) {
      return AppLocalizations.of(Get.context!)!.fieldShouldBeAtLeast(field, length);
    }
    return null;
  }

  static String? verifyEmail(String? value) {
    if (value != null && !value.isEmail) {
      return AppLocalizations.of(Get.context!)!.invalidEmail;
    }
    return null;
  }

  static String? verifyEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(Get.context!)!.requiredField;
    }
    return null;
  }

  static bool isValidPhone(String? value) {
    if (value == null) return false;

    value = value.replaceAll('(', '');
    value = value.replaceAll(')', '');
    value = value.replaceAll('-', '');
    value = value.replaceAll(' ', '');

    if (!value.isPhoneNumber) {
      return false;
    }

    return true;
  }
}
