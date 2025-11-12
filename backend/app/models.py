from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean
from sqlalchemy.sql import func
from app.database import Base

class SensorData(Base):
    """Modelo para almacenar datos de sensores por piso"""
    __tablename__ = "sensor_data"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now())
    edificio = Column(String, nullable=False, index=True)
    piso = Column(Integer, nullable=False, index=True)
    temp_c = Column(Float, nullable=False)
    humedad_pct = Column(Float, nullable=False)
    energia_kw = Column(Float, nullable=False)
    
    def __repr__(self):
        return f"<SensorData(edificio={self.edificio}, piso={self.piso}, temp={self.temp_c}°C)>"


class Alert(Base):
    """Modelo para almacenar alertas generadas"""
    __tablename__ = "alerts"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now())
    edificio = Column(String, nullable=False)
    piso = Column(Integer, nullable=False)
    tipo = Column(String, nullable=False)  # "temperatura", "humedad", "energia"
    severidad = Column(String, nullable=False)  # "low", "medium", "high"
    mensaje = Column(String, nullable=False)
    recomendacion = Column(String, nullable=True)
    resuelta = Column(Boolean, default=False)
    
    def __repr__(self):
        return f"<Alert(tipo={self.tipo}, piso={self.piso}, severidad={self.severidad})>"