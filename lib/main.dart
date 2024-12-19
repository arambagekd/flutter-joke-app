import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18, color: Colors.black87),
          bodyText2: TextStyle(fontSize: 14, color: Colors.green[700]),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
