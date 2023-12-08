import 'package:flutter/material.dart';
import 'package:gamesheet/provider/game_list.dart';
import 'package:gamesheet/screens/creategame.dart';
import 'package:gamesheet/screens/game.dart';
import 'package:gamesheet/screens/settings.dart';
import 'package:gamesheet/widgets/search_bar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import './home/home_menu.dart';
import './home/game_list.dart';

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
      if (!_searchFocus.hasFocus && _searchController.text.trim().isEmpty)
        setState(() {
          _filter = null;
          _search = false;
        });
    });
  }

  @override
  Widget build(BuildContext _context) {
    return ChangeNotifierProvider(
      create: (_) => GameListProvider(),
      builder: (context, _) {
        var options = HomeMenuList(
          onSelected: (item) {
            switch (item) {
              case HomeMenuItem.settings:
                _navigate(context, (_) => const SettingsScreen());
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
                    background: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.1),
                  )
                : Text('Gamesheet'),
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
              onSelected: (game) => _navigate(context, (_) => GameScreen(game)),
              filter: _filter,
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
      setState(() {
        _search = false;
        _filter = null;
      });
    });
  }
}
