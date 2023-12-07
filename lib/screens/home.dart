import 'package:flutter/material.dart';
import 'package:gamesheet/provider/game_list.dart';
import 'package:gamesheet/screens/creategame.dart';
import 'package:gamesheet/screens/game.dart';
import 'package:gamesheet/screens/settings.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import './home/home_menu.dart';
import './home/game_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext _context) {
    return ChangeNotifierProvider(
      create: (_) => GameListProvider(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gamesheet'),
            actions: <Widget>[
              HomeMenuList(
                onSelected: (item) {
                  switch (item) {
                    case HomeMenuItem.settings:
                      _navigate(context, (_) => const SettingsScreen());
                  }
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GameList(
              onSelected: (game) => _navigate(context, (_) => GameScreen(game)),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigate(
              context,
              (_) => const CreateGameScreen(),
            ),
            tooltip: 'New Game',
            child: const Icon(Symbols.add),
          ),
        );
      },
    );
  }

  void _navigate(BuildContext context, Widget Function(BuildContext) builder) {
    final provider = Provider.of<GameListProvider>(context, listen: false);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: builder))
        .then((changed) {
      if (changed != null && changed) provider.fetchGames();
    });
  }
}
