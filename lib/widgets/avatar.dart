import 'dart:math';
import 'package:flutter/material.dart';

enum AvatarColors {
  amber(Colors.amber, Colors.white),
  blue(Colors.blue, Colors.white),
  blueGrey(Colors.blueGrey, Colors.white),
  brown(Colors.brown, Colors.white),
  cyan(Colors.cyan, Colors.white),
  deepOrange(Colors.deepOrange, Colors.white),
  deepPurple(Colors.deepPurple, Colors.white),
  green(Colors.green, Colors.white),
  grey(Colors.grey, Colors.white),
  indigo(Colors.indigo, Colors.white),
  lightBlue(Colors.lightBlue, Colors.white),
  lightGreen(Colors.lightGreen, Colors.white),
  lime(Colors.lime, Colors.black),
  orange(Colors.orange, Colors.black),
  pink(Colors.pink, Colors.white),
  purple(Colors.purple, Colors.white),
  teal(Colors.teal, Colors.white),
  yellow(Colors.yellow, Colors.black);

  static final int numColors = 18;

  final Color background;
  final Color foreground;

  const AvatarColors(this.background, this.foreground);

  static AvatarColors get random => AvatarColors.values[Random().nextInt(18)];
}

class GamesheetAvatar extends StatelessWidget {
  final String name;
  final AvatarColors? color;
  final bool inverse;

  const GamesheetAvatar({
    super.key,
    required this.name,
    this.color,
    this.inverse = false,
  });

  GamesheetAvatar.random({
    super.key,
    required this.name,
    this.inverse = false,
  }) : this.color = AvatarColors.random;

  @override
  Widget build(BuildContext context) {
    var backgroundColor = color == null
        ? null
        : inverse
            ? color!.foreground
            : color!.background;
    var foregroundColor = color == null
        ? null
        : inverse
            ? color!.background
            : color!.foreground;
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Text(
        name.substring(0, 1),
        style: foregroundColor == null
            ? Theme.of(context).textTheme.headlineMedium
            : Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: foregroundColor),
      ),
    );
  }
}
