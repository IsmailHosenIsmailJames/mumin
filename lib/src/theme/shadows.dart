import 'package:flutter/material.dart';

class MyAppShadows {
  static BoxShadow commonShadowLight = BoxShadow(
    blurRadius: 3,
    spreadRadius: 2,
    color: Colors.grey.shade300,
    offset: const Offset(-2, 2),
  );
  static BoxShadow commonShadowDark = BoxShadow(
    blurRadius: 3,
    spreadRadius: 2,
    color: Colors.grey.shade900,
    offset: const Offset(-2, 2),
  );
}
