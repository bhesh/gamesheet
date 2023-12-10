import 'package:flutter/material.dart';

class ThemeDisplay extends StatelessWidget {
  final ThemeData themeData;
  final double? width;
  final double? height;
  final double outerRadius;
  final double margin;
  final double innerRadius;
  final String? label;

  const ThemeDisplay.small({
    super.key,
    required this.themeData,
  })  : this.width = 40,
        this.height = 40,
        this.outerRadius = 10,
        this.margin = 5,
        this.innerRadius = 15,
        this.label = null;

  const ThemeDisplay.large({
    super.key,
    required this.themeData,
    required this.label,
  })  : this.width = null,
        this.height = null,
        this.outerRadius = 15,
        this.margin = 10,
        this.innerRadius = 50;

  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: themeData.colorScheme.background,
        borderRadius: BorderRadius.circular(outerRadius),
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(margin),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: themeData.colorScheme.primary,
            borderRadius: BorderRadius.circular(innerRadius),
          ),
          child: label == null
              ? null
              : Text(
                  label!,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: themeData.colorScheme.onPrimary),
                ),
        ),
      ),
    );
  }
}
