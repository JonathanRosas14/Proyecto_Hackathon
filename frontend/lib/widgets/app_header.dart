import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

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
                  'Smartfloor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
            ],
          ),
          const Spacer(),
          // Navigation Links
          if (screenWidth > 700)
            Row(
              children: [
                _buildNavLink('Vista General'),
                const SizedBox(width: 36),
                _buildNavLink('Reportes'),
                const SizedBox(width: 36),
                _buildNavLink('Alertas'),
              ],
            )
          else
            // Menu icon para pantallas pequeñas
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () {
                  print('Menú clickeado');
                },
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String text) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          // Acción al hacer clic
          print('Navegando a $text');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
