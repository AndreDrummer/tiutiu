import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Blur extends StatelessWidget {
  const Blur({this.darker = false});

  final bool darker;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darker ? Colors.black.withOpacity(.8) : Colors.black45,
      height: Get.height,
    );
  }
}
