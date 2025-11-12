"""
Script para probar la conexión a la base de datos de Aiven
"""
import sys
sys.path.insert(0, '.')

try:
    print("🔄 Cargando configuración de base de datos...")
    from app.database import engine
    
    print("🔄 Intentando conectar a Aiven...")
    connection = engine.connect()
    
    print("✅ ¡Conexión exitosa a la base de datos de Aiven!")
    print(f"📊 Base de datos: {engine.url.database}")
    print(f"🌐 Host: {engine.url.host}")
    print(f"🔌 Puerto: {engine.url.port}")
    
    connection.close()
    print("✅ Conexión cerrada correctamente")
    
except Exception as e:
    print(f"❌ Error al conectar a la base de datos:")
    print(f"   {type(e).__name__}: {e}")
    sys.exit(1)
