import 'package:flutter/material.dart';
import 'package:gamesheet/common/game.dart';
import 'package:gamesheet/common/score.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/number_input.dart';

class CustomCard extends StatelessWidget {
  final TextEditingController? roundController;
  final bool hasDealer;
  final void Function(bool)? onDealerChange;
  final Scoring selectedScoring;
  final void Function(Scoring)? onScoringChange;
  final String? roundErrorText;

  const CustomCard({
    super.key,
    required this.roundController,
    this.hasDealer = false,
    this.onDealerChange,
    this.selectedScoring = Scoring.lowest,
    this.onScoringChange,
    this.roundErrorText,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      title: 'Custom',
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                roundErrorText ?? 'Number of rounds',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: roundErrorText == null
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.error),
              ),
              Spacer(),
              NumberInput(
                width: 80,
                labelText: 'Rounds',
                controller: roundController,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: <Widget>[
                Text(
                  'Dealer',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Spacer(),
                Switch(
                  value: hasDealer,
                  onChanged: onDealerChange,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _ScoringPopup(
              selected: selectedScoring,
              onSelected: onScoringChange,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoringPopup extends StatelessWidget {
  final Scoring selected;
  final void Function(Scoring)? onSelected;

  const _ScoringPopup({
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _ScoringPopupItem(
      item: selected,
      onSelected: () => _popup(context),
    );
  }

  void _popup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: Scoring.values.length,
            itemBuilder: (context, index) {
              return _ScoringPopupItem(
                item: Scoring.values[index],
                onSelected: () {
                  if (onSelected != null) onSelected!(Scoring.values[index]);
                  Navigator.of(context).pop();
                },
              );
            },
            separatorBuilder: (context, index) =>
                Padding(padding: const EdgeInsets.all(4)),
          ),
        );
      },
    );
  }
}

class _ScoringPopupItem extends StatelessWidget {
  final Scoring item;
  final void Function()? onSelected;

  const _ScoringPopupItem({
    super.key,
    required this.item,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(29),
      onTap: onSelected,
      child: Container(
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
            item.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.75)),
          ),
        ),
      ),
    );
  }
}
