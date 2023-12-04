import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';

class GamesheetAvatar extends StatelessWidget {
  final String name;
  final Palette? color;

  const GamesheetAvatar({
    super.key,
    required this.name,
    this.color,
  });

  GamesheetAvatar.random({
    super.key,
    required this.name,
  }) : this.color = Palette.random;

  @override
  Widget build(BuildContext context) {
    var backgroundColor = color ?? Palette.random;
    var foregroundColor = backgroundColor.isDark ? Colors.white : Colors.black;
    return CircleAvatar(
      backgroundColor: backgroundColor.background,
      child: Text(
        name.substring(0, 1),
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: foregroundColor),
      ),
    );
  }
}
