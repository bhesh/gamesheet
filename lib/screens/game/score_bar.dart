import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/games/game_player.dart';
import 'package:gamesheet/widgets/avatar.dart';
import 'package:gamesheet/widgets/card.dart';

class ScoreBar extends StatelessWidget {
  final String name;
  final Palette color;
  final int value;
  final int maxValue;

  const ScoreBar({
    super.key,
    required this.name,
    required this.color,
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Builder(
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return Stack(
            children: <Widget>[
              Container(
                height: 40,
                width: maxValue == 0 ? 0 : size.width * (value / maxValue!),
                decoration: BoxDecoration(
                  color: addEmphasis(
                    Theme.of(context).brightness == Brightness.light,
                    color.background,
                    50,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${name}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Spacer(),
                    Text(
                      '${value}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
