import 'package:flutter/material.dart';

class ValidatedArea extends StatelessWidget {
  const ValidatedArea({
    required this.fallbackChild,
    required this.validChild,
    required this.isValid,
    super.key,
  });

  final Widget fallbackChild;
  final Widget validChild;
  final bool isValid;

  @override
  Widget build(BuildContext context) => isValid ? validChild : fallbackChild;
}
