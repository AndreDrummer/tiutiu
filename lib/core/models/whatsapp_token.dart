import 'package:tiutiu/core/models/mapper.dart';

enum WhatsAppTokenEnum {
  expirationDate,
  code,
}

class WhatsAppToken implements Mapper {
  WhatsAppToken({
    this.expirationDate,
    this.code,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      WhatsAppTokenEnum.expirationDate.name: expirationDate,
      WhatsAppTokenEnum.code.name: code,
    };
  }

  String? expirationDate;
  String? code;

  @override
  Mapper fromMap(Map<String, dynamic> map) {
    return WhatsAppToken(
      expirationDate: map[WhatsAppTokenEnum.expirationDate.name],
      code: map[WhatsAppTokenEnum.code.name],
    );
  }
}
