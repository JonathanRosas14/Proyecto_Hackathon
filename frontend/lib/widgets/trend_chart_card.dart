import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class TrendChartCard extends StatefulWidget {
  final String title;
  final String value;
  final String subtitle;

  const TrendChartCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              '10 AM',
              style: TextStyle(
                color: Color(0xFF93c5c5),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '11 AM',
              style: TextStyle(
                color: Color(0xFF93c5c5),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '12 PM',
              style: TextStyle(
                color: Color(0xFF93c5c5),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '1 PM',
              style: TextStyle(
                color: Color(0xFF93c5c5),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: _generateRandomSpots(),
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

  List<FlSpot> _generateRandomSpots() {
    final random = math.Random(42); // Fixed seed for consistency
    return List.generate(12, (index) {
      return FlSpot(index.toDouble(), 20 + random.nextDouble() * 60);
    });
  }
}
