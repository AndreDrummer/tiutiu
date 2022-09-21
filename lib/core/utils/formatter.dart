import 'package:intl/intl.dart';

class Formatter {
  static String unmaskNumber(String number) {
    try {
      String serializedNumber = number
          .split('(')[1]
          .replaceAll(')', '')
          .replaceAll('-', '')
          .replaceAll(' ', '');
      return serializedNumber;
    } catch (error) {
      return number;
    }
  }

  static DateTime getDateTime(String createdAt) {
    final date = createdAt.split('T').first;

    // debugPrint('>> $date before');

    final day = int.parse(date.split('-').last);
    final month = int.parse(date.split('-')[1]);
    final year = int.parse(date.split('-').first);

    // debugPrint('>> $day/$month/$year after');

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

    return DateFormat('dd/MM/yyy').format(date) + ' $timeHour:$timeMinute';
  }

  static String timeFormmated(int minutes) {
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
