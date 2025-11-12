import 'package:flutter/material.dart';
import 'trend_chart_card.dart';

class TrendAnalysisSection extends StatelessWidget {
  const TrendAnalysisSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Análisis de Tendencias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: screenWidth > 1200
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(
                      child: TrendChartCard(
                        title: 'Temperatura',
                        value: '22°C',
                        subtitle: 'Últimas 4 horas',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TrendChartCard(
                        title: 'Humedad',
                        value: '55%',
                        subtitle: 'Últimas 4 horas',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TrendChartCard(
                        title: 'Energía',
                        value: '1200 kWh',
                        subtitle: 'Últimas 4 horas',
                      ),
                    ),
                  ],
                )
              : screenWidth > 700
                  ? Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(
                              child: TrendChartCard(
                                title: 'Temperatura',
                                value: '22°C',
                                subtitle: 'Últimas 4 horas',
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: TrendChartCard(
                                title: 'Humedad',
                                value: '55%',
                                subtitle: 'Últimas 4 horas',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const TrendChartCard(
                          title: 'Energía',
                          value: '1200 kWh',
                          subtitle: 'Últimas 4 horas',
                        ),
                      ],
                    )
                  : Column(
                      children: const [
                        TrendChartCard(
                          title: 'Temperatura',
                          value: '22°C',
                          subtitle: 'Últimas 4 horas',
                        ),
                        SizedBox(height: 16),
                        TrendChartCard(
                          title: 'Humedad',
                          value: '55%',
                          subtitle: 'Últimas 4 horas',
                        ),
                        SizedBox(height: 16),
                        TrendChartCard(
                          title: 'Energía',
                          value: '1200 kWh',
                          subtitle: 'Últimas 4 horas',
                        ),
                      ],
                    ),
        ),
      ],
    );
  }
}
