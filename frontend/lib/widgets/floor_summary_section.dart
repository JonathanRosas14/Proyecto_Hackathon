import 'package:flutter/material.dart';
import 'dart:async';
import '../services/database_service.dart';

class FloorSummarySection extends StatefulWidget {
  final String selectedBuilding;
  final int? selectedFloor;
  final Function(int?) onFloorSelected;

  const FloorSummarySection({
    super.key,
    required this.selectedBuilding,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

  @override
  State<FloorSummarySection> createState() => _FloorSummarySectionState();
}

class _FloorSummarySectionState extends State<FloorSummarySection> {
  final DatabaseService _dbService = DatabaseService();
  Map<int, Map<String, dynamic>> _floorStatuses = {};
  Timer? _updateTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFloorStatuses();
    // Actualizar estados cada 30 segundos
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadFloorStatuses();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(FloorSummarySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBuilding != widget.selectedBuilding) {
      _loadFloorStatuses();
    }
  }

  Future<void> _loadFloorStatuses() async {
    try {
      final alerts = await _dbService.getAlerts(
        edificio: widget.selectedBuilding,
      );

      final Map<int, Map<String, dynamic>> statuses = {};

      // Calcular el peor estado por piso
      for (var alert in alerts) {
        final piso = _extractFloorNumber(alert.piso);
        if (piso == null) continue;

        if (!statuses.containsKey(piso)) {
          statuses[piso] = {
            'status': alert.severidad,
            'color': _getSeverityColor(alert.severidad),
            'priority': _getSeverityPriority(alert.severidad),
          };
        } else {
          // Si el nuevo alert tiene mayor prioridad, actualizar
          final currentPriority = statuses[piso]!['priority'] as int;
          final newPriority = _getSeverityPriority(alert.severidad);
          if (newPriority > currentPriority) {
            statuses[piso] = {
              'status': alert.severidad,
              'color': _getSeverityColor(alert.severidad),
              'priority': newPriority,
            };
          }
        }
      }

      setState(() {
        _floorStatuses = statuses;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error cargando estados de pisos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  int? _extractFloorNumber(String piso) {
    // Extraer número del string "Piso 1", "Piso 2", etc.
    final match = RegExp(r'\d+').firstMatch(piso);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }

  Color _getSeverityColor(String severidad) {
    switch (severidad.toLowerCase()) {
      case 'ok':
        return const Color(0xFF4ecca3);
      case 'informativa':
      case 'informativo':
        return const Color(0xFFffa726);
      case 'media':
      case 'medio':
        return const Color(0xFFf06292);
      case 'crítica':
      case 'critica':
        return const Color(0xFFef5350);
      default:
        return const Color(0xFF93c5c5);
    }
  }

  int _getSeverityPriority(String severidad) {
    switch (severidad.toLowerCase()) {
      case 'ok':
        return 1;
      case 'informativa':
      case 'informativo':
        return 2;
      case 'media':
      case 'medio':
        return 3;
      case 'crítica':
      case 'critica':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final useColumn = screenWidth < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Resumen de Pisos',
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
          child: _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      color: Color(0xFF4ecca3),
                    ),
                  ),
                )
              : useColumn
                  ? Column(
                      children: [
                        _buildFloorCard(context, 'Todos', null),
                        const SizedBox(height: 16),
                        _buildFloorCard(context, 'Piso 1', 1),
                        const SizedBox(height: 16),
                        _buildFloorCard(context, 'Piso 2', 2),
                        const SizedBox(height: 16),
                        _buildFloorCard(context, 'Piso 3', 3),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: _buildFloorCard(context, 'Todos', null)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFloorCard(context, 'Piso 1', 1)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFloorCard(context, 'Piso 2', 2)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildFloorCard(context, 'Piso 3', 3)),
                      ],
                    ),
        ),
      ],
    );
  }

  Widget _buildFloorCard(
    BuildContext context,
    String title,
    int? floorNumber,
  ) {
    // Obtener el estado del piso desde los datos cargados
    String status;
    Color statusColor;

    if (floorNumber == null) {
      // Para "Todos", calcular promedio/peor estado
      status = _calculateOverallStatus();
      statusColor = _getSeverityColor(status);
    } else {
      // Para pisos específicos, obtener su estado
      final floorStatus = _floorStatuses[floorNumber];
      if (floorStatus != null) {
        status = floorStatus['status'] as String;
        statusColor = floorStatus['color'] as Color;
      } else {
        status = 'OK';
        statusColor = const Color(0xFF4ecca3);
      }
    }

    final isSelected = widget.selectedFloor == floorNumber;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          widget.onFloorSelected(floorNumber);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1a5555),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF4ecca3) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateOverallStatus() {
    if (_floorStatuses.isEmpty) return 'OK';

    int maxPriority = 0;
    String status = 'OK';

    for (var floorStatus in _floorStatuses.values) {
      final priority = floorStatus['priority'] as int;
      if (priority > maxPriority) {
        maxPriority = priority;
        status = floorStatus['status'] as String;
      }
    }

    return status;
  }
}
