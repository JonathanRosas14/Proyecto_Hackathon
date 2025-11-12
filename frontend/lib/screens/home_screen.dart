import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/floor_summary_section.dart';
import '../widgets/trend_analysis_section.dart';
import '../widgets/alerts_section.dart';
import '../widgets/alerts_table.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedPiso;
  String? _selectedSeveridad;

  void _handleFilterChange(String? piso, String? severidad) {
    setState(() {
      _selectedPiso = piso;
      _selectedSeveridad = severidad;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Ajustar padding según el ancho de pantalla
    final horizontalPadding = screenWidth > 1400
        ? 160.0
        : screenWidth > 1000
            ? 80.0
            : screenWidth > 600
                ? 40.0
                : 16.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Building Overview Title
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Vista General del Edificio',
                          style: TextStyle(
                            fontSize: screenWidth > 600 ? 32 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      // Floor Summary Section
                      const FloorSummarySection(),
                      // Trend Analysis Section
                      const TrendAnalysisSection(),
                      // Alerts Section
                      AlertsSection(
                        onFilterChanged: _handleFilterChange,
                      ),
                      // Alerts Table
                      AlertsTable(
                        pisoFilter: _selectedPiso,
                        severidadFilter: _selectedSeveridad,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
