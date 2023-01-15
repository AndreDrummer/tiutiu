import 'package:cloud_firestore/cloud_firestore.dart';

enum SupportUsEnum {
  backgroundImages,
  warningMessage,
  keyType,
  pixKey,
}

class SupportUsData {
  factory SupportUsData.fromSnapshot(DocumentSnapshot snapshot) {
    return SupportUsData(
      backgroundImages: snapshot.get(SupportUsEnum.backgroundImages.name),
      warningMessage: snapshot.get(SupportUsEnum.warningMessage.name),
      keyType: snapshot.get(SupportUsEnum.keyType.name),
      pixKey: snapshot.get(SupportUsEnum.pixKey.name),
    );
  }

  factory SupportUsData.fromMap(Map<String, dynamic> map) {
    return SupportUsData(
      backgroundImages: map[SupportUsEnum.backgroundImages.name],
      warningMessage: map[SupportUsEnum.warningMessage.name],
      keyType: map[SupportUsEnum.keyType.name],
      pixKey: map[SupportUsEnum.pixKey.name],
    );
  }

  SupportUsData({
    this.backgroundImages = const [],
    this.warningMessage = '',
    this.keyType = '',
    this.pixKey = '',
  });

  final String warningMessage;
  final List backgroundImages;
  final String keyType;
  final String pixKey;

  SupportUsData copyWith({
    String? warningMessage,
    List? backgroundImages,
    String? keyType,
    String? pixKey,
  }) {
    return SupportUsData(
      backgroundImages: backgroundImages ?? this.backgroundImages,
      warningMessage: warningMessage ?? this.warningMessage,
      keyType: keyType ?? this.keyType,
      pixKey: pixKey ?? this.pixKey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SupportUsEnum.backgroundImages.name: backgroundImages,
      SupportUsEnum.warningMessage.name: warningMessage,
      SupportUsEnum.keyType.name: keyType,
      SupportUsEnum.pixKey.name: pixKey,
      SupportUsEnum.pixKey.name: pixKey,
    };
  }

  @override
  String toString() {
    return '''SupportUsData(
      backgroundImages: $backgroundImages,
      warningMessage: $warningMessage,
      keyType: $keyType
      pixKey: $pixKey
      pixKey: $pixKey
    )''';
  }
}
