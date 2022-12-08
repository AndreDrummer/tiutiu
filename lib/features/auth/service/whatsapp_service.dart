import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class WhatsappService {
  WhatsappService({
    required this.phoneNumber,
    required this.code,
  });
  final String phoneNumber;
  final String code;

  Future<void> sendCodeVerification() async {
    final _dio = Dio();

    final DocumentSnapshot<Map<String, dynamic>> keys = await _getWhatsappKeys();
    final bool allowProd = keys.get(FirebaseEnvPath.allowUseWhatsappProdNumber);

    final String template = keys.get(
      allowProd ? FirebaseEnvPath.whatsappTemplateProd : FirebaseEnvPath.whatsappTemplateDebug,
    );

    final String numberId = keys.get(
      allowProd ? FirebaseEnvPath.whatsappNumberIdProd : FirebaseEnvPath.whatsappNumberIdDebug,
    );

    final String token = keys.get(
      allowProd ? FirebaseEnvPath.whatsappTokenProd : FirebaseEnvPath.whatsappTokenDebug,
    );

    String endpoint = 'https://graph.facebook.com/v15.0/$numberId/messages';

    final bodyDebug = {
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

    final bodyProd = {
      "messaging_product": "whatsapp",
      "recipient_type": "individual",
      "to": "55$phoneNumber",
      "type": "text",
      "text": {
        "preview_url": false,
        "body":
            "*Código de verificação Tiu, tiu App*\n\nInsira esse código de verificação para validar seu número de telefone: *$code*."
      }
    };

    try {
      _dio.post(
        endpoint,
        data: kDebugMode ? bodyDebug : bodyProd,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'application/json',
        ),
      );
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getWhatsappKeys() async {
    return await FirebaseFirestore.instance.collection(FirebaseEnvPath.projectName).doc(FirebaseEnvPath.keys).get();
  }
}
