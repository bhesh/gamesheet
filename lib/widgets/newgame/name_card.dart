import 'package:flutter/material.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/rounded_text_field.dart';
import 'package:material_symbols_icons/symbols.dart';

class NameCard extends StatelessWidget {
  final TextEditingController? controller;
  final String? errorText;

  const NameCard({
    super.key,
    this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return GamesheetCard(
      child: RoundedTextField(
        controller: controller,
        icon: const Icon(Symbols.videogame_asset),
        hintText: 'Game Name',
        errorText: errorText,
      ),
    );
  }
}
