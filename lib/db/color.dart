import 'dart:math';
import 'package:flutter/material.dart';

enum GameColor {
  amber(1, Colors.amber, Colors.white),
  blue(2, Colors.blue, Colors.white),
  blueGrey(3, Colors.blueGrey, Colors.white),
  brown(4, Colors.brown, Colors.white),
  cyan(5, Colors.cyan, Colors.white),
  deepOrange(6, Colors.deepOrange, Colors.white),
  deepPurple(7, Colors.deepPurple, Colors.white),
  green(8, Colors.green, Colors.white),
  grey(9, Colors.grey, Colors.white),
  indigo(10, Colors.indigo, Colors.white),
  lightBlue(11, Colors.lightBlue, Colors.white),
  lightGreen(12, Colors.lightGreen, Colors.white),
  lightPink(13, Color.fromARGB(255, 255, 171, 230), Colors.white),
  lime(14, Colors.lime, Colors.black),
  orange(15, Colors.orange, Colors.black),
  pink(16, Colors.pink, Colors.white),
  purple(17, Colors.purple, Colors.white),
  red(18, Colors.red, Colors.white),
  teal(19, Colors.teal, Colors.white),
  yellow(20, Colors.yellow, Colors.black);

  static final int numColors = 20;

  final int id;
  final Color background;
  final Color foreground;

  const GameColor(this.id, this.background, this.foreground);

  static GameColor get random => GameColor.values[Random().nextInt(numColors)];

  factory GameColor.fromId(int id) {
    return values.firstWhere((e) => e.id == id);
  }
}
