import 'package:flutter/material.dart';

class AppColors {
  static final Map<int, Color> _primaryColorCodes = {
    50: const Color.fromARGB(255, 76, 175, 80),
    100: const Color.fromARGB(255, 76, 175, 80),
    200: const Color.fromARGB(255, 76, 175, 80),
    300: const Color.fromARGB(255, 76, 175, 80),
    400: const Color.fromARGB(255, 76, 175, 80),
    500: const Color.fromARGB(255, 76, 175, 80),
    600: const Color.fromARGB(255, 76, 175, 80),
    700: const Color.fromARGB(255, 76, 175, 80),
    800: const Color.fromARGB(255, 76, 175, 80),
    900: const Color.fromARGB(255, 76, 175, 80),
  };

  static MaterialColor primary = MaterialColor(0XFF4CAF50, _primaryColorCodes);
  static MaterialColor white = MaterialColor(0XFFFFFFFF, _primaryColorCodes);
  static MaterialColor whiteIce = MaterialColor(0XFFE2E2E2, _primaryColorCodes);
  static MaterialColor pink = MaterialColor(0XFFD7326A, _primaryColorCodes);
  static MaterialColor black = MaterialColor(0XFF000000, _primaryColorCodes);
  static MaterialColor success = MaterialColor(0XFF4CAF50, _primaryColorCodes);
  static MaterialColor warning = MaterialColor(0XFFFFD740, _primaryColorCodes);
  static MaterialColor danger = MaterialColor(0XFFF44336, _primaryColorCodes);
  static MaterialColor info = MaterialColor(0XFF536DFE, _primaryColorCodes);
  static MaterialColor secondary = MaterialColor(
    0XFF9C27B0,
    _primaryColorCodes,
  );
}
