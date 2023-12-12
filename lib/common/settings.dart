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

  factory SettingsMap.fromRows(List<Map<String, dynamic>> rows) {
    Palette? themeColor = null;
    bool? themeIsDark = null;
    rows.forEach((row) {
      var setting = Setting.fromId(row['id']);
      switch (setting) {
        case Setting.themeColor:
          themeColor = Palette.fromId(row['value']);
        case Setting.themeIsDark:
          themeIsDark = row['value'] != 0;
      }
    });
    return SettingsMap(
      themeColor: themeColor,
      themeIsDark: themeIsDark,
    );
  }

  SettingsMap copyWith({
    Palette? themeColor,
    bool? themeIsDark,
  }) {
    return SettingsMap(
      themeColor: themeColor ?? this.themeColor,
      themeIsDark: themeIsDark ?? this.themeIsDark,
    );
  }

  List<Map<String, dynamic>> toRows() {
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
