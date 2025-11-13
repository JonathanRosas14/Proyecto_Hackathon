import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:io' show Platform;
import 'screens/home_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar URL del backend - usar Render en producción
  String backendUrl = 'https://proyecto-hackathon.onrender.com';

  // Descomentar para desarrollo local:
  // if (kIsWeb) {
  //   backendUrl = 'http://127.0.0.1:8000';
  // } else if (Platform.isAndroid) {
  //   backendUrl = 'http://localhost:8000'; // Para emulador con adb reverse
  //   // backendUrl = 'http://10.0.2.2:8000'; // Para emulador sin adb reverse
  // } else if (Platform.isIOS) {
  //   backendUrl = 'http://127.0.0.1:8000'; // Para simulador
  // } else {
  //   backendUrl = 'http://127.0.0.1:8000'; // Windows, macOS, Linux
  // }

  DatabaseService.setBaseUrl(backendUrl);
  print('🌐 Backend URL configurada: $backendUrl');

  // Intentar conectar al backend
  try {
    await DatabaseService().connect();
    print('✅ Conectado al backend exitosamente');
  } catch (e) {
    print('⚠️ No se pudo conectar al backend: $e');
    print('La app continuará, pero puede haber errores al cargar datos');
  }

  runApp(const SmartFloorApp());
}

class SmartFloorApp extends StatelessWidget {
  const SmartFloorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartFloor',
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
