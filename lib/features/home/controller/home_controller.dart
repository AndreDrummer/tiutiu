import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum BottomBarIndex {
  FAVORITES(indx: 4),
  PROFILE(indx: 3),
  FINDER(indx: 1),
  DONATE(indx: 0),
  POST(indx: 2);

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
  final ScrollController _scrollController = ScrollController();
  final Rx<CardVisibilityKind> _cardVisibilityKind = CardVisibilityKind.card.obs;
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
    if (index == BottomBarIndex.FAVORITES) {
      _cardVisibilityKind(CardVisibilityKind.banner);
    } else {
      _cardVisibilityKind(CardVisibilityKind.card);
    }

    _bottomBarIndex(index.indx);
  }

  void onScrollUp() {
    _scrollController.animateTo(
      duration: new Duration(seconds: 2),
      curve: Curves.ease,
      0,
    );
  }

  void changeCardVisibilityKind() {
    if (cardVisibilityKind == CardVisibilityKind.card) {
      _cardVisibilityKind(CardVisibilityKind.banner);
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

  void setFinderIndex() {
    _setbottomBarIndex(BottomBarIndex.FINDER);
  }

  void setPostIndex() {
    _setbottomBarIndex(BottomBarIndex.POST);
  }

  void setProfileIndex() {
    _setbottomBarIndex(BottomBarIndex.PROFILE);
  }

  void setFavoriteIndex() {
    _setbottomBarIndex(BottomBarIndex.FAVORITES);
  }
}
