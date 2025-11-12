import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import '../services/database_service.dart';

class ConnectionDebugWidget extends StatefulWidget {
  const ConnectionDebugWidget({super.key});

  @override
  State<ConnectionDebugWidget> createState() => _ConnectionDebugWidgetState();
}

class _ConnectionDebugWidgetState extends State<ConnectionDebugWidget> {
  String _status = 'No probado';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _status = 'Probando...';
    });

    try {
      await DatabaseService().connect();
      setState(() {
        _status = '✅ Conexión exitosa';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error de conexión';
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _getPlatformInfo() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF1a5555),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🔧 Diagnóstico de Conexión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Plataforma:', _getPlatformInfo()),
            _buildInfoRow('Backend URL:', DatabaseService.getBaseUrl()),
            _buildInfoRow('Estado:', _status),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Error: $_errorMessage',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _testConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ecca3),
                  foregroundColor: Colors.black,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Text('Probar Conexión'),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Si falla la conexión:',
              style: TextStyle(
                color: Color(0xFF4ecca3),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            _buildTip('• Verifica que el backend esté corriendo'),
            _buildTip('• Android Emulador: usa 10.0.2.2:8000'),
            _buildTip('• Dispositivo físico: usa la IP de tu PC'),
            _buildTip('• Ambos deben estar en la misma red WiFi'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4ecca3),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 2),
      child: Text(
        tip,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
        ),
      ),
    );
  }
}
