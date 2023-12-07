import 'package:flutter/material.dart';

enum HomeMenuItem {
  settings('Settings');

  final String label;

  const HomeMenuItem(this.label);
}

class HomeMenuList extends StatelessWidget {
  final void Function(HomeMenuItem)? onSelected;

  const HomeMenuList({
    super.key,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HomeMenuItem>(
      onSelected: (item) => onSelected == null ? {} : onSelected!(item),
      itemBuilder: (_) => HomeMenuItem.values.map((item) {
        return PopupMenuItem<HomeMenuItem>(
          value: item,
          child: Text(item.label),
        );
      }).toList(),
    );
  }
}
