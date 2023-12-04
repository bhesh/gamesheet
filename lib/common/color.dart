import 'dart:math';
import 'package:flutter/material.dart';

enum Palette {
  amber(1, Colors.amber, true, 'Amber'),
  blue(2, Colors.blue, true, 'Blue'),
  blueGrey(3, Colors.blueGrey, true, 'BlueGrey'),
  brown(4, Colors.brown, true, 'Brown'),
  cyan(5, Colors.cyan, true, 'Cyan'),
  deepOrange(6, Colors.deepOrange, true, 'DeepOrange'),
  deepPurple(7, Colors.deepPurple, true, 'DeepPurple'),
  green(8, Colors.green, true, 'Green'),
  grey(9, Colors.grey, true, 'Grey'),
  indigo(10, Colors.indigo, true, 'Indigo'),
  lightBlue(11, Colors.lightBlue, true, 'LightBlue'),
  lightGreen(12, Colors.lightGreen, true, 'LightGreen'),
  lightPink(13, Color.fromARGB(255, 255, 171, 230), true, 'Pink'),
  lime(14, Colors.lime, false, 'Lime'),
  orange(15, Colors.orange, false, 'Orange'),
  pink(16, Colors.pink, true, 'HotPink'),
  purple(17, Colors.purple, true, 'Purple'),
  red(18, Colors.red, true, 'Red'),
  teal(19, Colors.teal, true, 'Teal'),
  yellow(20, Colors.yellow, false, 'Yellow');

  final int id;
  final Color background;
  final bool isDark;
  final String label;

  const Palette(
    this.id,
    this.background,
    this.isDark,
    this.label,
  );

  static Palette get random =>
      Palette.values[Random().nextInt(Palette.values.length)];

  factory Palette.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }
}

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

Color addEmphasis(bool isDark, Color color, [int percent = 10]) {
  return isDark ? lighten(color, percent) : darken(color, percent);
}
