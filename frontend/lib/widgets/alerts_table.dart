import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alert_model.dart';
import '../services/database_service.dart';

class AlertsTable extends StatefulWidget {
  final String? pisoFilter;
  final String? severidadFilter;

  const AlertsTable({
    super.key,
    this.pisoFilter,
    this.severidadFilter,
  });

  @override
  State<AlertsTable> createState() => _AlertsTableState();
}

class _AlertsTableState extends State<AlertsTable> {
  final DatabaseService _dbService = DatabaseService();
  List<AlertModel> _alerts = [];

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  @override
  void didUpdateWidget(AlertsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pisoFilter != widget.pisoFilter ||
        oldWidget.severidadFilter != widget.severidadFilter) {
      _loadAlerts();
    }
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final alerts = await _dbService.getAlerts(
        pisoFilter: widget.pisoFilter,
        tipoFilter: null, // No filtramos por tipo
        severidadFilter: widget.severidadFilter,
      );

      setState(() {
        _alerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar alertas: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1a5555)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF0d3d3d),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      color: Color(0xFF4ecca3),
                    ),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadAlerts,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: screenWidth > 600 ? screenWidth - 64 : 600,
                        ),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            const Color(0xFF1a5555),
                          ),
                          dataRowColor: MaterialStateProperty.all(
                            const Color(0xFF0d3d3d),
                          ),
                          dividerThickness: 1,
                          columnSpacing: screenWidth > 900 ? 56 : 24,
                          columns: const [
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  'Fecha y Hora',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  'Piso',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  'Variable',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  'Nivel de Alerta',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  'Recomendación',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          rows: _alerts
                              .map((alert) => _buildDataRow(alert))
                              .toList(),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(AlertModel alert) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return DataRow(
      cells: [
        DataCell(
          Text(
            dateFormat.format(alert.timestamp),
            style: const TextStyle(
              color: Color(0xFF93c5c5),
              fontSize: 14,
            ),
          ),
        ),
        DataCell(
          Text(
            alert.piso,
            style: const TextStyle(
              color: Color(0xFF93c5c5),
              fontSize: 14,
            ),
          ),
        ),
        DataCell(
          Text(
            alert.tipo,
            style: const TextStyle(
              color: Color(0xFF93c5c5),
              fontSize: 14,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getSeverityColor(alert.severidad),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alert.severidad,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            alert.recomendacion,
            style: const TextStyle(
              color: Color(0xFF93c5c5),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severidad) {
    switch (severidad.toLowerCase()) {
      case 'crítico':
      case 'critico':
      case 'critical':
        return Colors.red.shade700;
      case 'alto':
      case 'high':
        return Colors.orange.shade700;
      case 'medio':
      case 'medium':
        return Colors.yellow.shade700;
      case 'bajo':
      case 'low':
      case 'informativo':
        return Colors.blue.shade700;
      case 'ok':
        return Colors.green.shade700;
      default:
        return const Color(0xFF1a5555);
    }
  }
}
