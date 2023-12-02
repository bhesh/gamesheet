import 'package:flutter/material.dart';

class GamesheetCard extends StatelessWidget {
  final String? title;
  final Widget? child;
  final EdgeInsetsGeometry margin;
  final CrossAxisAlignment crossAxisAlignment;
  final Color? color;
  final double elevation;

  const GamesheetCard({
    super.key,
    this.title,
    this.child,
    this.margin = const EdgeInsets.only(bottom: 8, left: 8, right: 8),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.color,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.empty(growable: true);
    if (title != null) {
      children.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
      );
    }
    children.add(
      Padding(
        padding: EdgeInsets.all(16),
        child: child,
      ),
    );
    return Card(
      margin: margin,
      color: color,
      elevation: elevation,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
