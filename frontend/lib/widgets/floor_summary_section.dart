import 'package:flutter/material.dart';

class FloorSummarySection extends StatelessWidget {
  final int? selectedFloor;
  final Function(int?) onFloorSelected;

  const FloorSummarySection({
    super.key,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

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
          child: useColumn
              ? Column(
                  children: [
                    _buildFloorCard(
                      context,
                      'Todos',
                      null,
                      'Promedio',
                      const Color(0xFF93c5c5),
                    ),
                    const SizedBox(height: 16),
                    _buildFloorCard(
                      context,
                      'Piso 1',
                      1,
                      'OK',
                      const Color(0xFF4ecca3),
                    ),
                    const SizedBox(height: 16),
                    _buildFloorCard(
                      context,
                      'Piso 2',
                      2,
                      'Informativo',
                      const Color(0xFFffa726),
                    ),
                    const SizedBox(height: 16),
                    _buildFloorCard(
                      context,
                      'Piso 3',
                      3,
                      'Medio',
                      const Color(0xFFf06292),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildFloorCard(
                        context,
                        'Todos',
                        null,
                        'Promedio',
                        const Color(0xFF93c5c5),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFloorCard(
                        context,
                        'Piso 1',
                        1,
                        'OK',
                        const Color(0xFF4ecca3),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFloorCard(
                        context,
                        'Piso 2',
                        2,
                        'Informativo',
                        const Color(0xFFffa726),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFloorCard(
                        context,
                        'Piso 3',
                        3,
                        'Medio',
                        const Color(0xFFf06292),
                      ),
                    ),
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
    String status,
    Color statusColor,
  ) {
    final isSelected = selectedFloor == floorNumber;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          onFloorSelected(floorNumber);
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
}
