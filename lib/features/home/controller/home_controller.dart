import 'package:get/get.dart';

enum CardVisibilityKind {
  banner,
  card,
}

class HomeController extends GetxController {
  final Rx<CardVisibilityKind> _cardVisibilityKind =
      CardVisibilityKind.card.obs;
  final RxInt _bottomBarIndex = 0.obs;

  CardVisibilityKind get cardVisibilityKind => _cardVisibilityKind.value;
  int get bottomBarIndex => _bottomBarIndex.value;
  bool get isAuthenticated => false;

  void set bottomBarIndex(int? index) {
    _bottomBarIndex(index ?? bottomBarIndex);
  }

  void changeCardVisibilityKind() {
    if (cardVisibilityKind == CardVisibilityKind.card) {
      _cardVisibilityKind(CardVisibilityKind.banner);
    } else {
      _cardVisibilityKind(CardVisibilityKind.card);
    }
  }
}
