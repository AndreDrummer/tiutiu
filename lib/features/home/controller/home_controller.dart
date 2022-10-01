import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/system/controllers.dart';

enum CardVisibilityKind {
  banner,
  card,
}

class HomeController extends GetxController {
  final ScrollController _scrollController = ScrollController();
  final Rx<CardVisibilityKind> _cardVisibilityKind =
      CardVisibilityKind.card.obs;
  final RxBool _showAuthHostersInFullScreen = false.obs;
  final RxBool _isAppBarCollapsed = false.obs;
  final RxInt _bottomBarIndex = 0.obs;

  CardVisibilityKind get cardVisibilityKind => _cardVisibilityKind.value;

  bool get showAuthHostersInFullScreen => _showAuthHostersInFullScreen.value;
  ScrollController get scrollController => _scrollController;
  bool get isAppBarCollapsed => _isAppBarCollapsed.value;
  int get bottomBarIndex => _bottomBarIndex.value;

  void set showAuthHostersInFullScreen(bool value) {
    _showAuthHostersInFullScreen(value);
  }

  void set isAppBarCollapsed(bool value) {
    _isAppBarCollapsed(value);
  }

  void set bottomBarIndex(int? index) {
    if (authController.userExists) {
      showAuthHostersInFullScreen = false;
    }

    _bottomBarIndex(index ?? bottomBarIndex);
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
}
