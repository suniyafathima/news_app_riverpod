import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/presentation/bottomnavbar/bottomnavbar.dart';
import 'package:news_app/presentation/welcome_screen/welcome_screen.dart';
import 'package:news_app/sqflite_class/news_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NewsDb.initDb(); 
  runApp(ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:WelcomeScreen(),
    );
  }
}
