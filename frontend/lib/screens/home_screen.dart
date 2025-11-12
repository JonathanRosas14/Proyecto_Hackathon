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
  // Usar ValueNotifier para actualizaciones más granulares
  final ValueNotifier<String?> _selectedPiso = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedSeveridad =
      ValueNotifier<String?>(null);
  final ValueNotifier<int?> _selectedFloor = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _selectedPiso.dispose();
    _selectedSeveridad.dispose();
    _selectedFloor.dispose();
    super.dispose();
  }

  void _handleFilterChange(String? piso, String? severidad) {
    _selectedPiso.value = piso;
    _selectedSeveridad.value = severidad;
  }

  void _handleFloorSelection(int? floor) {
    _selectedFloor.value = floor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: _HomeContent(
                  selectedFloor: _selectedFloor,
                  selectedPiso: _selectedPiso,
                  selectedSeveridad: _selectedSeveridad,
                  onFloorSelected: _handleFloorSelection,
                  onFilterChanged: _handleFilterChange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget separado para evitar reconstruir todo cuando cambian los filtros
class _HomeContent extends StatelessWidget {
  final ValueNotifier<int?> selectedFloor;
  final ValueNotifier<String?> selectedPiso;
  final ValueNotifier<String?> selectedSeveridad;
  final Function(int?) onFloorSelected;
  final Function(String?, String?) onFilterChanged;

  const _HomeContent({
    required this.selectedFloor,
    required this.selectedPiso,
    required this.selectedSeveridad,
    required this.onFloorSelected,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 1400
        ? 160.0
        : screenWidth > 1000
            ? 80.0
            : screenWidth > 600
                ? 40.0
                : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Building Overview Title - Widget const
          _BuildingOverviewTitle(screenWidth: screenWidth),
          // Floor Summary Section
          ValueListenableBuilder<int?>(
            valueListenable: selectedFloor,
            builder: (context, floor, _) {
              return FloorSummarySection(
                selectedFloor: floor,
                onFloorSelected: onFloorSelected,
              );
            },
          ),
          // Trend Analysis Section - Solo se reconstruye cuando cambia el piso
          ValueListenableBuilder<int?>(
            valueListenable: selectedFloor,
            builder: (context, floor, _) {
              return TrendAnalysisSection(
                key: ValueKey('trend_$floor'),
                selectedFloor: floor,
              );
            },
          ),
          // Alerts Section
          AlertsSection(
            onFilterChanged: onFilterChanged,
          ),
          // Alerts Table - Solo se reconstruye cuando cambian los filtros
          ValueListenableBuilder<String?>(
            valueListenable: selectedPiso,
            builder: (context, piso, _) {
              return ValueListenableBuilder<String?>(
                valueListenable: selectedSeveridad,
                builder: (context, severidad, _) {
                  return AlertsTable(
                    key: ValueKey('alerts_${piso}_$severidad'),
                    pisoFilter: piso,
                    severidadFilter: severidad,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// Widget const para el título que nunca cambia
class _BuildingOverviewTitle extends StatelessWidget {
  final double screenWidth;

  const _BuildingOverviewTitle({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
