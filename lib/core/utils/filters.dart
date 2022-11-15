import 'package:tiutiu/core/pets/model/pet_model.dart';

class Filters {
  static List<Pet> filterResultsByAgeOver10(List<Pet> petsListResult) {
    List<Pet> newPetList = [];

    for (int i = 0; i < petsListResult.length; i++) {
      if (petsListResult[i].ageYear >= 10) {
        newPetList.add(petsListResult[i]);
      }
    }

    return newPetList;
  }
}
