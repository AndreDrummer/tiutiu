import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class WhatsAppService {
  WhatsAppService({
    required this.phoneNumber,
    required this.countryCode,
    required this.code,
  });
  final String phoneNumber;
  final String countryCode;
  final String code;

  Future<void> sendCodeVerification() async {
    final finalCountryCode = countryCode.replaceAll('+', '');
    final _dio = Dio();

    final DocumentSnapshot<Map<String, dynamic>> keys =
        await _getWhatsappKeys();
    final bool allowProd = keys.get(FirebaseEnvPath.allowUseWhatsappProdNumber);

    final String template = keys.get(
      (allowProd || !kDebugMode)
          ? FirebaseEnvPath.whatsappTemplateProd
          : FirebaseEnvPath.whatsappTemplateDebug,
    );

    final String numberId = keys.get(
      (allowProd || !kDebugMode)
          ? FirebaseEnvPath.whatsappNumberIdProd
          : FirebaseEnvPath.whatsappNumberIdDebug,
    );

    final String token = keys.get(
      (allowProd || !kDebugMode)
          ? FirebaseEnvPath.whatsappTokenProd
          : FirebaseEnvPath.whatsappTokenDebug,
    );

    String endpoint = 'https://graph.facebook.com/v15.0/$numberId/messages';

    final body = {
      "messaging_product": "whatsapp",
      "to": "$finalCountryCode$phoneNumber",
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
          },
          {
            "type": "button",
            "sub_type": "url",
            "index": 0,
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

    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'application/json',
        ),
      );
      if (response.statusCode != 200) {
        crashlyticsController.reportAnError(
          message: 'Error ${response.statusCode} sending WhatsApp Message.',
          exception: response.data,
          stackTrace: StackTrace.current,
        );
      }
      debugPrint(
          'TiuTiuApp: Sending WhatsApp Response ${response.statusCode}: ${response.data}');
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Error sending WhatsApp Message: $exception',
        exception: exception,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getWhatsappKeys() async {
    return await FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.keys)
        .get();
  }
}
