"""
Script para inicializar la base de datos y crear datos de prueba
Configurado según las especificaciones del proyecto SmartFloors
"""
from app.database import engine, SessionLocal, Base
from app.models import SensorData, Alert
from datetime import datetime, timedelta
import random

def init_database():
    """Crear todas las tablas"""
    print("🔧 Creando tablas en la base de datos...")
    try:
        Base.metadata.create_all(bind=engine)
        print("✅ Tablas creadas exitosamente")
        return True
    except Exception as e:
        print(f"❌ Error al crear tablas: {e}")
        return False


def clear_database():
    """Limpiar todos los datos de las tablas (opcional)"""
    db = SessionLocal()
    try:
        print("🗑  Limpiando datos existentes...")
        db.query(Alert).delete()
        db.query(SensorData).delete()
        db.commit()
        print("✅ Datos limpiados exitosamente")
    except Exception as e:
        print(f"❌ Error al limpiar datos: {e}")
        db.rollback()
    finally:
        db.close()


def create_sample_data():
    """Crear datos de ejemplo realistas para testing"""
    db = SessionLocal()
    
    print("\n📊 Creando datos de ejemplo...")
    
    try:
        # Generar datos simulados para los últimos 120 minutos (2 horas)
        now = datetime.utcnow()
        
        for i in range(120):
            timestamp = now - timedelta(minutes=120-i)
            
            for piso in [1, 2, 3]:
                # Simular patrones realistas por piso
                # Piso 1: Más fresco, menor consumo
                # Piso 2: Temperatura media
                # Piso 3: Más caliente (techo), mayor consumo
                
                # Temperatura: varía con el tiempo y por piso
                hora_del_dia = (timestamp.hour + timestamp.minute / 60)
                factor_tiempo = abs(hora_del_dia - 14) / 14  # Pico a las 2 PM
                
                base_temp = 24 + (piso * 1.5) - (factor_tiempo * 3)
                base_temp += random.uniform(-1.5, 1.5)  # Variación aleatoria
                
                # Agregar tendencia de calentamiento al piso 3 para generar alertas
                if piso == 3 and i > 60:
                    base_temp += (i - 60) * 0.05  # Calentamiento gradual
                
                # Humedad: inversamente proporcional a temperatura
                base_humedad = 60 - (base_temp - 24) * 2
                base_humedad += random.uniform(-8, 8)
                base_humedad = max(15, min(85, base_humedad))  # Limitar entre 15-85%
                
                # Energía: correlacionada con temperatura y piso
                base_energia = 3 + (piso * 1.2)
                if base_temp > 26:
                    base_energia += (base_temp - 26) * 0.5  # Más AC = más consumo
                base_energia += random.uniform(-0.5, 0.5)
                
                # Simular pico de energía en piso 3
                if piso == 3 and i > 90:
                    base_energia += (i - 90) * 0.08
                
                sensor_data = SensorData(
                    timestamp=timestamp,
                    edificio="A",
                    piso=piso,
                    temp_c=round(base_temp, 1),
                    humedad_pct=round(base_humedad, 1),
                    energia_kw=round(base_energia, 2)
                )
                db.add(sensor_data)
        
        # Crear alertas de ejemplo según los umbrales
        alerts = [
            Alert(
                timestamp=now - timedelta(minutes=45),
                edificio="A",
                piso=2,
                tipo="temperatura",
                severidad="medium",
                mensaje="Predicción: temp_c alcanzará 28.5°C en 60 min",
                recomendacion="⚠ MEDIA: Temperatura alcanzará 28.5°C (rango 28-29.4°C); Ajustar termostato en los próximos 15 minutos",
                resuelta=False
            ),
            Alert(
                timestamp=now - timedelta(minutes=30),
                edificio="A",
                piso=3,
                tipo="energia",
                severidad="high",
                mensaje="Predicción: energia_kw alcanzará 10.8 kW en 60 min",
                recomendacion="⚠ CRÍTICO: Consumo alcanzará 10.8 kW (>10 kW); Redistribuir carga eléctrica a otros pisos inmediatamente",
                resuelta=False
            ),
            Alert(
                timestamp=now - timedelta(minutes=20),
                edificio="A",
                piso=3,
                tipo="temperatura",
                severidad="high",
                mensaje="Predicción: temp_c alcanzará 29.8°C en 60 min",
                recomendacion="⚠ CRÍTICO: Temperatura alcanzará 29.8°C (umbral ≥29.5°C); Incrementar aire acondicionado inmediatamente",
                resuelta=False
            ),
            Alert(
                timestamp=now - timedelta(minutes=15),
                edificio="A",
                piso=1,
                tipo="humedad_pct",
                severidad="medium",
                mensaje="Predicción: humedad_pct alcanzará 23.5% en 60 min",
                recomendacion="⚠ MEDIA: Humedad bajará a 23.5% (22-25%); Considerar humidificadores",
                resuelta=False
            ),
            Alert(
                timestamp=now - timedelta(hours=2),
                edificio="A",
                piso=2,
                tipo="temperatura",
                severidad="low",
                mensaje="Predicción: temp_c alcanzará 27.2°C en 60 min",
                recomendacion="ℹ Temperatura alcanzará 27.2°C (rango 26-27.9°C); Monitorear evolución de temperatura",
                resuelta=True
            )
        ]
        
        for alert in alerts:
            db.add(alert)
        
        db.commit()
        print(f"✅ Creados {120 * 3} registros de sensores (3 pisos × 120 minutos)")
        print(f"✅ Creadas {len(alerts)} alertas de ejemplo")
        print(f"   - {sum(1 for a in alerts if not a.resuelta)} alertas activas")
        print(f"   - {sum(1 for a in alerts if a.resuelta)} alertas resueltas")
        
        return True
        
    except Exception as e:
        print(f"❌ Error al crear datos: {e}")
        db.rollback()
        return False
    finally:
        db.close()


def show_database_info():
    """Mostrar información sobre los datos en la base de datos"""
    db = SessionLocal()
    
    try:
        sensor_count = db.query(SensorData).count()
        alert_count = db.query(Alert).count()
        active_alerts = db.query(Alert).filter(Alert.resuelta == False).count()
        
        print("\n📈 Estado de la Base de Datos:")
        print(f"   - Registros de sensores: {sensor_count}")
        print(f"   - Total de alertas: {alert_count}")
        print(f"   - Alertas activas: {active_alerts}")
        
        if sensor_count > 0:
            latest = db.query(SensorData).order_by(SensorData.timestamp.desc()).first()
            print(f"\n   📍 Último registro:")
            print(f"      Edificio {latest.edificio}, Piso {latest.piso}")
            print(f"      Temperatura: {latest.temp_c}°C")
            print(f"      Humedad: {latest.humedad_pct}%")
            print(f"      Energía: {latest.energia_kw} kW")
            print(f"      Timestamp: {latest.timestamp}")
        
    except Exception as e:
        print(f"❌ Error al mostrar información: {e}")
    finally:
        db.close()


if __name__ == "__main__":
    print("=" * 60)
    print("   🏢 Inicialización de Base de Datos SmartFloors")
    print("=" * 60)
    
    # Crear tablas
    if not init_database():
        print("\n❌ No se pudieron crear las tablas. Verifica tu conexión.")
        exit(1)
    
    # Preguntar si quiere limpiar datos existentes
    print("\n¿Deseas limpiar los datos existentes antes de crear nuevos?")
    print("  [s] Sí, borrar todo y empezar de cero")
    print("  [n] No, mantener datos existentes")
    respuesta_limpiar = input("\nTu respuesta (s/n): ").strip().lower()
    
    if respuesta_limpiar == 's':
        clear_database()
    
    # Crear datos de ejemplo
    print("\n¿Deseas crear datos de ejemplo?")
    print("  [s] Sí, crear datos de ejemplo (recomendado)")
    print("  [n] No, solo crear las tablas")
    respuesta = input("\nTu respuesta (s/n): ").strip().lower()
    
    if respuesta == 's':
        if create_sample_data():
            show_database_info()
        else:
            print("\n❌ Error al crear datos de ejemplo")
            exit(1)
    
    print("\n" + "=" * 60)
    print("✅ Inicialización completada!")
    print("=" * 60)
    print("\n🚀 Siguiente paso:")
    print("   Inicia el servidor con: uvicorn app.main:app --reload")
    print("\n📚 Luego abre la documentación en:")
    print("   http://localhost:8000/docs")
    print("=" * 60)