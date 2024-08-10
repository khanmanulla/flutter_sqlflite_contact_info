import 'dart:math';

import 'package:flutter/material.dart';

class ColorPalate {
  static Color white = const Color(0xFFffffff);
  static Color green = const Color(0xFF4CAF50);
  static Color red = const Color(0xFFF44336);
  static Color blackPearl = const Color(0xFF030712);
  static Color lightBlack = const Color(0xFF000000);

  static Color lightGrey = const Color(0xFFe5e5e5);
  static Color grey = const Color(0xFF9E9E9E);
  static Color blue = const Color(0xFF2196F3);

  static Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
