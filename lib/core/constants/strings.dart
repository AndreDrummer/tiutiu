import 'package:get/get.dart';
import 'package:tiutiu/core/constants/contact_type.dart';

class CustomStrings {
  static String watchAnAd(ContactType contactType, bool noPreviousData) {
    if (noPreviousData) {
      if (contactType == ContactType.whatsapp)
        return _CustomLocalizationStrings(stringKey: "watchAnAdWhatsApp").localizedString();
      return _CustomLocalizationStrings(stringKey: "watchAnAdChat").localizedString();
    } else {
      if (contactType == ContactType.whatsapp)
        return _CustomLocalizationStrings(stringKey: "whatsappTalkLimitedExceed").localizedString();
      return _CustomLocalizationStrings(stringKey: "chatTalkLimitedExceed").localizedString();
    }
  }

  static String talkAboutThisPet({
    required String petGender,
    required String petName,
  }) {
    final cuttedName = petName.split(' ').first;

    if (petGender == 'Macho') {
      return 'Fale sobre o $cuttedName';
    } else if (petGender == 'Fêmea') {
      return 'Fale sobre a $cuttedName';
    }

    return 'Fale sobre este animal?';
  }

  static String whereIsThisPet({
    bool isDisappeared = false,
    required String petGender,
    required String petName,
  }) {
    if (isDisappeared) return 'Onde foi visto pela última vez?';

    if (petGender == 'male')
      return 'Onde ele está';
    else if (petGender == 'female') return 'Onde ela está';
    return 'Onde está o PET';
  }
}

class _CustomLocalizationStrings {
  _CustomLocalizationStrings({required this.stringKey});

  final String stringKey;

  String localizedString() {
    final currentLocale = Get.locale;

    print(currentLocale);

    return stringKey;
  }

  Map<String, dynamic> strings() {
    return {
      "pt": {
        "whatsappTalkLimitedExceed": "Limite de conversas via WhatsApp atingido.\n\nAssista um vídeo para renovar.",
        "chatTalkLimitedExceed": "Limite de conversas via Chat atingido.\n\nAssista um vídeo para renovar.",
        "watchAnAdWhatsApp": "Assista um vídeo para conversar via WhatsApp.",
        "watchAnAdChat": "Assista um vídeo para conversar via Chat.",
      },
      "es": {
        "whatsappTalkLimitedExceed": "Se alcanzó el límite de chat a través de WhatsApp.\n\nVea un video para renovar.",
        "chatTalkLimitedExceed": "Límite de chat alcanzado.\n\nMira un video para renovar.",
        "watchAnAdWhatsApp": "Ver un video para chatear a través de WhatsApp.",
        "watchAnAdChat": "Ver un video para chatear a través de Chat.",
      },
      "en": {
        "whatsappTalkLimitedExceed": "Chat limit reached via WhatsApp.\n\nWatch a video to renew.",
        "chatTalkLimitedExceed": "Chat limit reached.\n\nWatch a video to renew.",
        "watchAnAdWhatsApp": "Watch a video to chat via WhatsApp.",
        "watchAnAdChat": "Watch a video to chat via Chat.",
      },
    };
  }
}
