import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/widgets/card.dart';

class SubmitCard extends StatelessWidget {
  final void Function()? onTap;

  const SubmitCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(29),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 11,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(29),
          ),
          child: Center(
            child: Text(
              'Create Game',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
