from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Obtener URL de la base de datos
DATABASE_URL = os.getenv("DATABASE_URL")

# Verificar que la URL existe
if not DATABASE_URL:
    raise ValueError("⚠️ DATABASE_URL no está configurada en el archivo .env")

# Crear engine con configuración para PostgreSQL en Aiven
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  
    pool_recycle=3600,   
    echo=False          
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
