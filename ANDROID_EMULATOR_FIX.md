# 🔧 Solución para Android Emulador - Problema de Conexión

## 🚨 El Problema

El emulador Android no puede conectarse a `10.0.2.2:8000` aunque el backend esté corriendo.

## ✅ Solución: Configurar ADB Port Forwarding

### Método 1: ADB Reverse (Más Simple)

Ejecuta este comando en tu terminal:

```bash
adb reverse tcp:8000 tcp:8000
```

Luego, en tu app Flutter, cambia la URL a:

```dart
backendUrl = 'http://localhost:8000'; // Para emulador CON adb reverse
```

Edita `frontend/lib/main.dart` línea ~16:

```dart
} else if (Platform.isAndroid) {
  // Usando adb reverse
  backendUrl = 'http://localhost:8000';
```

### Método 2: Obtener IP del Host

**Windows:**
```bash
ipconfig
```
Busca tu IP WiFi/Ethernet: ejemplo `192.168.1.105`

Luego usa esa IP en la app:

```dart
} else if (Platform.isAndroid) {
  backendUrl = 'http://192.168.1.105:8000'; // Tu IP aquí
```

### Método 3: Verificar Conexión con ADB Shell

```bash
# Conectarte al emulador
adb shell

# Dentro del emulador, probar conexión
curl http://10.0.2.2:8000/health

# Si no funciona, probar con la IP del host
curl http://TU_IP:8000/health
```

## 🔍 Diagnóstico

### 1. Verificar que el backend está escuchando en todas las interfaces:

```bash
netstat -an | findstr :8000
```

Deberías ver:
```
TCP    0.0.0.0:8000          0.0.0.0:0              LISTENING
```

### 2. Verificar que el emulador está corriendo:

```bash
adb devices
```

### 3. Probar conectividad desde el emulador:

```bash
adb shell curl http://10.0.2.2:8000/health
```

## 🎯 Configuración Recomendada

### Paso 1: Editar `frontend/lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String backendUrl;

  if (kIsWeb) {
    backendUrl = 'http://127.0.0.1:8000';
  } else if (Platform.isAndroid) {
    // OPCIÓN A: Con adb reverse (recomendado para emulador)
    backendUrl = 'http://localhost:8000';
    
    // OPCIÓN B: Sin adb reverse
    // backendUrl = 'http://10.0.2.2:8000';
    
    // OPCIÓN C: Para dispositivo físico
    // backendUrl = 'http://192.168.1.XXX:8000';
  } else if (Platform.isIOS) {
    backendUrl = 'http://127.0.0.1:8000';
  } else {
    backendUrl = 'http://127.0.0.1:8000';
  }

  DatabaseService.setBaseUrl(backendUrl);
  print('🌐 Backend URL: $backendUrl');

  try {
    await DatabaseService().connect();
    print('✅ Conectado');
  } catch (e) {
    print('⚠️ No conectado: $e');
  }

  runApp(const EcoMonitorApp());
}
```

### Paso 2: Ejecutar adb reverse

```bash
adb reverse tcp:8000 tcp:8000
```

### Paso 3: Hot Restart la app Flutter

```bash
# En la terminal donde corre flutter
# Presiona 'R' para hot restart
```

## 🆘 Si Nada Funciona

### Última Opción: Usar ngrok

```bash
# Instalar ngrok
# Descargar de: https://ngrok.com/download

# Exponer el backend
ngrok http 8000
```

Ngrok te dará una URL como: `https://xxxx-xx-xx-xx-xxx.ngrok.io`

Usa esa URL en tu app:

```dart
backendUrl = 'https://xxxx-xx-xx-xx-xxx.ngrok.io';
```

## 📋 Checklist

- [ ] Backend corriendo con `--host 0.0.0.0`
- [ ] Emulador Android corriendo (`adb devices`)
- [ ] Ejecutado `adb reverse tcp:8000 tcp:8000`
- [ ] Cambiado URL a `http://localhost:8000` en main.dart
- [ ] Hot restart en Flutter (tecla 'R')
- [ ] Firewall permite puerto 8000

## 🔥 Comando Rápido

```bash
# Terminal 1: Backend
cd backend
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Terminal 2: ADB Reverse
adb reverse tcp:8000 tcp:8000

# Terminal 3: Flutter
cd frontend
flutter run
```
