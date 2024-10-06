import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static Future<void> sendEmail({
    String? emailAddress,
    String? subject,
    String? message,
  }) async {
    var url = 'mailto:$emailAddress?subject=$subject&body=$message';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openBrowser(String link) async {
    final uri = Uri.parse(link);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch ${uri.data?.contentText}';
    }
  }

  static Future<void> openWhatsApp({required String countryCode, required String number, String? text}) async {
    final finalCountryCode = countryCode.replaceAll('+', '');

    final uri = Uri.parse(
        'https://api.whatsapp.com/send/?phone=$finalCountryCode${Formatters.unmaskNumber(number)}&text=${text ?? ''}');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch ${uri.data?.contentText}';
    }
  }

  static Uri createCoordinatesUri(double latitude, double longitude, [String? label]) {
    Uri uri;

    if (kIsWeb) {
      uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$latitude,$longitude'});
    } else if (Platform.isAndroid) {
      var query = '$latitude,$longitude';

      if (label != null) query += '($label)';

      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      var params = {
        'll': '$latitude,$longitude',
        'q': label ?? '$latitude, $longitude',
      };

      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$latitude,$longitude'});
    }

    return uri;
  }

  static Future<bool> openMaps(double latitude, double longitude, [String? label]) async {
    return launchUrl(createCoordinatesUri(latitude, longitude, label));
  }
}
