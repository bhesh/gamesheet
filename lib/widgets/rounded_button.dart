import 'package:flutter/material.dart';
import 'package:gamesheet/widgets/card.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const RoundedButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(29),
      onTap: onPressed,
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
            text,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
