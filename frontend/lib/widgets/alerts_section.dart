import 'package:flutter/material.dart';

class AlertsSection extends StatefulWidget {
  final Function(String?, String?)? onFilterChanged;

  const AlertsSection({
    super.key,
    this.onFilterChanged,
  });

  @override
  State<AlertsSection> createState() => _AlertsSectionState();
}

class _AlertsSectionState extends State<AlertsSection> {
  String? selectedFloor;
  String? selectedAlertLevel;

  void _notifyFilterChange() {
    widget.onFilterChanged?.call(selectedFloor, selectedAlertLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Alertas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        // Floor filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildFilterChip('Piso 1', isFloor: true),
              _buildFilterChip('Piso 2', isFloor: true),
              _buildFilterChip('Piso 3', isFloor: true),
              _buildFilterChip('Todos', isFloor: true),
            ],
          ),
        ),
        // Alert level filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildFilterChip('OK', isFloor: false),
              _buildFilterChip('Informativa', isFloor: false),
              _buildFilterChip('Media', isFloor: false),
              _buildFilterChip('Crítica', isFloor: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, {required bool isFloor}) {
    final bool isSelected = isFloor
        ? (label == 'Todos' ? selectedFloor == null : selectedFloor == label)
        : selectedAlertLevel == label;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          setState(() {
            if (isFloor) {
              // Si selecciona "Todos", limpia el filtro
              if (label == 'Todos') {
                selectedFloor = null;
              } else {
                selectedFloor = selectedFloor == label ? null : label;
              }
            } else {
              // Toggle: si está seleccionado, deseleccionarlo; si no, seleccionarlo
              selectedAlertLevel = selectedAlertLevel == label ? null : label;
            }
          });
          _notifyFilterChange();
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF1a5555) : const Color(0xFF0f2f2f),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF4ecca3) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF4ecca3) : Colors.white,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
