import 'package:flutter/material.dart';

enum FiboIconType {
  square(_square),
  circle(_circle),
  cross(_cross);

  static const IconData _square = Icons.square;
  static const IconData _circle = Icons.circle;
  static const IconData _cross = Icons.close;

  final IconData icon;

  const FiboIconType(this.icon);

  static FiboIconType fromIndex(int index) {
    if (index % 3 == 0) {
      return FiboIconType.square;
    }

    if (index % 3 == 1) {
      return FiboIconType.circle;
    }

    return FiboIconType.cross;
  }
}
