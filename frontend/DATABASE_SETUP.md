# Conexión a Base de Datos PostgreSQL

Este documento describe la integración de la aplicación EcoMonitor con PostgreSQL para mostrar alertas en tiempo real.

## Configuración de la Base de Datos

### Credenciales
- **Host**: practica-anfehumu.i.aivencloud.com
- **Puerto**: 15276
- **Base de Datos**: defaultdb
- **Usuario**: avnadmin
- **SSL**: Requerido

### Estructura de la Tabla

La tabla `alerts` tiene la siguiente estructura:

```sql
CREATE TABLE alerts (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    piso VARCHAR(50) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    severidad VARCHAR(50) NOT NULL,
    recomendacion TEXT NOT NULL
);
```

## Características Implementadas

### 1. Modelo de Datos
- **Archivo**: `lib/models/alert_model.dart`
- Mapeo de datos desde PostgreSQL a objetos Dart
- Manejo de tipos de datos (DateTime, String)

### 2. Servicio de Base de Datos
- **Archivo**: `lib/services/database_service.dart`
- Singleton para gestionar una única conexión
- Métodos implementados:
  - `connect()`: Establece conexión con PostgreSQL
  - `disconnect()`: Cierra la conexión
  - `getAlerts()`: Obtiene alertas con filtros opcionales
  - `getUniquePisos()`: Obtiene lista de pisos únicos
  - `getUniqueTipos()`: Obtiene lista de tipos de variables
  - `getUniqueSeveridades()`: Obtiene lista de niveles de severidad

### 3. Interfaz de Usuario

La tabla de alertas (`lib/widgets/alerts_table.dart`) incluye:

#### Filtros Interactivos
- **Filtro por Piso**: Permite filtrar alertas por piso específico
- **Filtro por Variable**: Filtra por tipo de variable (Temperatura, Humedad, Energía, etc.)
- **Filtro por Severidad**: Filtra por nivel de alerta (Crítico, Alto, Medio, Bajo, OK, Informativo)

#### Funcionalidades
- **Carga Automática**: Los datos se cargan automáticamente al iniciar
- **Botón Actualizar**: Recarga los datos desde la base de datos
- **Botón Limpiar Filtros**: Reinicia todos los filtros a "Todos"
- **Indicadores de Estado**: Muestra cargando, errores o datos
- **Colores por Severidad**:
  - Crítico: Rojo
  - Alto: Naranja
  - Medio: Amarillo
  - Bajo/Informativo: Azul
  - OK: Verde

### 4. Manejo de Errores

- Reconexión automática si la conexión se cierra
- Mensajes de error descriptivos en la UI
- Botón de reintento en caso de error
- Logging en consola para debugging

## Uso

### Filtrar Alertas

1. Selecciona un valor en cualquiera de los filtros (Piso, Variable, Severidad)
2. Los datos se actualizan automáticamente
3. Puedes combinar múltiples filtros
4. Usa "Limpiar Filtros" para resetear

### Actualizar Datos

- Haz clic en el botón "Actualizar" para recargar desde la base de datos
- Los datos se limitan a las últimas 100 alertas

## Dependencias

```yaml
dependencies:
  postgres: ^2.6.2  # Cliente PostgreSQL
  intl: ^0.18.1     # Formateo de fechas
```

## Ejemplo de Consulta SQL

```sql
-- Obtener alertas de un piso específico
SELECT timestamp, piso, tipo, severidad, recomendacion 
FROM alerts 
WHERE piso = 'Piso 2' 
ORDER BY timestamp DESC 
LIMIT 100;

-- Obtener alertas críticas
SELECT timestamp, piso, tipo, severidad, recomendacion 
FROM alerts 
WHERE severidad = 'Crítico' 
ORDER BY timestamp DESC 
LIMIT 100;
```

## Seguridad

⚠️ **IMPORTANTE**: Las credenciales de la base de datos están hardcodeadas en el archivo de servicio. Para producción, considera:

1. Usar variables de entorno
2. Implementar un backend intermedio
3. Usar servicios de secretos (como AWS Secrets Manager, Google Secret Manager)
4. Implementar autenticación y autorización adecuadas

## Troubleshooting

### Error de Conexión SSL
Si hay problemas con SSL, verifica que el servidor PostgreSQL esté configurado correctamente con certificados válidos.

### Tabla no existe
Ejecuta el script `database/schema.sql` en tu base de datos PostgreSQL para crear la tabla y los índices necesarios.

### Sin Datos
Asegúrate de que la tabla `alerts` contenga datos. Puedes usar los datos de ejemplo del archivo `schema.sql`.
