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
  final ValueNotifier<String> _selectedBuilding = ValueNotifier<String>('A');
  final ValueNotifier<String?> _selectedPiso = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedSeveridad =
      ValueNotifier<String?>(null);
  final ValueNotifier<int?> _selectedFloor = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _selectedBuilding.dispose();
    _selectedPiso.dispose();
    _selectedSeveridad.dispose();
    _selectedFloor.dispose();
    super.dispose();
  }

  void _handleBuildingChange(String building) {
    _selectedBuilding.value = building;
    // Reset filters when building changes
    _selectedPiso.value = null;
    _selectedSeveridad.value = null;
    _selectedFloor.value = null;
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
            ValueListenableBuilder<String>(
              valueListenable: _selectedBuilding,
              builder: (context, building, _) {
                return AppHeader(
                  selectedBuilding: building,
                  onBuildingChanged: _handleBuildingChange,
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder<String>(
                  valueListenable: _selectedBuilding,
                  builder: (context, building, _) {
                    return _HomeContent(
                      key: ValueKey('content_$building'),
                      selectedBuilding: building,
                      selectedFloor: _selectedFloor,
                      selectedPiso: _selectedPiso,
                      selectedSeveridad: _selectedSeveridad,
                      onFloorSelected: _handleFloorSelection,
                      onFilterChanged: _handleFilterChange,
                    );
                  },
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
  final String selectedBuilding;
  final ValueNotifier<int?> selectedFloor;
  final ValueNotifier<String?> selectedPiso;
  final ValueNotifier<String?> selectedSeveridad;
  final Function(int?) onFloorSelected;
  final Function(String?, String?) onFilterChanged;

  const _HomeContent({
    super.key,
    required this.selectedBuilding,
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
          // Building Overview Title
          _BuildingOverviewTitle(
            screenWidth: screenWidth,
            selectedBuilding: selectedBuilding,
          ),
          // Floor Summary Section
          ValueListenableBuilder<int?>(
            valueListenable: selectedFloor,
            builder: (context, floor, _) {
              return FloorSummarySection(
                selectedBuilding: selectedBuilding,
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
                key: ValueKey('trend_${selectedBuilding}_$floor'),
                selectedBuilding: selectedBuilding,
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
                    key: ValueKey(
                        'alerts_${selectedBuilding}_${piso}_$severidad'),
                    selectedBuilding: selectedBuilding,
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

/// Widget para el título con el edificio seleccionado
class _BuildingOverviewTitle extends StatelessWidget {
  final double screenWidth;
  final String selectedBuilding;

  const _BuildingOverviewTitle({
    required this.screenWidth,
    required this.selectedBuilding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Vista General del Edificio $selectedBuilding',
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
