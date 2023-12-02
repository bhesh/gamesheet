import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gamesheet/db/settings.dart';
import 'package:gamesheet/provider/database.dart' as db;
import 'package:gamesheet/provider/settings_provider.dart';
import 'package:gamesheet/screens/home.dart';
import 'package:gamesheet/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

const double windowWidth = 400;
const double windowHeight = 800;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  await db.Provider.initialize();
  SettingsMap settings = await SettingsProvider.getSettings();
  runApp(ThemeChangerWidget(
    initialTheme: settings.themeData,
  ));
}

void platformInit() {
  if (kIsWeb) throw UnimplementedError('web is not support');
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Gamesheet');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class ThemeChangerWidget extends StatelessWidget {
  final ThemeData initialTheme;

  const ThemeChangerWidget({
    super.key,
    required this.initialTheme,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(initialTheme)),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: 'Gamesheet',
      theme: theme.themeData,
      home: const HomeScreen(),
    );
  }
}
