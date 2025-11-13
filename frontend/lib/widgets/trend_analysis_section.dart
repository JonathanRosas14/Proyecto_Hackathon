import 'package:flutter/material.dart';
import 'dart:async';
import 'trend_chart_card.dart';
import '../services/database_service.dart';

class TrendAnalysisSection extends StatefulWidget {
  final String selectedBuilding;
  final int? selectedFloor;

  const TrendAnalysisSection({
    super.key,
    required this.selectedBuilding,
    required this.selectedFloor,
  });

  @override
  State<TrendAnalysisSection> createState() => _TrendAnalysisSectionState();
}

class _TrendAnalysisSectionState extends State<TrendAnalysisSection>
    with AutomaticKeepAliveClientMixin {
  final DatabaseService _dbService = DatabaseService();

  // Usar ValueNotifier para actualizaciones más granulares
  final ValueNotifier<Map<String, dynamic>> _chartDataNotifier =
      ValueNotifier<Map<String, dynamic>>({'piso': 'Todos', 'data': []});

  Timer? _updateTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadChartData();
    // Actualizar solo las gráficas cada 60 segundos
    _updateTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _loadChartData();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _chartDataNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TrendAnalysisSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambia el piso o edificio seleccionado, recargar datos inmediatamente
    if (oldWidget.selectedFloor != widget.selectedFloor ||
        oldWidget.selectedBuilding != widget.selectedBuilding) {
      _loadChartData();
    }
  }

  Future<void> _loadChartData() async {
    try {
      final data = await _dbService.getChartData(
        piso: widget.selectedFloor,
        edificio: widget.selectedBuilding,
        limit: 60,
      );
      // Solo actualizar si los datos han cambiado
      if (_chartDataNotifier.value != data) {
        _chartDataNotifier.value = data;
      }
    } catch (e) {
      print('Error cargando datos de gráficas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return ValueListenableBuilder<Map<String, dynamic>>(
      valueListenable: _chartDataNotifier,
      builder: (context, chartData, _) {
        final data = chartData['data'] as List? ?? [];

        // Calcular valores actuales (último registro)
        final currentValues = _calculateCurrentValues(data);
        final floorText = widget.selectedFloor == null
            ? 'Todos los pisos'
            : 'Piso ${widget.selectedFloor}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Widget const para evitar reconstrucción
            _TrendAnalysisHeader(floorText: floorText),
            // Charts - Solo se reconstruyen cuando cambian los datos
            _ChartsLayout(
              data: data,
              currentValues: currentValues,
            ),
          ],
        );
      },
    );
  }

  Map<String, String> _calculateCurrentValues(List<dynamic> data) {
    String tempValue = '-- °C';
    String humidityValue = '-- %';
    String energyValue = '-- kWh';

    if (data.isNotEmpty) {
      final lastData = data.last;
      tempValue = '${lastData['temp_c']?.toStringAsFixed(1) ?? '--'}°C';
      humidityValue = '${lastData['humedad_pct']?.toStringAsFixed(1) ?? '--'}%';
      energyValue = '${lastData['energia_kw']?.toStringAsFixed(1) ?? '--'} kWh';
    }

    return {
      'temp': tempValue,
      'humidity': humidityValue,
      'energy': energyValue,
    };
  }
}

/// Widget separado para el header que solo depende del texto del piso
class _TrendAnalysisHeader extends StatelessWidget {
  final String floorText;

  const _TrendAnalysisHeader({required this.floorText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          const Text(
            'Análisis de Tendencias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1a5555),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4ecca3),
                width: 1,
              ),
            ),
            child: Text(
              floorText,
              style: const TextStyle(
                color: Color(0xFF4ecca3),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget separado para el layout de los charts
class _ChartsLayout extends StatelessWidget {
  final List<dynamic> data;
  final Map<String, String> currentValues;

  const _ChartsLayout({
    required this.data,
    required this.currentValues,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: screenWidth > 1200
          ? _buildRowLayout()
          : screenWidth > 700
              ? _buildMixedLayout()
              : _buildColumnLayout(),
    );
  }

  Widget _buildRowLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TrendChartCard(
            title: 'Temperatura',
            value: currentValues['temp']!,
            subtitle: 'Últimos 60 registros',
            chartData: data,
            dataKey: 'temp_c',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TrendChartCard(
            title: 'Humedad',
            value: currentValues['humidity']!,
            subtitle: 'Últimos 60 registros',
            chartData: data,
            dataKey: 'humedad_pct',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TrendChartCard(
            title: 'Energía',
            value: currentValues['energy']!,
            subtitle: 'Últimos 60 registros',
            chartData: data,
            dataKey: 'energia_kw',
          ),
        ),
      ],
    );
  }

  Widget _buildMixedLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TrendChartCard(
                title: 'Temperatura',
                value: currentValues['temp']!,
                subtitle: 'Últimos 60 registros',
                chartData: data,
                dataKey: 'temp_c',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TrendChartCard(
                title: 'Humedad',
                value: currentValues['humidity']!,
                subtitle: 'Últimos 60 registros',
                chartData: data,
                dataKey: 'humedad_pct',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TrendChartCard(
          title: 'Energía',
          value: currentValues['energy']!,
          subtitle: 'Últimos 60 registros',
          chartData: data,
          dataKey: 'energia_kw',
        ),
      ],
    );
  }

  Widget _buildColumnLayout() {
    return Column(
      children: [
        TrendChartCard(
          title: 'Temperatura',
          value: currentValues['temp']!,
          subtitle: 'Últimos 60 registros',
          chartData: data,
          dataKey: 'temp_c',
        ),
        const SizedBox(height: 16),
        TrendChartCard(
          title: 'Humedad',
          value: currentValues['humidity']!,
          subtitle: 'Últimos 60 registros',
          chartData: data,
          dataKey: 'humedad_pct',
        ),
        const SizedBox(height: 16),
        TrendChartCard(
          title: 'Energía',
          value: currentValues['energy']!,
          subtitle: 'Últimos 60 registros',
          chartData: data,
          dataKey: 'energia_kw',
        ),
      ],
    );
  }
}
