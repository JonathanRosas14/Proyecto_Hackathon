import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class TrendChartCard extends StatefulWidget {
  final String title;
  final String value;
  final String subtitle;
  final List<dynamic> chartData;
  final String dataKey;

  const TrendChartCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.chartData,
    required this.dataKey,
  });

  @override
  State<TrendChartCard> createState() => _TrendChartCardState();
}

class _TrendChartCardState extends State<TrendChartCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: () {
          print('Gráfico de ${widget.title} clickeado');
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFF1a5555) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovered ? const Color(0xFF4ecca3) : Colors.transparent,
              width: 1,
            ),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.subtitle,
          style: const TextStyle(
            color: Color(0xFF93c5c5),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        // Chart
        SizedBox(
          height: 180,
          child: _buildChart(),
        ),
        const SizedBox(height: 8),
        // Time labels
        _buildTimeLabels(),
      ],
    );
  }

  Widget _buildChart() {
    final spots = _generateSpotsFromData();

    if (spots.isEmpty) {
      return const Center(
        child: Text(
          'Sin datos disponibles',
          style: TextStyle(
            color: Color(0xFF93c5c5),
            fontSize: 14,
          ),
        ),
      );
    }

    // Calcular min y max para el eje Y
    final values = spots.map((s) => s.y).toList();
    final minY = values.reduce(math.min);
    final maxY = values.reduce(math.max);
    final range = maxY - minY;
    final padding = range * 0.2; // 20% de padding

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF4ecca3),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF4ecca3).withOpacity(0.3),
                  const Color(0xFF4ecca3).withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpotsFromData() {
    if (widget.chartData.isEmpty) {
      return [];
    }

    final spots = <FlSpot>[];

    for (int i = 0; i < widget.chartData.length; i++) {
      final data = widget.chartData[i];
      final value = data[widget.dataKey];

      if (value != null) {
        spots.add(FlSpot(i.toDouble(), value.toDouble()));
      }
    }

    return spots;
  }

  Widget _buildTimeLabels() {
    if (widget.chartData.isEmpty || widget.chartData.length < 4) {
      return const SizedBox.shrink();
    }

    // Mostrar 4 etiquetas equidistantes
    final totalPoints = widget.chartData.length;
    final indices = [
      0,
      totalPoints ~/ 3,
      (totalPoints * 2) ~/ 3,
      totalPoints - 1,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: indices.map((index) {
        if (index >= widget.chartData.length) {
          return const SizedBox.shrink();
        }

        final data = widget.chartData[index];
        final timestamp = data['timestamp'] as String?;

        String timeLabel = '--';
        if (timestamp != null) {
          try {
            final dateTime = DateTime.parse(timestamp);
            final hour = dateTime.hour;
            final minute = dateTime.minute;
            timeLabel =
                '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
          } catch (e) {
            timeLabel = '--';
          }
        }

        return Text(
          timeLabel,
          style: const TextStyle(
            color: Color(0xFF93c5c5),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }
}
