import 'dart:io' show Platform, exit;
import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import './common/settings.dart';
import './db/app.dart';
import './db/settings.dart';
import './screens/home.dart';
import './common/themes.dart';

const double windowWidth = 400;
const double windowHeight = 800;

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    platformInit();
    await AppDatabase.initialize();
    SettingsMap settings = await SettingsDatabase.getSettings();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kReleaseMode) exit(1);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      print(error.toString());
      if (kReleaseMode) exit(1);
      return true;
    };
    runApp(ThemeChangerWidget(
      initialSettings: settings,
    ));
  } catch (error, stack) {
    print(error.toString());
    if (kDebugMode) print(stack.toString());
    exit(1);
  }
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
  final SettingsMap initialSettings;

  const ThemeChangerWidget({
    super.key,
    required this.initialSettings,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChanger(
        initialSettings.themeColor,
        initialSettings.themeIsDark,
      ),
      child: const MyApp(),
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
