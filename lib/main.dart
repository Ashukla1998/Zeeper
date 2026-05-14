import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // INIT HIVE
    await Hive.initFlutter();

    // OPEN BOX
    await Hive.openBox('transactions');

    runApp(const MyApp());
  } catch (e) {
    debugPrint("APP ERROR: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),

      home: const MainScreen(),
    );
  }
}
