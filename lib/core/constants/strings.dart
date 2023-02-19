import 'package:tiutiu/core/constants/contact_type.dart';

class CustomStrings {
  static String watchAnAd(ContactType contactType, bool noPreviousData) {
    return "${noPreviousData ? contactType == "whatsapp" ? "Assista um vídeo para conversar via WhatsApp." : "Assista um vídeo para conversar via Chat." : contactType == "whatsapp" ? "Limite de conversas via WhatsApp atingido.\n\nAssista um vídeo para renovar." : "Limite de conversas via Chat atingido.\n\nAssista um vídeo para renovar."}";
  }

  static String whereIsIt({
    required String petName,
    required String petGender,
    bool isDisappeared = false,
  }) {
    final cuttedName = petName.split(' ').first;
    if (isDisappeared) return 'Onde foi visto pela última vez?';

    if (petGender == 'Macho') {
      return 'Fale sobre o $cuttedName';
    } else if (petGender == 'Fêmea') {
      return 'Fale sobre a $cuttedName';
    }

    return 'Onde está o PET?';
  }

  static String whereIsIt2({
    required String petName,
    required String petGender,
  }) {
    if (petGender == 'male')
      return 'Onde ele está';
    else if (petGender == 'female') return 'Onde ela está';
    return 'Onde está o PET';
  }
}
