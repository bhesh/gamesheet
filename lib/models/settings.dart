import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/settings.dart';
import 'package:gamesheet/db/app.dart';
import 'package:gamesheet/db/settings.dart';

class SettingsModel extends ChangeNotifier {
  SettingsMap settings;

  SettingsModel(this.settings);

  Palette get themeColor => settings.themeColor;

  bool get themeIsDark => settings.themeIsDark;

  ThemeData get themeData => buildTheme(
        settings.themeColor.background,
        settings.themeIsDark,
      );

  Future<void> updateTheme(Palette color, bool isDark) async {
    this.settings = settings.copyWith(
      themeColor: color,
      themeIsDark: isDark,
    );
    notifyListeners();
    await SettingsDatabase.updateAllSettings(this.settings);
  }

  Future<void> resetSettings() async {
    var settings = await AppDatabase.settingsDatabase;
    await AppDatabase.createSettingsDatabase(settings);
    this.settings = await SettingsDatabase.getSettings();
    notifyListeners();
  }
}

ThemeData buildTheme(Color seed, bool dark) {
  var scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: dark ? Brightness.dark : Brightness.light,
  );
  var theme = ThemeData.from(
    useMaterial3: true,
    colorScheme: scheme,
  );
  return theme.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 0.0,
    ),
    scaffoldBackgroundColor: addEmphasis(dark, scheme.background, 10),
  );
}
