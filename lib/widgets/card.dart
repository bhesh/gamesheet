import 'package:flutter/material.dart';

class GamesheetCard extends StatelessWidget {
  final String? title;
  final Widget? child;
  final EdgeInsetsGeometry margin;
  final CrossAxisAlignment crossAxisAlignment;
  final Color? color;

  const GamesheetCard({
    super.key,
    this.title,
    this.child,
    this.margin = const EdgeInsets.only(bottom: 8, left: 8, right: 8),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.color,
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
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      );
    }
    children.add(
      Card(
        margin: margin,
        color: color,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
