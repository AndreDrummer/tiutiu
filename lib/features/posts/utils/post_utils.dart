import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/ordenators.dart';
import 'package:flutter/foundation.dart';

class PostUtils {
  static List<Post> filterPosts({required List<Post> postsList}) {
    final filterParams = filterController.getParams;

    debugPrint('TiuTiuApp: filteredPosts');
    debugPrint('TiuTiuApp: filters $filterParams');

    final filteredByType = _filterByType(postsList, filterParams.type);
    final filteredByState = _filterByState(filteredByType, filterParams.state);

    final filteredByDisappeared = _filterByDisappeared(
      filteredByState,
      filterParams.disappeared,
    );

    final isFilteringByName = filterParams.name.isNotEmptyNeighterNull();
    final filteredList = filteredByDisappeared;

    final returnedList = _ordernatedList(
      isFilteringByName ? _filterByName(postsList, filterParams.name) : filteredList,
      filterParams.orderBy,
    );

    return returnedList.where((post) => post.timesDennounced <= 3).toList();
  }

  static List<Post> _filterByName(List<Post> postsList, String filterName) {
    List<Post> postsFilteredByName = [];

    postsList.forEach((post) {
      final isFilteringByName = filterName.isNotEmptyNeighterNull();

      String petName = post.name!.toLowerCase();

      if (isFilteringByName) {
        if (petName.contains(filterName.toLowerCase())) {
          postsFilteredByName.add(post);
        }
      } else {
        postsFilteredByName.add(post);
      }
    });

    return postsFilteredByName;
  }

  static List<Post> _filterByType(List<Post> list, String type) {
    debugPrint('TiuTiuApp: _filterByType');

    if (type != PetTypeStrings.all) {
      return list.where((post) {
        return post.type == type;
      }).toList();
    }

    return list;
  }

  static List<Post> _filterByState(List<Post> list, String state) {
    debugPrint('TiuTiuApp: _filterByState');

    final isBr = state == StatesAndCities.stateAndCities.stateInitials.first;

    if (!isBr) {
      final filterState = StatesAndCities.stateAndCities.getStateNameFromInitial(state);

      return list.where((post) {
        return post.state == filterState;
      }).toList();
    }

    return list;
  }

  static List<Post> _filterByDisappeared(List<Post> list, bool disappeared) {
    debugPrint('TiuTiuApp: _filterByDisappeared');
    return list.where((post) {
      return (post as Pet).disappeared == disappeared;
    }).toList();
  }

  static List<Post> _ordernatedList(List<Post> list, String orderParam) {
    if (orderParam == FilterStrings.distance) {
      list.sort(Ordenators.orderByDistance);
    } else if (orderParam == FilterStrings.date) {
      list.sort(Ordenators.orderByPostDate);
    } else if (orderParam == FilterStrings.age) {
      list.sort(Ordenators.orderByAge);
    } else if (orderParam == FilterStrings.name) {
      list.sort(Ordenators.orderByName);
    }

    return list;
  }
}
