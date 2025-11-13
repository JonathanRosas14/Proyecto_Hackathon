# 📱 MANUAL DE USUARIO - SmartFloors

> **Guía para usuarios: Cómo instalar y usar SmartFloors en tu computadora**

**Versión**: 1.0  
**Fecha**: Noviembre 2025

---

## 👋 Bienvenido a SmartFloors

Este manual te enseña paso a paso cómo instalar y usar SmartFloors en tu computadora, sin necesidad de conocimientos técnicos avanzados.

---

## ¿Qué es SmartFloors?

SmartFloors es una aplicación que te ayuda a:

| Función | Descripción |
|---------|-------------|
| 📊 **Monitorear** | Ver temperatura, humedad y consumo de energía en tiempo real |
| 🚨 **Alertar** | Recibir notificaciones cuando algo no está bien |
| 🤖 **Predecir** | Saber qué problemas pueden ocurrir en la próxima hora |
| 📈 **Analizar** | Ver gráficas y tendencias históricas |
| 💡 **Recomendar** | Obtener sugerencias automáticas para resolver problemas |

---

## 🌐 ¿VERSIÓN ONLINE? (La Forma Más Rápida)

Si **NO quieres instalar nada**, puedes usar SmartFloors directamente en línea:

👉 **[Ir a SmartFloors Online](https://proyecto-hackathon-b1gg.onrender.com/)** ← **Click aquí para abrir**

✅ **Solo necesitas**:
- Conexión a Internet
- Un navegador (Chrome, Firefox, Safari, Edge)

⏱️ **Tiempo**: ¡0 minutos de instalación!

---

## 📋 Requisitos (Lo que Necesitas)

### Para Windows, Mac o Linux

**Necesitas descargar e instalar**:

1. **Python** (Lenguaje de programación)
   - Descarga: [python.org/downloads](https://www.python.org/downloads/)
   - Versión mínima: **3.11**
   - ⏱️ Tiempo de instalación: 5 minutos

2. **Flutter** (Para la aplicación móvil)
   - Descarga: [flutter.dev/get-started](https://flutter.dev/docs/get-started/install)
   - Versión mínima: **3.0**
   - ⏱️ Tiempo de instalación: 10 minutos

3. **Git** (Para descargar el código)
   - Descarga: [git-scm.com/download](https://git-scm.com/download/win)
   - Versión mínima: **2.25**
   - ⏱️ Tiempo de instalación: 3 minutos

**Total de instalaciones**: ~18 minutos

### ¿Cómo Verificar que Está Instalado?

Abre una terminal (Símbolo del Sistema en Windows, Terminal en Mac/Linux) y escribe:

```bash
python --version
flutter --version
git --version
```

Si ves versiones sin errores, ¡estás listo!

---

## 🚀 Instalación en 4 Pasos

### Paso 1: Descargar el Código

1. Abre una terminal
2. Copia y pega esto:

```bash
git clone https://github.com/JonathanRosas14/Proyecto_Hackathon.git
cd Proyecto_Hackathon
```

**¿Qué hace?** Descarga el código de SmartFloors en tu computadora.

### Paso 2: Configurar la Base de Datos

1. Abre una terminal
2. Ve a la carpeta `backend`:

```bash
cd backend
```

3. Crea un archivo llamado `.env` (sin extensión)
   - En **Windows**: Click derecho → Nuevo → Documento de texto → Renombra a `.env`
   - En **Mac/Linux**: Abre un editor de texto

4. Copia este contenido en el archivo `.env`:

```env
DATABASE_URL=postgres://avnadmin:PASSWORD@practica-anfehumu.i.aivencloud.com:15276/defaultdb?sslmode=require
PYTHONUNBUFFERED=1
```

5. **Guarda el archivo** en la carpeta `backend`

**¿Qué hace?** Conecta tu aplicación a la base de datos en la nube.

### Paso 3: Instalar las Dependencias del Backend

Sigue estas instrucciones según tu sistema operativo:

#### En Windows:

```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python init_db.py
```

#### En Mac/Linux:

```bash
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python init_db.py
```

**¿Qué hace?** Instala todo lo que necesita el servidor de la aplicación.

**Resultado esperado**:
```
✅ Tablas creadas exitosamente
✅ Datos de ejemplo creados
```

### Paso 4: Instalar las Dependencias del Frontend

Abre **otra terminal** (sin cerrar la anterior) y ejecuta:

```bash
cd frontend
flutter pub get
```

**¿Qué hace?** Descarga todo lo que necesita la interfaz de usuario.

---

## ▶️ Ejecutar la Aplicación

### Paso 1: Iniciar el Servidor (Backend)

En la **primera terminal**, asegúrate de estar en la carpeta `backend` y ejecuta:

```bash
python -m uvicorn app.main:app --reload
```

**Esperado ver**:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete
```

✅ **El servidor está corriendo** - No cierres esta terminal

### Paso 2: Iniciar la Aplicación (Frontend)

En la **segunda terminal**, asegúrate de estar en la carpeta `frontend` y ejecuta:

```bash
flutter run -d chrome
```

**Esperado ver**:
```
Flutter web app compiled to web/.
Serving on http://localhost:5000
```

✅ **La aplicación está corriendo**

### Paso 3: Abrir en tu Navegador

Tu navegador debería abrir automáticamente. Si no, abre manualmente:

```
http://localhost:5000
```

---

## 🎮 Usando la Aplicación

### Pantalla Principal

Cuando abras SmartFloors, verás:

```
┌─────────────────────────────────────┐
│   SmartFloors - Dashboard           │
├─────────────────────────────────────┤
│                                     │
│  🏢 RESUMEN DE PISOS                │
│  ┌─────────┐ ┌─────────┐ ┌───────┐ │
│  │ Piso 1  │ │ Piso 2  │ │ Piso 3│ │
│  │ 22.5°C  │ │ 24.1°C  │ │ 21°C  │ │
│  │ 55% HR  │ │ 60% HR  │ │ 52%HR │ │
│  └─────────┘ └─────────┘ └───────┘ │
│                                     │
│  🚨 ALERTAS ACTIVAS                 │
│  ├─ Temperatura alta (Piso 2)       │
│  ├─ Humedad elevada (Piso 1)        │
│  └─ Consumo energético alto (Piso 3)│
│                                     │
│  📈 GRÁFICAS DE TENDENCIAS          │
│  ├─ Temperatura (Últimas 24h)       │
│  ├─ Humedad (Últimas 24h)           │
│  └─ Energía (Últimas 24h)           │
│                                     │
└─────────────────────────────────────┘
```

### Secciones Principales

#### 1. Resumen de Pisos
- Muestra estado general de cada piso
- Haz click en un piso para ver detalles
- Cada tarjeta muestra:
  - 🌡️ Temperatura actual
  - 💨 Humedad relativa
  - ⚡ Consumo de energía

#### 2. Alertas Activas
- Muestra problemas detectados automáticamente
- Código de colores:
  - 🟢 **Verde** = Sin problemas (Severidad Baja)
  - 🟡 **Amarillo** = Advertencia (Severidad Media)
  - 🔴 **Rojo** = Problema (Severidad Alta)

- Haz click en una alerta para ver:
  - 📝 Descripción del problema
  - 💡 Recomendación para resolverlo
  - 🕐 Hora de la alerta

#### 3. Gráficas de Tendencias
- Muestra histórico de los últimos datos
- Cada gráfica tiene:
  - 📊 Línea de valores históricos
  - 📈 Línea de tendencia (predicción)
  - 🔢 Valores mín/máx/promedio

---

## 🎯 Tareas Comunes

### Ver Alertas de un Piso Específico

1. Haz click en el nombre del piso
2. La tabla de alertas se actualiza automáticamente
3. Verás solo las alertas de ese piso

### Buscar una Alerta Específica

1. Desplázate a la sección "Alertas"
2. Usa los filtros:
   - **Por Piso**: Selecciona el piso
   - **Por Severidad**: Selecciona el nivel
3. La tabla se actualiza en tiempo real

### Entender una Recomendación

Cuando veas una alerta con recomendación:

```
🔴 ALERTA ALTA: Temperatura elevada en Piso 2

Descripción: La temperatura subió a 28°C

Recomendación: Incrementar ventilación o aire acondicionado

Acción: Abre puertas o ventanas para ventilar
```

### Ver Predicción de Problemas

En las gráficas de tendencias, verás dos líneas:
- **Línea sólida** = Datos históricos (Lo que pasó)
- **Línea punteada** = Predicción (Lo que va a pasar)

Si la línea punteada sube/baja hacia valores malos, SmartFloors te avisa.

---

## ❓ Preguntas Frecuentes

### ¿Qué significan los números?

| Rango | Temperatura | Humedad | Consumo Energía |
|-------|-------------|---------|-----------------|
| 🟢 Normal | 18-26°C | 30-60% | < 8 kW |
| 🟡 Advertencia | 15-18 o 26-28°C | 20-30 o 60-70% | 8-10 kW |
| 🔴 Problema | < 15 o > 28°C | < 20 o > 70% | > 10 kW |

### ¿Por qué aparece una alerta?

SmartFloors detecta alertas cuando:
- Temperatura fuera del rango cómodo
- Humedad muy baja o muy alta
- Consumo de energía elevado
- Cambios bruscos en los valores

### ¿Los datos se actualizan automáticamente?

Sí, cada 10 segundos:
- Se actualizan las alertas
- Se actualiza la tabla
- Se actualizan las gráficas

### ¿Puedo dejar la aplicación corriendo?

Sí, puedes:
- Dejar ambas terminales abiertas
- Mantener el navegador abierto
- La app monitorea 24/7

### ¿Cómo cierro la aplicación?

En las terminales, presiona:

```
Ctrl + C
```

Aparecerá el mensaje:
```
INFO:     Shutting down
```

Luego cierra el navegador.

---

## 🚨 Solución de Problemas

### Error: "No se puede conectar a la base de datos"

**Causa**: El archivo `.env` no está configurado correctamente

**Solución**:
1. Verifica que `.env` está en la carpeta `backend/`
2. Verifica que el contenido es exacto (sin espacios extra)
3. Verifica que tiene las líneas:
   ```
   DATABASE_URL=postgres://...
   PYTHONUNBUFFERED=1
   ```

### Error: "Puerto 8000 ya está en uso"

**Causa**: Otra aplicación está usando el puerto 8000

**Solución**:
1. Cierra otras aplicaciones que usen ese puerto
2. O usa otro puerto:
   ```bash
   python -m uvicorn app.main:app --port 8001 --reload
   ```

### Error: "flutter command not found"

**Causa**: Flutter no está en el PATH del sistema

**Solución**:
1. Reinstala Flutter (asegúrate de agregar al PATH)
2. O usa la ruta completa a Flutter:
   ```bash
   /ruta/a/flutter/bin/flutter run -d chrome
   ```

### Error: "Chrome not found"

**Causa**: Chrome no está instalado

**Solución**:
1. Instala Google Chrome
2. O ejecuta en otro dispositivo:
   ```bash
   flutter run  # Sin -d chrome
   ```

### La aplicación no muestra datos

**Causa**: Posiblemente el servidor no está listo

**Solución**:
1. Espera 3-5 segundos después de abrir
2. Presiona F5 (Recargar) en el navegador
3. Verifica que el servidor de backend está ejecutándose

### La aplicación se ve rara en el móvil

**Causa**: Pantalla de diferente tamaño

**Solución**:
- SmartFloors se adapta automáticamente
- Gira el móvil entre vertical y horizontal
- Ajusta el zoom del navegador

---

## 🎓 Próximos Pasos

Una vez que todo esté funcionando:

1. **Explora la interfaz**: Haz click en diferentes secciones
2. **Lee las alertas**: Entiende qué problemas se detectan
3. **Analiza las gráficas**: Observa tendencias
4. **Aprende las recomendaciones**: Cómo resolver cada problema

---

## 📞 Necesitas Ayuda?

1. **Revisa esta sección**: [Solución de Problemas](#-solución-de-problemas)
2. **Verifica los requisitos**: [Requisitos](#-requisitos-lo-que-necesitas)
3. **Abre un Issue en GitHub**: [Issues](https://github.com/JonathanRosas14/Proyecto_Hackathon/issues)

---

## 📊 Tabla de Referencia Rápida

### Comandos Principales

```bash
# Descargar código
git clone https://github.com/JonathanRosas14/Proyecto_Hackathon.git

# Instalar backend
cd backend
pip install -r requirements.txt

# Ejecutar backend
python -m uvicorn app.main:app --reload

# Instalar frontend
cd frontend
flutter pub get

# Ejecutar frontend
flutter run -d chrome
```

### URLs Importantes

| URL | Uso |
|-----|-----|
| http://localhost:5000 | Aplicación principal |
| http://localhost:8000 | Servidor backend |
| http://localhost:8000/docs | Documentación API |
| http://localhost:8000/health | Estado del servidor |

### Atajos de Teclado

| Tecla | Función |
|-------|---------|
| R | Hot reload (flutter - recarga código) |
| Q | Salir de la aplicación (flutter) |
| Ctrl + C | Detener servidor |
| F5 | Recargar navegador |

---

## ✅ Checklist Final

Antes de usar la aplicación, verifica:

```
INSTALACIÓN:
  ☐ Python 3.11+ instalado
  ☐ Flutter 3.0+ instalado
  ☐ Git instalado
  ☐ Código descargado

CONFIGURACIÓN:
  ☐ Archivo .env creado en backend/
  ☐ DATABASE_URL configurada correctamente
  ☐ Backend instalado (pip install...)
  ☐ Frontend instalado (flutter pub get)

EJECUCIÓN:
  ☐ Base de datos inicializada (python init_db.py)
  ☐ Backend corriendo (python -m uvicorn...)
  ☐ Frontend corriendo (flutter run...)
  ☐ Navegador abierto en http://localhost:5000
  ☐ Datos visibles en la pantalla
```

---

## 🎉 ¡Listo!

Ahora tienes SmartFloors corriendo en tu computadora.

**Próximas acciones**:
1. Explora la interfaz
2. Entiende las alertas
3. Aprende a usar las gráficas
4. Usa las recomendaciones

---

**Manual de Usuario v1.0**  
Noviembre 2025  
Licencia MIT
