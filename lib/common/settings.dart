import 'package:flutter/material.dart';
import './color.dart';

enum Setting {
  themeColor(1),
  themeIsDark(2);

  final int id;

  const Setting(this.id);

  factory Setting.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }
}

class SettingsMap {
  final Palette themeColor;
  final bool themeIsDark;

  const SettingsMap({
    Palette? themeColor,
    bool? themeIsDark,
  })  : this.themeColor = themeColor ?? Palette.lightBlue,
        this.themeIsDark = themeIsDark ?? false;

  List<Map<String, dynamic>> toMap() {
    return [
      {
        'id': Setting.themeColor.id,
        'value': themeColor.id,
      },
      {
        'id': Setting.themeIsDark.id,
        'value': themeIsDark ? 1 : 0,
      },
    ];
  }
}
