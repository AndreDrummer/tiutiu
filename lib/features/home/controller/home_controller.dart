import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum BottomBarIndex {
  DONATE(indx: 0),
  VIDEOS(indx: 1),
  POST(indx: 2),
  FINDER(indx: 3),
  MORE(indx: 4);

  const BottomBarIndex({
    required this.indx,
  });

  final int indx;
}

enum CardVisibilityKind {
  banner,
  card,
}

class HomeController extends GetxController {
  final Rx<CardVisibilityKind> _cardVisibilityKind = CardVisibilityKind.banner.obs;
  final ScrollController _scrollController = ScrollController();
  final RxBool _isAppBarCollapsed = false.obs;
  final RxInt _bottomBarIndex = 0.obs;

  CardVisibilityKind get cardVisibilityKind => _cardVisibilityKind.value;

  ScrollController get scrollController => _scrollController;
  bool get isAppBarCollapsed => _isAppBarCollapsed.value;
  int get bottomBarIndex => _bottomBarIndex.value;

  void set isAppBarCollapsed(bool value) {
    _isAppBarCollapsed(value);
  }

  void _setbottomBarIndex(BottomBarIndex index) {
    tiutiuUserController.checkUserRegistered();

    filterController.updateParams(FilterParamsEnum.disappeared, false);

    if (index == BottomBarIndex.FINDER) {
      filterController.updateParams(FilterParamsEnum.disappeared, true);
    }

    _bottomBarIndex(index.indx);
  }

  void setCardVisibilityToDefaut() {
    _cardVisibilityKind(CardVisibilityKind.banner);
  }

  void onScrollUp() {
    _scrollController.animateTo(
      duration: new Duration(milliseconds: 1500),
      curve: Curves.ease,
      0,
    );
  }

  void changeCardVisibilityKind() {
    if (cardVisibilityKind == CardVisibilityKind.card) {
      setCardVisibilityToDefaut();
    } else {
      _cardVisibilityKind(CardVisibilityKind.card);
    }
  }

  void setIndex(int index) {
    _setbottomBarIndex(BottomBarIndex.values.where((bottomBarIndex) => bottomBarIndex.indx == index).first);
  }

  void setDonateIndex() {
    _setbottomBarIndex(BottomBarIndex.DONATE);
  }

  void setVideosIndex() {
    _setbottomBarIndex(BottomBarIndex.VIDEOS);
  }

  void setPostIndex() {
    _setbottomBarIndex(BottomBarIndex.POST);
  }

  void setFinderIndex() {
    _setbottomBarIndex(BottomBarIndex.FINDER);
  }

  void setMoreIndex() {
    _setbottomBarIndex(BottomBarIndex.MORE);
  }
}
