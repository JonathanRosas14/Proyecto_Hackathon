import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/app_header.dart';
import '../widgets/floor_summary_section.dart';
import '../widgets/trend_analysis_section.dart';
import '../widgets/alerts_section.dart';
import '../widgets/alerts_table.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedPiso;
  String? _selectedSeveridad;
  int? _selectedFloor; // null significa "Todos"
  Map<String, dynamic> _chartData = {'piso': 'Todos', 'data': []};
  Timer? _updateTimer;
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadChartData();
    // Actualizar datos cada 60 segundos
    _updateTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _loadChartData();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadChartData() async {
    try {
      final data = await _dbService.getChartData(
        piso: _selectedFloor,
        edificio: 'A',
        limit: 60,
      );
      if (mounted) {
        setState(() {
          _chartData = data;
        });
      }
    } catch (e) {
      print('Error cargando datos de gráficas: $e');
    }
  }

  void _handleFilterChange(String? piso, String? severidad) {
    setState(() {
      _selectedPiso = piso;
      _selectedSeveridad = severidad;
    });
  }

  void _handleFloorSelection(int? floor) {
    setState(() {
      _selectedFloor = floor;
    });
    _loadChartData();
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
                      FloorSummarySection(
                        selectedFloor: _selectedFloor,
                        onFloorSelected: _handleFloorSelection,
                      ),
                      // Trend Analysis Section
                      TrendAnalysisSection(
                        chartData: _chartData,
                        selectedFloor: _selectedFloor,
                      ),
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
