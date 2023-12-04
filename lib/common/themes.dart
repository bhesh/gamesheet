import 'package:flutter/material.dart';
import './color.dart';

class ThemeChanger extends ChangeNotifier {
  Palette color;
  bool isDark;

  ThemeChanger(this.color, this.isDark);

  void updateTheme(Palette color, bool isDark) {
    this.color = color;
    this.isDark = isDark;
    notifyListeners();
  }

  ThemeData get data => buildTheme(color.background, isDark);
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
