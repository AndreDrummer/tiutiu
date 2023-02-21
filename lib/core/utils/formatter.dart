import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class Formatters {
  static String? unmaskNumber(String? number) {
    try {
      number = number?.replaceAll('(', '');
      number = number?.replaceAll(')', '');
      number = number?.replaceAll('-', '');
      number = number?.replaceAll(' ', '');
    } catch (error) {
      if (kDebugMode) debugPrint('TiuTiuApp: Error when unmasking phoneNumber $number. $error');
      rethrow;
    }
    return number;
  }

  static String? removeParaenthesisFromNumber(String? number) {
    try {
      number = number?.replaceAll('(', '');
      number = number?.replaceAll(')', '');
    } catch (error) {
      if (kDebugMode) debugPrint('TiuTiuApp: Error when unmasking phoneNumber $number. $error');
      rethrow;
    }
    return number;
  }

  static String? currencyFormmater(String? value) {
    final Locale locale = Localizations.localeOf(Get.context!);
    final currency = NumberFormat.currency(
      symbol: locale.languageCode == 'pt' ? 'R\$' : '\$',
      locale: locale.languageCode,
      decimalDigits: 2,
    );

    return currency.format(double.tryParse(value ?? '0') ?? 0);
  }

  static DateTime getDateTime(String createdAt) {
    final date = createdAt.split('T').first;

    final day = int.parse(date.split('-').last);
    final month = int.parse(date.split('-')[1]);
    final year = int.parse(date.split('-').first);

    final dateTime = DateTime(year, month, day);
    return dateTime;
  }

  static String getFormattedDate(String createdAt) {
    final date = getDateTime(createdAt);

    return DateFormat('dd/MM/yyy').format(date);
  }

  static String getFormattedDateAndTime(String createdAt) {
    final date = getDateTime(createdAt);
    final timeMinute = DateTime.parse(createdAt).minute;
    final timeHour = DateTime.parse(createdAt).hour;

    return DateFormat('dd/MM/yyy').format(date) + ' $timeHour:${timeMinute < 10 ? '0$timeMinute' : timeMinute}';
  }

  static String getExtendedLocalizedDate() {
    final locale = Localizations.localeOf(Get.context!);

    return getExtendedDateBasedOnLocale(locale);
  }

  static String getFormattedTime(String createdAt) {
    final timeMinute = DateTime.parse(createdAt).minute;
    final timeHour = DateTime.parse(createdAt).hour;

    return '$timeHour:${timeMinute < 10 ? '0$timeMinute' : timeMinute}';
  }

  static String timeSecondsFormmated(int seconds) {
    var min = seconds ~/ 60;
    var sec = seconds % 60;
    if (min == 0) {
      return '$sec\s';
    } else {
      return '$min min ${sec < 10 ? '0$sec' : sec} seg';
    }
  }

  static String timeMinutesFormmated(int minutes) {
    int hour = minutes ~/ 60;
    int min = minutes % 60;
    if (hour == 0 && min == 1) {
      return '$min minuto';
    } else if (hour > 1 && min == 0) {
      return '$hour horas';
    } else if (hour == 1 && min == 0) {
      return '$hour hora';
    } else if (hour == 0 && min > 1) {
      return '$min minutos';
    } else if (hour == 1 && min == 1) {
      return '$hour hora e $min minuto';
    } else if (hour == 1 && min > 1) {
      return '$hour hora e $min minutos';
    } else if (hour > 1 && min == 1) {
      return '$hour horas e $min minuto';
    } else {
      return '$hour horas e $min minutos';
    }
  }

  static String cuttedText(String message, {int size = 20, bool showElipses = true}) {
    if (message.length > size) return message.substring(0, size) + '${showElipses ? '...' : ''}';
    return message;
  }

  static String formmatedExtendedDate({DateTime? dateTime}) {
    final formattedDate = DateFormat('EEEE, DD/MM/yyyy', Localizations.localeOf(Get.context!).toLanguageTag())
        .format(dateTime ?? DateTime.now().toLocal());

    final weekday = OtherFunctions.firstCharacterUpper(formattedDate.split(',').first);

    return '${weekday.trim()}, ${getExtendedLocalizedDate()}.';
  }

  static String getExtendedDateBasedOnLocale(Locale locale) {
    final date = DateFormat('dd/MM/yyy').format(DateTime.now());
    List<int> splittedDate = date.split('/').map((e) => int.parse(e)).toList();

    if (locale.languageCode == 'pt') {
      return splittedDate.first.toString() + ' de ' + _yearMonths[splittedDate[1] - 1] + ' de ${splittedDate.last}';
    } else if (locale.languageCode == 'en') {
      return _yearMonths[splittedDate[1] - 1] + ' ${splittedDate.first.toString()},' + ' ${splittedDate.last}';
    } else if (locale.languageCode == 'es') {
      return splittedDate.first.toString() + ' de ' + _yearMonths[splittedDate[1] - 1] + ' de ${splittedDate.last}';
    } else {
      return _yearMonths[splittedDate[1] - 1] + ' ${splittedDate.first.toString()},' + ' ${splittedDate.last}';
    }
  }

  static List<String> get _yearMonths => [
        AppLocalizations.of(Get.context!).january,
        AppLocalizations.of(Get.context!).february,
        AppLocalizations.of(Get.context!).march,
        AppLocalizations.of(Get.context!).april,
        AppLocalizations.of(Get.context!).may,
        AppLocalizations.of(Get.context!).june,
        AppLocalizations.of(Get.context!).july,
        AppLocalizations.of(Get.context!).august,
        AppLocalizations.of(Get.context!).september,
        AppLocalizations.of(Get.context!).october,
        AppLocalizations.of(Get.context!).november,
        AppLocalizations.of(Get.context!).december,
      ];
}
