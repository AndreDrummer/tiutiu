import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum BottomBarIndex {
  DONATE(indx: 0),
  TIUTIUTOK(indx: 1),
  POST(indx: 2),
  FINDER(indx: 3),
  MORE(indx: 4);

  const BottomBarIndex({
    required this.indx,
  });

  final int indx;
}

class HomeController extends GetxController {
  final ScrollController _scrollController = ScrollController();
  final RxBool _isAppBarCollapsed = false.obs;
  final RxInt _bottomBarIndex = 0.obs;

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

  void onScrollUp() {
    _scrollController.animateTo(
      duration: new Duration(milliseconds: 1500),
      curve: Curves.ease,
      0,
    );
  }

  void setIndex(int index) {
    _setbottomBarIndex(BottomBarIndex.values.where((bottomBarIndex) => bottomBarIndex.indx == index).first);
  }

  void setDonateIndex() {
    _setbottomBarIndex(BottomBarIndex.DONATE);
  }

  void setTiutiuTokIndex() {
    _setbottomBarIndex(BottomBarIndex.TIUTIUTOK);
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
