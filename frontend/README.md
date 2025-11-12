# EcoMonitor Flutter App

Una aplicación Flutter que replica el diseño del dashboard EcoMonitor para monitoreo ambiental de edificios.

## Características

- ✅ Header con navegación y perfil
- ✅ Resumen de pisos con estados
- ✅ Análisis de tendencias con gráficos (Temperatura, Humedad, Energía)
- ✅ Sección de alertas con filtros
- ✅ Tabla de alertas con datos históricos
- ✅ Diseño responsivo oscuro

## Requisitos

- Flutter SDK 3.0.0 o superior
- Dart 3.0.0 o superior

## Instalación

1. Asegúrate de tener Flutter instalado:
```bash
flutter --version
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada de la aplicación
├── screens/
│   └── home_screen.dart              # Pantalla principal
└── widgets/
    ├── app_header.dart               # Header con navegación
    ├── floor_summary_section.dart    # Resumen de pisos
    ├── trend_analysis_section.dart   # Sección de análisis
    ├── trend_chart_card.dart         # Tarjetas con gráficos
    ├── alerts_section.dart           # Filtros de alertas
    └── alerts_table.dart             # Tabla de alertas
```

## Dependencias

- `fl_chart`: Para renderizar los gráficos de tendencias
- `cupertino_icons`: Iconos de iOS

## Colores del Tema

- Background: `#1a1b18`
- Surface: `#272924`
- Border: `#373932` / `#4e5247`
- Text Primary: `#FFFFFF`
- Text Secondary: `#afb3a8`
- Status OK: `#A3B087`
- Status Warning: Orange 400
- Status Critical: Red 500

## Para Desarrollo Web

```bash
flutter run -d chrome
```

## Para Build de Producción

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# Windows
flutter build windows

# macOS
flutter build macos
```

## Personalización

Para modificar los datos de ejemplo, edita los archivos en `lib/widgets/` donde se encuentran los datos hardcodeados de las tarjetas y la tabla.

## Licencia

Este proyecto es una implementación de ejemplo con fines educativos.
