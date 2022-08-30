import 'package:url_launcher/url_launcher.dart';

class Launcher {
  static Future<void> makePhoneCall({String? number}) async {
    String url = 'tel: $number';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
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

  static Future<void> openWhatsApp({String? number, String? message}) async {
    // FlutterOpenWhatsapp.sendSingleMessage('+55$number',
    //     message ?? 'Olá! Vamos conversar sobre o Pet postado no *Tiu, tiu* ?');
  }

  static Future<void> openBrowser({String? url}) async {
    if (await canLaunchUrl(Uri.parse(url!))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
