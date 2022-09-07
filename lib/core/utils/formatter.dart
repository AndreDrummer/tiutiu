import 'package:intl/intl.dart';

class Formatter {
  static String? unmaskNumber(String number) {
    try {
      String serializedNumber = number
          .split('(')[1]
          .replaceAll(')', '')
          .replaceAll('-', '')
          .replaceAll(' ', '');
      return serializedNumber;
    } catch (error) {
      return null;
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
}
