import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class WhatsappService {
  WhatsappService({
    required this.phoneNumber,
    required this.code,
  });
  final String phoneNumber;
  final String code;

  // final template = 'tiutiu_whatsapp_token_code_prod';
  final template = 'tiutiu_whatsapp_token_code';

  // final numberId = '100356716232975'; // Prod
  final numberId = '108901298698499'; // Test

  String get endpoint => 'https://graph.facebook.com/v15.0/$numberId/messages';
  String get applicationType => 'application/json';

  Map<String, dynamic> body() {
    return {
      "messaging_product": "whatsapp",
      "to": "55$phoneNumber",
      "type": "template",
      "template": {
        "name": "$template",
        "language": {"code": "pt_BR"},
        "components": [
          {
            "type": "body",
            "parameters": [
              {
                "type": "text",
                "text": "$code",
              }
            ]
          }
        ]
      }
    };
  }

  Future<void> sendCodeVerification() async {
    final _dio = Dio();

    final String token = await _getWhatsappToken();

    // try {
    //   _dio.post(
    //     endpoint,
    //     data: body,
    //     options: Options(
    //       contentType: applicationType,
    //       headers: {'Authorization': 'Bearer $token'},
    //     ),
    //   );
    // } on Exception catch (_) {
    //   rethrow;
    // }
  }

  Future<String> _getWhatsappToken() async {
    final docs =
        await FirebaseFirestore.instance.collection(FirebaseEnvPath.projectName).doc(FirebaseEnvPath.keys).get();

    print(docs.get(FirebaseEnvPath.whatsappToken));

    return docs.get(FirebaseEnvPath.whatsappToken);
  }
}
