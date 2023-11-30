import 'package:flutter/material.dart';

class GamesheetMessage extends StatelessWidget {
  final String message;

  const GamesheetMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
        ),
      ),
    );
  }
}
