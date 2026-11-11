import 'package:flutter/material.dart';

import 'screens/preloved_home_page.dart';

void main() {
  runApp(const PrelovedApp());
}

class PrelovedApp extends StatefulWidget {
  const PrelovedApp({super.key});

  @override
  State<PrelovedApp> createState() => _PrelovedAppState();
}

class _PrelovedAppState extends State<PrelovedApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF32734A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preloved',
      themeMode: _themeMode,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8F2),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: PrelovedHomePage(
        themeMode: _themeMode,
        onThemeModeChanged: _changeTheme,
      ),
    );
  }
}
