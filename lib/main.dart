// main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INIT HIVE
  await Hive.initFlutter();

  // OPEN BOX
  await Hive.openBox('transactions');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
