import 'package:dio/dio.dart';

class RefineSearchServices {
  void loadCityByState(String stateInitial) async {
    try {
      final response = await Dio().get(
          'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${stateInitial.toLowerCase()}/municipios');
      print(response);
    } catch (e) {
      print(e);
    }
  }
}
