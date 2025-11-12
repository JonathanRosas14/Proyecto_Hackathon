import '../models/alert_model.dart';

/// Servicio de base de datos con datos MOCK
/// Para conectar a PostgreSQL real, crea un backend REST API
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Datos simulados de la tabla alerts
  final List<AlertModel> _allAlerts = [
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      piso: 'Piso 1',
      tipo: 'Temperatura',
      severidad: 'OK',
      recomendacion: 'Temperatura dentro de parámetros normales',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      piso: 'Piso 2',
      tipo: 'Humedad',
      severidad: 'Informativo',
      recomendacion: 'Revisar sistema de ventilación en las próximas 24 horas',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      piso: 'Piso 2',
      tipo: 'Temperatura',
      severidad: 'Crítico',
      recomendacion:
          'Revisión inmediata del sistema HVAC - Temperatura excede límites',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      piso: 'Piso 3',
      tipo: 'Energía',
      severidad: 'Medio',
      recomendacion:
          'Consumo elevado detectado - Reducir uso de equipos no esenciales',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      piso: 'Piso 1',
      tipo: 'Humedad',
      severidad: 'Bajo',
      recomendacion: 'Humedad ligeramente por debajo del rango óptimo',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      piso: 'Piso 3',
      tipo: 'Temperatura',
      severidad: 'Informativo',
      recomendacion:
          'Monitorear tendencia de temperatura en las próximas horas',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      piso: 'Piso 1',
      tipo: 'Energía',
      severidad: 'OK',
      recomendacion: 'Consumo energético dentro de parámetros normales',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      piso: 'Piso 2',
      tipo: 'Energía',
      severidad: 'Alto',
      recomendacion: 'Pico de consumo detectado - Revisar equipos activos',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
      piso: 'Piso 3',
      tipo: 'Humedad',
      severidad: 'Crítico',
      recomendacion:
          'Humedad excesiva - Activar deshumidificadores inmediatamente',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      piso: 'Piso 1',
      tipo: 'Temperatura',
      severidad: 'Medio',
      recomendacion:
          'Ajustar termostato - Temperatura por encima del rango óptimo',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
      piso: 'Piso 2',
      tipo: 'Humedad',
      severidad: 'OK',
      recomendacion: 'Niveles de humedad óptimos',
    ),
    AlertModel(
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      piso: 'Piso 3',
      tipo: 'Energía',
      severidad: 'Bajo',
      recomendacion: 'Consumo energético reducido - Operación eficiente',
    ),
  ];

  Future<void> connect() async {
    await Future.delayed(const Duration(milliseconds: 800));
    print('✅ Conexión simulada (datos mock)');
  }

  Future<void> disconnect() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<List<AlertModel>> getAlerts({
    String? pisoFilter,
    String? tipoFilter,
    String? severidadFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      // Filtrar los datos según los criterios
      List<AlertModel> filteredAlerts = List.from(_allAlerts);

      if (pisoFilter != null &&
          pisoFilter.isNotEmpty &&
          pisoFilter != 'Todos') {
        filteredAlerts =
            filteredAlerts.where((alert) => alert.piso == pisoFilter).toList();
      }

      if (tipoFilter != null &&
          tipoFilter.isNotEmpty &&
          tipoFilter != 'Todos') {
        filteredAlerts =
            filteredAlerts.where((alert) => alert.tipo == tipoFilter).toList();
      }

      if (severidadFilter != null &&
          severidadFilter.isNotEmpty &&
          severidadFilter != 'Todos') {
        filteredAlerts = filteredAlerts
            .where((alert) => alert.severidad == severidadFilter)
            .toList();
      }

      // Ordenar por timestamp descendente
      filteredAlerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Limitar a 100 resultados
      if (filteredAlerts.length > 100) {
        filteredAlerts = filteredAlerts.sublist(0, 100);
      }

      return filteredAlerts;
    } catch (e) {
      print('❌ Error al consultar alertas: $e');
      return [];
    }
  }

  Future<List<String>> getUniquePisos() async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final pisos = _allAlerts.map((alert) => alert.piso).toSet().toList();
      pisos.sort();
      return pisos;
    } catch (e) {
      print('❌ Error al obtener pisos: $e');
      return [];
    }
  }

  Future<List<String>> getUniqueTipos() async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final tipos = _allAlerts.map((alert) => alert.tipo).toSet().toList();
      tipos.sort();
      return tipos;
    } catch (e) {
      print('❌ Error al obtener tipos: $e');
      return [];
    }
  }

  Future<List<String>> getUniqueSeveridades() async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final severidades =
          _allAlerts.map((alert) => alert.severidad).toSet().toList();
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
      print('❌ Error al obtener severidades: $e');
      return [];
    }
  }
}
