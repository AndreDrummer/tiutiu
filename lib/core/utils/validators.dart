import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

class Validators {
  static String? verifyEquity({String? repeatPassword, String? password}) {
    if (password != repeatPassword) return AuthStrings.passwordNotMatch;
    return null;
  }

  static String? verifyLength(String? value, {String field = 'Senha', int length = 6}) {
    if (value != null && value.length < length) {
      return AuthStrings.passwordShouldBeAtLeast(field, length);
    }
    return null;
  }

  static String? verifyEmail(String? value) {
    if (value != null && !value.isEmail) {
      return AuthStrings.invalidEmail;
    }
    return null;
  }

  static String? verifyEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return ValidatorsStrings.requiredField;
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
