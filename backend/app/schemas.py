from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class SensorDataCreate(BaseModel):
    """Schema para crear datos de sensor"""
    edificio: str = Field(..., example="A")
    piso: int = Field(..., ge=1, le=3, example=1)
    temp_c: float = Field(..., example=22.5)
    humedad_pct: float = Field(..., ge=0, le=100, example=55.0)
    energia_kw: float = Field(..., ge=0, example=5.2)


class SensorDataResponse(BaseModel):
    """Schema para respuesta de datos de sensor"""
    id: int
    timestamp: datetime
    edificio: str
    piso: int
    temp_c: float
    humedad_pct: float
    energia_kw: float

    class Config:
        from_attributes = True


class AlertCreate(BaseModel):
    """Schema para crear alertas"""
    edificio: str
    piso: int
    tipo: str
    severidad: str
    mensaje: str
    recomendacion: Optional[str] = None


class AlertResponse(BaseModel):
    """Schema para respuesta de alertas"""
    id: int
    timestamp: datetime
    edificio: str
    piso: int
    tipo: str
    severidad: str
    mensaje: str
    recomendacion: Optional[str]
    resuelta: bool

    class Config:
        from_attributes = True


class PredictionResponse(BaseModel):
    """Schema para respuestas de predicción"""
    piso: int
    variable: str
    prediccion_60min: float
    riesgo: str
    recomendaciones: list[str]