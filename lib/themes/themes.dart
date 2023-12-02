import 'package:flutter/material.dart';

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}

Color soften(ColorScheme scheme, Color color, [int percent = 10]) {
  return scheme.brightness == Brightness.light
      ? darken(color, percent)
      : lighten(color, percent);
}

class GamesheetTheme {
  final ThemeData themeData;

  const GamesheetTheme(this.themeData);

  GamesheetTheme.fromSeed(Color seed, [bool dark = false])
      : this.themeData = _initThemeData(_initColorScheme(seed, dark));
}

ColorScheme _initColorScheme(Color seed, bool dark) {
  var scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: dark ? Brightness.dark : Brightness.light,
  );

  // Change scheme here starting with a base
  return scheme.copyWith();
}

ThemeData _initThemeData(ColorScheme scheme) {
  var theme = ThemeData.from(
    useMaterial3: true,
    colorScheme: scheme,
  );

  // Change theme here starting with a base
  return theme.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 0.0,
    ),
    scaffoldBackgroundColor: soften(scheme, scheme.background),
  );
}

class ThemeChanger extends ChangeNotifier {
  ThemeData themeData;

  ThemeChanger(this.themeData);

  void setTheme(ThemeData theme) {
    themeData = theme;
    notifyListeners();
  }
}
