import 'package:flutter/material.dart';

class ScoreboardCard extends StatelessWidget {
  final String? title;
  final Widget? child;

  const ScoreboardCard({
    super.key,
    this.title,
    this.child,
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
        margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
