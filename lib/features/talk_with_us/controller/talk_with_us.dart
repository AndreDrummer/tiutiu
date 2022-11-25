import 'package:tiutiu/features/talk_with_us/model/talk_with_us.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TalkWithUsController extends GetxController {
  final Rx<TalkWithUs> _talkWithUs = TalkWithUs().obs;

  TalkWithUs get talkWithUs => _talkWithUs.value;

  void updateTalkWithUs(TalkWithUsEnum property, dynamic data) {
    final map = talkWithUs.toMap();
    map[property.name] = data;

    debugPrint('>> Updating talk with us data $map');

    _talkWithUs(TalkWithUs.fromMap(map));
  }
}
