import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SeruputApp());
}

class SeruputApp extends StatelessWidget {
  const SeruputApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seruput',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFAF6),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}