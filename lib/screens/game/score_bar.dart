import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/widgets/card.dart';

class ScoreBar extends StatelessWidget {
  final String name;
  final Palette color;
  final num value;
  final num minValue;
  final num maxValue;

  const ScoreBar({
    super.key,
    required this.name,
    required this.color,
    required this.value,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Builder(
        builder: (context) {
          // Calculate the padding and size
          Size size = MediaQuery.of(context).size;
          num calcMinValue = minValue > 0 ? 0 : minValue;
          num calcMaxValue = maxValue < 0 ? 0 : maxValue;
          num range = calcMinValue.abs() + calcMaxValue;
          num padding = range == 0
              ? 0 // don't divide by 0
              : value < 0
                  ? (size.width * (calcMinValue.abs() + value)) / range
                  : (size.width * calcMinValue.abs()) / range;
          Widget bar = Padding(
            padding: EdgeInsets.only(left: padding.toDouble()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 40,
              width: range == 0 ? 0 : (size.width * value.abs()) / range,
              decoration: BoxDecoration(
                color: addEmphasis(
                  Theme.of(context).brightness == Brightness.light,
                  color.background,
                  50,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );

          // Return stack
          return Stack(
            children: <Widget>[
              bar,
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
                      value.runtimeType == double
                          ? value.toStringAsFixed(2)
                          : '$value',
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
