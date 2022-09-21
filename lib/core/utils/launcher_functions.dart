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

  static Future<void> openWhatsApp({required String number}) async {
    final uri = Uri.parse('https://api.whatsapp.com/send/?phone=+55$number');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch ${uri.data?.contentText}';
    }
  }
}
