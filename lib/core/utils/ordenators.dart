import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/math_functions.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/formatter.dart';

class Ordenators {
  static int orderByPostDate(Post a, Post b) {
    return DateTime.parse(b.createdAt!).millisecondsSinceEpoch - DateTime.parse(a.createdAt!).millisecondsSinceEpoch;
  }

  static int orderByName(Post a, Post b) {
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

  static int orderByDistance(Post ad1, Post ad2) {
    final postADate = Formatters.getDateTime(ad1.createdAt!);
    final postBDate = Formatters.getDateTime(ad2.createdAt!);
    LatLng location = currentLocationController.location;

    double distance1 = MathFunctions.distanceMatrix(
      longX: location.longitude,
      latX: location.latitude,
      longY: ad1.longitude!,
      latY: ad1.latitude!,
    );

    double distance2 = MathFunctions.distanceMatrix(
      longX: location.longitude,
      latX: location.latitude,
      longY: ad2.longitude!,
      latY: ad2.latitude!,
    );

    if (distance1 < distance2) return -1;
    if (distance1 > distance2) return 1;
    return postADate.isBefore(postBDate) ? -1 : 1;
  }

  static int orderByAge(Post a, Post b) {
    if ((a as Pet).ageYear == (b as Pet).ageYear) return a.ageMonth - b.ageMonth;
    return a.ageYear - b.ageYear;
  }
}
