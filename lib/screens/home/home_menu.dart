import 'package:flutter/material.dart';
import 'package:gamesheet/screens/settings.dart';

enum HomeMenuItem {
  settings('Settings');

  final String label;

  const HomeMenuItem(this.label);
}

class HomeMenuList extends StatelessWidget {
  final void Function(Widget) onSelected;

  const HomeMenuList({
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HomeMenuItem>(
      onSelected: (item) {
        switch (item) {
          case HomeMenuItem.settings:
            onSelected(const SettingsScreen());
        }
      },
      itemBuilder: (_) => HomeMenuItem.values.map((item) {
        return PopupMenuItem<HomeMenuItem>(
          value: item,
          child: Text(item.label),
        );
      }).toList(),
    );
  }
}
