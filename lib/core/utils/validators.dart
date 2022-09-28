import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

class Validators {
  static String? verifyEquity(String? firstValue, String? secondValue) {
    if (firstValue != secondValue) return AuthStrings.passwordNotMatch;
    return null;
  }

  static String? verifyLength(String? value) {
    if (value != null && value.length < 6) {
      return AuthStrings.passwordShouldBeAtLeast6;
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
    if (value != null && value.isEmpty) {
      return ValidatorsStrings.requiredField;
    }
    return null;
  }
}
