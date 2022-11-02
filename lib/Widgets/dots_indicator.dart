import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tiutiu/core/constants/app_colors.dart';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.color,
    this.onPageSelected,
    this.controller,
    this.itemCount,
  }) : super(listenable: controller!);

  final ValueChanged<int>? onPageSelected;
  final PageController? controller;
  final int? itemCount;
  final Color? color;

  static const double _dotSpacing = 16.0;
  static const double _dotSize = 5.0;
  static const double _maxZoom = 2.0;

  Widget _buildDot(int index) {
    double selected = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller!.page ?? controller!.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_maxZoom - 1.0) * selected;
    return Container(
      width: _dotSpacing,
      child: Center(
        child: Material(
          color: color ?? AppColors.white,
          type: MaterialType.circle,
          child: Container(
            width: _dotSize * zoom,
            height: _dotSize * zoom,
            child: InkWell(
              onTap: () => onPageSelected?.call(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount!, _buildDot),
    );
  }
}
