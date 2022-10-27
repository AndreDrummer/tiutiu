import 'package:flutter/material.dart';

class LoadingImageAnimation extends StatefulWidget {
  const LoadingImageAnimation({
    required this.imagePath,
    super.key,
  });

  final String imagePath;

  @override
  State<LoadingImageAnimation> createState() => _LoadingImageAnimationState();
}

class _LoadingImageAnimationState extends State<LoadingImageAnimation>
    with SingleTickerProviderStateMixin {
  static final valueAnimation = Tween<double>(begin: 0.1, end: 1);
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat();

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return Opacity(
          opacity: valueAnimation.evaluate(animation),
          child: Image.asset(
            fit: BoxFit.cover,
            widget.imagePath,
          ),
        );
      },
    );
  }
}
