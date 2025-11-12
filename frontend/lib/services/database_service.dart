import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/alert_model.dart';

/// Servicio de base de datos que conecta al backend REST API real
/// Envía datos de sensores a PostgreSQL via FastAPI
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // URL del backend (cambiar según ambiente)
  // LOCAL: http://localhost:8000
  // PRODUCCIÓN: https://tu-servidor.com
  static String _baseUrl = 'http://localhost:8000';

  /// Establecer la URL base del backend (útil para diferentes plataformas)
  static void setBaseUrl(String url) {
    _baseUrl = url;
    print('🔧 URL del backend actualizada: $url');
  }

  /// Obtener la URL base del backend
  static String getBaseUrl() {
    return _baseUrl;
  }

  // Timeout para requests (aumentado para dispositivos móviles)
  static const Duration _timeout = Duration(seconds: 30);

  /// Conectar al backend
  Future<void> connect() async {
    try {
      print('🔄 Intentando conectar a: $_baseUrl/health');
      print('⏱️ Timeout: $_timeout');

      final response = await http
          .get(
        Uri.parse('$_baseUrl/health'),
      )
          .timeout(
        _timeout,
        onTimeout: () {
          print('⏰ Timeout al conectar después de $_timeout');
          print('💡 Sugerencias:');
          print('   • Verifica que el backend esté corriendo');
          print('   • Verifica la URL: $_baseUrl');
          print('   • Si es dispositivo físico, usa la IP de tu PC');
          print('   • Si es emulador Android, usa 10.0.2.2:8000');
          throw Exception('Timeout de conexión');
        },
      );

      if (response.statusCode == 200) {
        print('✅ Conectado exitosamente al backend: $_baseUrl');
        final body = jsonDecode(response.body);
        print('📊 Backend status: ${body['status']}');
      } else {
        print('⚠️ Backend respondió con status: ${response.statusCode}');
        print('📄 Body: ${response.body}');
      }
    } catch (e) {
      print('❌ Error conectando al backend: $e');
      print('🔍 URL intentada: $_baseUrl');
      rethrow;
    }
  }

  /// Desconectar
  Future<void> disconnect() async {
    print('👋 Desconectando del backend');
  }

  /// Enviar una lectura de sensor a la base de datos
  /// Parámetros:
  /// - edificio: código del edificio (ej: "A")
  /// - piso: número de piso (1-3)
  /// - temp_c: temperatura en Celsius
  /// - humedad_pct: humedad en porcentaje (0-100)
  /// - energia_kw: consumo de energía en kW
  Future<Map<String, dynamic>> createSensorReading({
    required String edificio,
    required int piso,
    required double tempC,
    required double humedadPct,
    required double energiaKw,
  }) async {
    try {
      // Validar entrada
      if (piso < 1 || piso > 10) {
        throw ArgumentError('Piso debe estar entre 1 y 10');
      }
      if (humedadPct < 0 || humedadPct > 100) {
        throw ArgumentError('Humedad debe estar entre 0 y 100%');
      }
      if (energiaKw < 0) {
        throw ArgumentError('Energía no puede ser negativa');
      }

      // Crear payload según SensorDataCreate del backend
      final payload = {
        'edificio': edificio,
        'piso': piso,
        'temp_c': tempC,
        'humedad_pct': humedadPct,
        'energia_kw': energiaKw,
      };

      print('📤 Enviando lectura: $payload');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/sensor-data/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Lectura guardada: ID ${data['id']}');
        return data;
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
        throw Exception('Error al guardar lectura: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error enviando lectura: $e');
      rethrow;
    }
  }

  /// Obtener alertas activas del backend
  Future<List<AlertModel>> getAlerts({
    String? pisoFilter,
    String? tipoFilter,
    String? severidadFilter,
    String edificio = 'A',
  }) async {
    try {
      // Construir URL con parámetros
      String url = '$_baseUrl/alerts/?edificio=$edificio&solo_activas=true';

      if (pisoFilter != null &&
          pisoFilter.isNotEmpty &&
          pisoFilter != 'Todos') {
        // Convertir "Piso 1" -> 1
        final pisoNum = _extractPisoNumber(pisoFilter);
        if (pisoNum != null) {
          url += '&piso=$pisoNum';
        }
      }

      print('📥 Obteniendo alertas desde: $url');
      print('⏱️ Timeout configurado: $_timeout');

      final response = await http
          .get(
        Uri.parse(url),
      )
          .timeout(
        _timeout,
        onTimeout: () {
          print('⏰ Timeout alcanzado después de $_timeout');
          print('💡 Verifica que:');
          print('   1. El backend esté corriendo en $_baseUrl');
          print('   2. Tu dispositivo esté en la misma red WiFi');
          print('   3. El firewall permita conexiones al puerto 8000');
          throw Exception('Timeout: No se pudo conectar al backend');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final alerts = data.map((alert) {
          return AlertModel(
            timestamp: DateTime.parse(alert['timestamp']),
            piso: 'Piso ${alert['piso']}',
            tipo: alert['tipo'],
            severidad: _mapSeveridad(alert['severidad']),
            recomendacion: alert['recomendacion'] ?? 'Sin recomendación',
          );
        }).toList();

        // Ordenar por timestamp descendente
        alerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        print('✅ Obtenidas ${alerts.length} alertas');
        return alerts;
      } else {
        print('❌ Error HTTP ${response.statusCode}: ${response.body}');
        return [];
      }
    } on Exception catch (e) {
      print('❌ Error obteniendo alertas: $e');
      print('🔍 Backend URL: $_baseUrl');
      return [];
    } catch (e) {
      print('❌ Error inesperado: $e');
      print('🔍 Tipo: ${e.runtimeType}');
      return [];
    }
  }

  /// Obtener pisos disponibles
  Future<List<String>> getUniquePisos({String edificio = 'A'}) async {
    try {
      // Obtener alertas y extraer pisos únicos
      final alerts = await getAlerts(edificio: edificio);
      final pisos = alerts.map((a) => a.piso).toSet().toList();
      pisos.sort();
      return pisos;
    } catch (e) {
      print('❌ Error obteniendo pisos: $e');
      return ['Piso 1', 'Piso 2', 'Piso 3']; // Fallback
    }
  }

  /// Obtener tipos de alertas únicos
  Future<List<String>> getUniqueTipos({String edificio = 'A'}) async {
    try {
      final alerts = await getAlerts(edificio: edificio);
      final tipos = alerts.map((a) => a.tipo).toSet().toList();
      tipos.sort();
      return tipos;
    } catch (e) {
      print('❌ Error obteniendo tipos: $e');
      return ['Temperatura', 'Humedad', 'Energía']; // Fallback
    }
  }

  /// Obtener severidades únicas
  Future<List<String>> getUniqueSeveridades({String edificio = 'A'}) async {
    try {
      final alerts = await getAlerts(edificio: edificio);
      final severidades = alerts.map((a) => a.severidad).toSet().toList();

      // Ordenar por severidad (de mayor a menor)
      final severidadOrder = [
        'Crítico',
        'Alto',
        'Medio',
        'Bajo',
        'Informativo',
        'OK'
      ];
      severidades.sort((a, b) {
        int indexA = severidadOrder.indexOf(a);
        int indexB = severidadOrder.indexOf(b);
        if (indexA == -1) indexA = 999;
        if (indexB == -1) indexB = 999;
        return indexA.compareTo(indexB);
      });

      return severidades;
    } catch (e) {
      print('❌ Error obteniendo severidades: $e');
      return ['Crítico', 'Alto', 'Medio', 'Bajo', 'Informativo', 'OK'];
    }
  }

  /// Obtener datos del dashboard de un piso
  Future<Map<String, dynamic>> getDashboard({
    required int piso,
    String edificio = 'A',
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/dashboard/$piso?edificio=$edificio'),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ Error obteniendo dashboard: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('❌ Error: $e');
      return {};
    }
  }

  /// Resolver una alerta
  Future<bool> resolveAlert(int alertId) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/alerts/$alertId/resolver'),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        print('✅ Alerta $alertId resuelta');
        return true;
      } else {
        print('❌ Error resolviendo alerta: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  /// Obtener datos para gráficas de tendencias
  /// Si piso es null, devuelve el promedio de todos los pisos
  Future<Map<String, dynamic>> getChartData({
    int? piso,
    String edificio = 'A',
    int limit = 60,
  }) async {
    try {
      String url =
          '$_baseUrl/sensor-data/chart?edificio=$edificio&limit=$limit';

      if (piso != null) {
        url += '&piso=$piso';
      }

      print('📊 Obteniendo datos de gráficas: $url');

      final response = await http.get(Uri.parse(url)).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            '✅ Datos de gráficas obtenidos: ${data['data']?.length ?? 0} puntos');
        return data;
      } else {
        print('❌ Error obteniendo datos de gráficas: ${response.statusCode}');
        return {'piso': piso ?? 'Todos', 'data': []};
      }
    } catch (e) {
      print('❌ Error obteniendo datos de gráficas: $e');
      return {'piso': piso ?? 'Todos', 'data': []};
    }
  }

  // ========== HELPERS ==========

  /// Mapear severidad del backend (low/medium/high) a UI (OK/Bajo/Medio/Alto/Crítico)
  String _mapSeveridad(String backendSeveridad) {
    switch (backendSeveridad.toLowerCase()) {
      case 'low':
        return 'Bajo';
      case 'medium':
        return 'Medio';
      case 'high':
        return 'Crítico';
      default:
        return backendSeveridad;
    }
  }

  /// Extraer número de piso de formato "Piso 1"
  int? _extractPisoNumber(String piso) {
    try {
      return int.parse(piso.replaceAll(RegExp(r'[^\d]'), ''));
    } catch (e) {
      return null;
    }
  }
}
