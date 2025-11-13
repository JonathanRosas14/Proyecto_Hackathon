import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String selectedBuilding;
  final Function(String) onBuildingChanged;

  const AppHeader({
    super.key,
    required this.selectedBuilding,
    required this.onBuildingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1a5555), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 40,
        vertical: 12,
      ),
      child: Row(
        children: [
          // Logo and Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.layers,
                color: Color(0xFF4ecca3),
                size: 24,
              ),
              const SizedBox(width: 12),
              if (!isNarrow || screenWidth > 400)
                const Text(
                  'SmartFloor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          // Building Selector
          _buildBuildingSelector(screenWidth),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBuildingSelector(double screenWidth) {
    // Lista de edificios disponibles
    final buildings = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1a5555),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF4ecca3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.business,
            color: Color(0xFF4ecca3),
            size: 16,
          ),
          const SizedBox(width: 8),
          if (screenWidth > 500)
            const Text(
              'Edificio:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedBuilding,
            dropdownColor: const Color(0xFF1a5555),
            underline: Container(),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF4ecca3),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            items: buildings.map((String building) {
              return DropdownMenuItem<String>(
                value: building,
                child: Text('Edificio $building'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onBuildingChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.125, size.height * 0.125);
    path.lineTo(size.width * 0.875, size.height * 0.125);
    path.lineTo(size.width * 0.75, size.height * 0.5);
    path.lineTo(size.width * 0.875, size.height * 0.875);
    path.lineTo(size.width * 0.125, size.height * 0.875);
    path.lineTo(size.width * 0.25, size.height * 0.5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
