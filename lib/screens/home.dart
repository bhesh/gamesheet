import 'package:flutter/material.dart';
import 'package:gamesheet/provider/game.dart';
import 'package:gamesheet/screens/creategame.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import './home/home_menu.dart';
import './home/game_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      builder: (context, _) {
        final provider = Provider.of<GameProvider>(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gamesheet'),
            actions: <Widget>[HomeMenuList()],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GameList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .push(
              MaterialPageRoute(builder: (context) => const CreateGameScreen()),
            )
                .then((changed) {
              if (changed != null && changed) provider.fetchGames();
            }),
            tooltip: 'New Game',
            child: const Icon(Symbols.add),
          ),
        );
      },
    );
  }
}
