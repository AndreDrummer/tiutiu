import 'package:tiutiu/features/pets/model/pet_model.dart';

class Ordenators {
  static int orderByPostDate(Pet a, Pet b) {
    return DateTime.parse(b.createdAt!).millisecondsSinceEpoch -
        DateTime.parse(a.createdAt!).millisecondsSinceEpoch;
  }

  static int orderByName(Pet a, Pet b) {
    List<int> aname = a.name!.codeUnits;
    List<int> bname = b.name!.codeUnits;

    int i = 0;
    while (i < bname.length) {
      if (bname[i] < aname[i]) {
        return 1;
      } else if (bname[i] == aname[i]) {
        i++;
        if (i >= aname.length) {
          return 1;
        }
      } else {
        return -1;
      }
    }
    return 1;
  }

  static int orderByAge(Pet a, Pet b) {
    if (a.ageYear == b.ageYear) return a.ageMonth! - b.ageMonth!;
    return a.ageYear! - b.ageYear!;
  }
}
