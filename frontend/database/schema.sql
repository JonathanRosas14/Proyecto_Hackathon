-- Tabla de alertas para el sistema EcoMonitor
-- Este archivo es solo de referencia para documentar la estructura de la tabla

CREATE TABLE IF NOT EXISTS alerts (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    piso VARCHAR(50) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    severidad VARCHAR(50) NOT NULL,
    recomendacion TEXT NOT NULL
);

-- Índices para mejorar el rendimiento de las consultas
CREATE INDEX IF NOT EXISTS idx_alerts_timestamp ON alerts(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_alerts_piso ON alerts(piso);
CREATE INDEX IF NOT EXISTS idx_alerts_tipo ON alerts(tipo);
CREATE INDEX IF NOT EXISTS idx_alerts_severidad ON alerts(severidad);

-- Datos de ejemplo
INSERT INTO alerts (timestamp, piso, tipo, severidad, recomendacion) VALUES
    ('2024-01-26 14:30:00', 'Piso 2', 'Humedad', 'Informativo', 'Revisar sistema de ventilación'),
    ('2024-01-26 13:45:00', 'Piso 3', 'Energía', 'Medio', 'Reducir uso de energía no esencial'),
    ('2024-01-26 12:00:00', 'Piso 1', 'Temperatura', 'OK', 'No se requiere acción'),
    ('2024-01-26 11:15:00', 'Piso 2', 'Temperatura', 'Crítico', 'Revisión inmediata del sistema HVAC'),
    ('2024-01-26 10:30:00', 'Piso 3', 'Humedad', 'Informativo', 'Monitorear niveles de humedad');
