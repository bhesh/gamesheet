import 'package:flutter/material.dart';

class ScoreboardCard extends StatelessWidget {
  final String? title;
  final Widget? child;
  final EdgeInsetsGeometry margin;
  final CrossAxisAlignment crossAxisAlignment;

  const ScoreboardCard({
    super.key,
    this.title,
    this.child,
    this.margin = const EdgeInsets.only(top: 8, left: 8, right: 8),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List.empty(growable: true);
    if (title != null) {
      children.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
        ),
      );
    }
    children.add(
      Card(
        margin: margin,
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
