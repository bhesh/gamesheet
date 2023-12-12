import 'package:flutter/material.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/rounded_button.dart';

class SubmitCard extends StatelessWidget {
  final void Function()? onPressed;

  const SubmitCard({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      child: RoundedButton(
        text: 'Create Game',
        onPressed: onPressed,
      ),
    );
  }
}
