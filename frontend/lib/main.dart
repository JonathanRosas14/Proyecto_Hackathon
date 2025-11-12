import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const EcoMonitorApp());
}

class EcoMonitorApp extends StatelessWidget {
  const EcoMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smartfloor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0d3d3d),
        colorScheme: ColorScheme.dark(
          background: const Color(0xFF0d3d3d),
          surface: const Color(0xFF1a5555),
          primary: const Color(0xFF4ecca3),
        ),
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}
