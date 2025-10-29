import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user_progress.dart';
import 'landing.dart'; // keep your existing landing import (eg SplashScreen)

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProgress(),
      child: const WovellApp(),
    ),
  );
}

class WovellApp extends StatelessWidget {
  const WovellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wovell',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(), // ensure SplashScreen is defined in landing.dart
    );
  }
}
