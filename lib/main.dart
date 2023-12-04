import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import './common/settings.dart';
import './db/database.dart';
import './db/settings_provider.dart';
import './screens/home.dart';
import './common/themes.dart';

const double windowWidth = 400;
const double windowHeight = 800;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  await DatabaseProvider.initialize();
  SettingsMap settings = await SettingsProvider.getSettings();
  runApp(ThemeChangerWidget(
    settings: settings,
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
  final SettingsMap settings;

  const ThemeChangerWidget({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChanger(
        settings.themeColor,
        settings.themeIsDark,
      ),
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
      theme: theme.data,
      home: const HomeScreen(),
    );
  }
}
