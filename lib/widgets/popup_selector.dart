import 'package:flutter/material.dart';

class PopupSelector extends StatelessWidget {
  final Widget initialSelection;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function(int) onSelected;
  final Color? background;
  final EdgeInsetsGeometry selectionPadding;
  final EdgeInsetsGeometry itemPadding;

  const PopupSelector({
    super.key,
    required this.initialSelection,
    required this.itemCount,
    required this.itemBuilder,
    required this.onSelected,
    this.background,
    this.selectionPadding =
        const EdgeInsets.only(top: 11, bottom: 11, left: 22, right: 10),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextStyle? hintStyle = Theme.of(context).inputDecorationTheme?.hintStyle;
    return InkWell(
      borderRadius: BorderRadius.circular(29),
      onTap: () => _selectPopup(context),
      child: Container(
        padding: selectionPadding,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: background ??
              Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(29),
        ),
        child: initialSelection,
      ),
    );
  }

  void _selectPopup(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  margin: itemPadding,
                  width: size.width * 0.8,
                  child: itemBuilder(context, index),
                ),
                onTap: () {
                  onSelected(index);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }
}
