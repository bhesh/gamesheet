import 'package:flutter/material.dart';
import 'package:gamesheet/db/color.dart';

class GamesheetAvatar extends StatelessWidget {
  final String name;
  final GameColor? color;
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
  }) : this.color = GameColor.random;

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
