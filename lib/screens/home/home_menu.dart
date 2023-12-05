import 'package:flutter/material.dart';
import 'package:gamesheet/provider/game.dart';
import 'package:gamesheet/screens/settings.dart';
import 'package:provider/provider.dart';

enum HomeMenuItem {
  settings('Settings');

  final String label;

  const HomeMenuItem(this.label);
}

class HomeMenuList extends StatelessWidget {
  const HomeMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    return PopupMenuButton<HomeMenuItem>(
      onSelected: (item) {
        switch (item) {
          case HomeMenuItem.settings:
            Navigator.of(context)
                .push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            )
                .then((changed) {
              if (changed != null && changed) provider.fetchGames();
            });
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
