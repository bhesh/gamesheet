import 'package:flutter/material.dart';
import 'package:gamesheet/provider/settings_provider.dart';
import 'package:gamesheet/themes/themes.dart';

enum ThemeSelection {
  lightBlue(1, 'Light Blue', Colors.lightBlue, false),
  lightPink(2, 'Light Pink', Color.fromARGB(255, 255, 171, 230), false),
  darkBlue(3, 'Dark Blue', Colors.lightBlue, true),
  darkPink(4, 'Hana', Color.fromARGB(255, 255, 171, 230), true);

  final int id;
  final String label;
  final Color seed;
  final bool isDark;

  const ThemeSelection(this.id, this.label, this.seed, this.isDark);

  factory ThemeSelection.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }
}

enum Setting {
  themeSelection(1);

  final int id;

  const Setting(this.id);

  factory Setting.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }
}

class SettingsMap {
  ThemeSelection? _themeSelection;

  SettingsMap({
    ThemeSelection? themeSelection,
  }) : this._themeSelection = themeSelection;

  ThemeSelection get themeSelection =>
      _themeSelection != null ? _themeSelection! : ThemeSelection.lightBlue;

  ThemeData get themeData => GamesheetTheme.fromSeed(
        themeSelection.seed,
        themeSelection.isDark,
      ).themeData;

  List<Map<String, dynamic>> toMap() {
    return [
      {
        'id': Setting.themeSelection.id,
        'value': themeSelection.id,
      },
    ];
  }
}
