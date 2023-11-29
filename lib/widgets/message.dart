import 'package:flutter/material.dart';

class ScoreboardMessage extends StatelessWidget {
  final String message;

  const ScoreboardMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(message),
      ),
    );
  }
}
