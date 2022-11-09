import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Formatters {
  static String? unmaskNumber(String? number) {
    try {
      number = number?.replaceAll('(', '');
      number = number?.replaceAll(')', '');
      number = number?.replaceAll('-', '');
      number = number?.replaceAll(' ', '');
    } catch (error) {
      debugPrint('>> Error when unmasking phoneNumber $number. $error');
    }
    return number;
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

  static String timeSecondsFormmated(int seconds) {
    var min = seconds ~/ 60;
    var sec = seconds % 60;
    if (min == 0) {
      return '$sec\s';
    } else {
      return '$min min ${sec < 10 ? '0$sec' : sec} seg ';
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
}
