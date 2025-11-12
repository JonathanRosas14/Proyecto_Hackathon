class AlertModel {
  final DateTime timestamp;
  final String piso;
  final String tipo;
  final String severidad;
  final String recomendacion;

  AlertModel({
    required this.timestamp,
    required this.piso,
    required this.tipo,
    required this.severidad,
    required this.recomendacion,
  });

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      timestamp: map['timestamp'] is DateTime
          ? map['timestamp']
          : DateTime.parse(map['timestamp'].toString()),
      piso: map['piso']?.toString() ?? '',
      tipo: map['tipo']?.toString() ?? '',
      severidad: map['severidad']?.toString() ?? '',
      recomendacion: map['recomendacion']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'piso': piso,
      'tipo': tipo,
      'severidad': severidad,
      'recomendacion': recomendacion,
    };
  }
}
