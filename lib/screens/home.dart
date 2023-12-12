import 'package:flutter/material.dart';
import 'package:gamesheet/models/game_list.dart';
import 'package:gamesheet/screens/newgame.dart';
import 'package:gamesheet/screens/game.dart';
import 'package:gamesheet/screens/settings.dart';
import 'package:gamesheet/widgets/home/game_list.dart';
import 'package:gamesheet/widgets/home/home_menu.dart';
import 'package:gamesheet/widgets/home/search_bar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;
  bool _search = false;
  String? _filter;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    _searchFocus.addListener(() {
      if (!_searchFocus.hasFocus && _searchController.text.trim().isEmpty) {
        setState(() {
          _filter = null;
          _search = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var options = HomeMenuList(
      onSelected: (item) {
        switch (item) {
          case HomeMenuItem.settings:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: _search
            ? GameListSearchBar(
                hintText: 'Search',
                onChanged: (value) {
                  String filter = value.trim();
                  setState(() => _filter = filter.isEmpty ? null : filter);
                },
                onCleared: () => setState(() {
                  _searchFocus.unfocus();
                  _filter = null;
                  _search = false;
                }),
                controller: _searchController,
                focusNode: _searchFocus,
                background:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
              )
            : const Text('Gamesheet'),
        actions: _search
            ? <Widget>[options]
            : <Widget>[
                IconButton(
                  icon: Icon(_search ? Symbols.close : Symbols.search),
                  onPressed: () => setState(() {
                    _searchController.text = '';
                    _search = true;
                    _searchFocus.requestFocus();
                  }),
                ),
                options
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GameList(
          onSelected: (game) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GameScreen(game),
            ),
          ),
          filter: _filter,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NewGameScreen(),
          ),
        ),
        tooltip: 'New Game',
        child: const Icon(Symbols.add),
      ),
    );
  }
}
