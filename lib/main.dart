import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

void main() async {
  /// make sure the flutter was initiated properly at first
  WidgetsFlutterBinding.ensureInitialized();
  /// lock the screen orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
    ]).then((_) => runApp(const MyApp())
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  build(context) {
    return MaterialApp(
      title: 'Walking With Thooly',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      darkTheme: ThemeData.dark(),
      home: const Home(),
    );
  }
}
