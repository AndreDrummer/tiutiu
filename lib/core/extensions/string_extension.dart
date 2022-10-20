import 'package:tiutiu/core/utils/constantes.dart';

extension TiutiuStringExtension on String {
  String capitalize() {
    String output = '';
    return this
        .split(' ')
        .map((word) {
          if (!word.isEmpty) {
            return output += word[0].toUpperCase() + word.substring(1) + " ";
          } else {
            return output;
          }
        })
        .toList()
        .last
        .toString();
  }

  String removeAccent() {
    return this
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('à', 'a')
        .replaceAll('á', 'a')
        .replaceAll('Â', 'a')
        .replaceAll('Ã', 'a')
        .replaceAll('À', 'a')
        .replaceAll('Á', 'a')
        .replaceAll('ê', 'e')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('Ê', 'e')
        .replaceAll('É', 'e')
        .replaceAll('È', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('Í', 'i')
        .replaceAll('Ì', 'i')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ó', 'o')
        .replaceAll('Ô', 'o')
        .replaceAll('Õ', 'o')
        .replaceAll('Ò', 'o')
        .replaceAll('Ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('Ú', 'u')
        .replaceAll('Ù', 'u')
        .toLowerCase();
  }

  bool isAsset() => this.contains(Constantes.ASSETS);
  bool isUrl() => this.contains(Constantes.HTTP);
}

extension NullableStringExtension on dynamic {
  bool isNotEmptyNeighterNull() {
    return this != null && this!.toString().isNotEmpty && this != '-';
  }
}
