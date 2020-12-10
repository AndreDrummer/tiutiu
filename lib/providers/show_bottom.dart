import 'package:flutter/material.dart';

class ShowBottomNavigator extends ChangeNotifier {
  bool showBottom = true;

  void Function(bool) get changeShowBottom => _changeShowBottom;

  void _changeShowBottom(bool showBottomValue) {
    showBottom = showBottomValue;
    notifyListeners();
  }
}
