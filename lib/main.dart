import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gamesheet/provider/database.dart';
import 'package:gamesheet/screens/home.dart';
import 'package:window_size/window_size.dart';

const double windowWidth = 400;
const double windowHeight = 800;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  await AppDatabase.initialize();
  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamesheet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          surface: Colors.white,
          surfaceTint: Colors.white,
          onSurface: Colors.black,
          background: Colors.blueGrey[50],
          onBackground: Colors.blueGrey[800],
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
