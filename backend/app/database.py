from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Obtener URL de la base de datos desde env var DATABASE_URL.
# Ejemplo (Aiven):
# postgres://user:password@host:port/dbname?sslmode=require
DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise ValueError("⚠️ DATABASE_URL no está configurada en el archivo .env o variables de entorno")

# Configurar parámetros SSL para conexión segura (Aiven requiere SSL)
# La URL ya debe incluir ?sslmode=require
connect_args = {}

# Si se proporciona un certificado CA (para proveedores que lo requieren)
CA_CERT_PATH = os.getenv("DB_CA_CERT_PATH")
if CA_CERT_PATH and os.path.exists(CA_CERT_PATH):
    connect_args["sslmode"] = "require"
    connect_args["sslrootcert"] = CA_CERT_PATH
    print(f"✅ Usando certificado CA: {CA_CERT_PATH}")
elif "sslmode=require" in DATABASE_URL:
    # Aiven y otros proveedores modernos no necesitan cert explícito
    # Solo verifican vía SSL estándar
    print("✅ SSL habilitado (modo require)")

# Crear engine con configuración para PostgreSQL remoto
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,      # Verifica conexiones antes de usar
    pool_recycle=3600,       # Recicla conexiones cada hora
    echo=False,              # No imprimir SQL queries (cambiar a True para debug)
    connect_args=connect_args if connect_args else {}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    """Dependency para obtener la sesión de base de datos"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
