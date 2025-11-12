# 📱 Configuración para Dispositivos Móviles

## 🔌 Conexión del Frontend Mobile al Backend

La versión móvil necesita configuración especial porque `localhost` no funciona en dispositivos móviles.

### 🎯 Configuración Automática por Plataforma

El archivo `lib/main.dart` ahora detecta automáticamente la plataforma:

| Plataforma | URL por Defecto | Descripción |
|------------|-----------------|-------------|
| **Web** | `http://127.0.0.1:8000` | Funciona directamente |
| **Android Emulador** | `http://10.0.2.2:8000` | IP especial del emulador |
| **Android Físico** | `http://192.168.1.XXX:8000` | Necesitas tu IP local |
| **iOS Simulador** | `http://127.0.0.1:8000` | Funciona directamente |
| **iOS Físico** | `http://192.168.1.XXX:8000` | Necesitas tu IP local |
| **Windows/Desktop** | `http://127.0.0.1:8000` | Funciona directamente |

### 🔍 Obtener tu IP Local (para dispositivos físicos)

#### En Windows:
```bash
ipconfig
```
Busca la línea que dice "IPv4 Address" en tu red WiFi o Ethernet.
Ejemplo: `192.168.1.105`

#### En macOS/Linux:
```bash
ifconfig | grep "inet "
```
o
```bash
ip addr show
```

### ⚙️ Configurar para Dispositivo Físico

1. **Obtén tu IP local** (ejemplo: `192.168.1.105`)

2. **Edita `lib/main.dart`** y cambia las líneas:

```dart
// Para Android físico:
} else if (Platform.isAndroid) {
  backendUrl = 'http://192.168.1.105:8000'; // ← Tu IP aquí

// Para iOS físico:
} else if (Platform.isIOS) {
  backendUrl = 'http://192.168.1.105:8000'; // ← Tu IP aquí
```

3. **Asegúrate que el backend escuche en todas las interfaces:**

```bash
cd backend
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

⚠️ **Importante:** Cambia `--host 127.0.0.1` por `--host 0.0.0.0`

### 🔥 Firewall (Windows)

Si no conecta, permite el puerto 8000 en el firewall:

```powershell
# PowerShell como Administrador
New-NetFirewallRule -DisplayName "FastAPI Backend" -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Allow
```

### ✅ Verificar Conexión

1. **Desde tu teléfono**, abre el navegador y visita:
   ```
   http://TU_IP_LOCAL:8000/health
   ```
   Ejemplo: `http://192.168.1.105:8000/health`

2. Deberías ver:
   ```json
   {"status":"healthy","timestamp":"..."}
   ```

3. Si funciona, la app móvil también funcionará.

### 🚀 Ejecutar en Móvil

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Listar dispositivos disponibles
flutter devices
```

### 📊 Flujo de Datos

```
┌─────────────────┐
│  Teléfono/      │
│  Emulador       │
│  Flutter App    │
└────────┬────────┘
         │
         │ HTTP Request
         │ http://IP:8000
         ▼
┌─────────────────┐
│  Tu Computadora │
│  Backend        │
│  :8000          │
└────────┬────────┘
         │
         │ SQL/SSL
         ▼
┌─────────────────┐
│  Aiven Cloud    │
│  PostgreSQL     │
└─────────────────┘
```

### 🐛 Troubleshooting

#### Problema: "Connection refused"
- ✅ Verifica que el backend esté corriendo con `--host 0.0.0.0`
- ✅ Verifica que tu IP sea correcta
- ✅ Verifica el firewall

#### Problema: "Network unreachable"
- ✅ Asegúrate de estar en la misma red WiFi
- ✅ Desactiva temporalmente VPN

#### Problema: En emulador Android funciona, en físico no
- ✅ Cambia la URL en `main.dart` para dispositivo físico
- ✅ Usa tu IP local, no `10.0.2.2`

### 💡 Tip de Desarrollo

Para evitar cambiar código constantemente, puedes usar variables de entorno:

```dart
// main.dart
const String? customBackendUrl = String.fromEnvironment('BACKEND_URL');
if (customBackendUrl != null && customBackendUrl.isNotEmpty) {
  backendUrl = customBackendUrl;
}
```

Luego ejecuta:
```bash
flutter run --dart-define=BACKEND_URL=http://192.168.1.105:8000
```
