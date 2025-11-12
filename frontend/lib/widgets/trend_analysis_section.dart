import 'package:flutter/material.dart';
import 'trend_chart_card.dart';

class TrendAnalysisSection extends StatelessWidget {
  final Map<String, dynamic> chartData;
  final int? selectedFloor;

  const TrendAnalysisSection({
    super.key,
    required this.chartData,
    required this.selectedFloor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final data = chartData['data'] as List? ?? [];

    // Calcular valores actuales (último registro)
    String tempValue = '-- °C';
    String humidityValue = '-- %';
    String energyValue = '-- kWh';

    if (data.isNotEmpty) {
      final lastData = data.last;
      tempValue = '${lastData['temp_c']?.toStringAsFixed(1) ?? '--'}°C';
      humidityValue = '${lastData['humedad_pct']?.toStringAsFixed(1) ?? '--'}%';
      energyValue = '${lastData['energia_kw']?.toStringAsFixed(1) ?? '--'} kWh';
    }

    final floorText =
        selectedFloor == null ? 'Todos los pisos' : 'Piso $selectedFloor';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: screenWidth > 1200
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TrendChartCard(
                        title: 'Temperatura',
                        value: tempValue,
                        subtitle: 'Últimos 60 registros',
                        chartData: data,
                        dataKey: 'temp_c',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TrendChartCard(
                        title: 'Humedad',
                        value: humidityValue,
                        subtitle: 'Últimos 60 registros',
                        chartData: data,
                        dataKey: 'humedad_pct',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TrendChartCard(
                        title: 'Energía',
                        value: energyValue,
                        subtitle: 'Últimos 60 registros',
                        chartData: data,
                        dataKey: 'energia_kw',
                      ),
                    ),
                  ],
                )
              : screenWidth > 700
                  ? Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TrendChartCard(
                                title: 'Temperatura',
                                value: tempValue,
                                subtitle: 'Últimos 60 registros',
                                chartData: data,
                                dataKey: 'temp_c',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TrendChartCard(
                                title: 'Humedad',
                                value: humidityValue,
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
                          value: energyValue,
                          subtitle: 'Últimos 60 registros',
                          chartData: data,
                          dataKey: 'energia_kw',
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        TrendChartCard(
                          title: 'Temperatura',
                          value: tempValue,
                          subtitle: 'Últimos 60 registros',
                          chartData: data,
                          dataKey: 'temp_c',
                        ),
                        const SizedBox(height: 16),
                        TrendChartCard(
                          title: 'Humedad',
                          value: humidityValue,
                          subtitle: 'Últimos 60 registros',
                          chartData: data,
                          dataKey: 'humedad_pct',
                        ),
                        const SizedBox(height: 16),
                        TrendChartCard(
                          title: 'Energía',
                          value: energyValue,
                          subtitle: 'Últimos 60 registros',
                          chartData: data,
                          dataKey: 'energia_kw',
                        ),
                      ],
                    ),
        ),
      ],
    );
  }
}
