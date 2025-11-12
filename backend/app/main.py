from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List, Optional

from app.database import engine, get_db, Base
from app import models, schemas, crud
from app.ml_predictor import SimplePredictor

# Crear tablas en la base de datos
Base.metadata.create_all(bind=engine)

# Inicializar FastAPI
app = FastAPI(
    title="SmartFloors API",
    description="API para monitoreo y alertas de edificios multi-piso",
    version="1.0.0"
)

# Configurar CORS para permitir peticiones desde Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especifica el dominio de Flutter
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inicializar predictor
predictor = SimplePredictor()


# ========== ENDPOINTS ==========

@app.get("/")
def root():
    """Endpoint raíz"""
    return {
        "message": "SmartFloors API",
        "version": "1.0.0",
        "docs": "/docs"
    }


@app.get("/health")
def health_check():
    """Verificar estado del servicio"""
    return {"status": "healthy", "timestamp": "2024-01-01T00:00:00"}


# ========== SENSOR DATA ENDPOINTS ==========

@app.post("/sensor-data/", response_model=schemas.SensorDataResponse)
def create_sensor_reading(
    data: schemas.SensorDataCreate,
    db: Session = Depends(get_db)
):
    """Registrar nueva lectura de sensores"""
    return crud.create_sensor_data(db, data)


@app.get("/sensor-data/", response_model=List[schemas.SensorDataResponse])
def get_sensor_readings(
    edificio: str = "A",
    piso: Optional[int] = None,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """Obtener lecturas de sensores"""
    return crud.get_sensor_data(db, edificio, piso, limit)


@app.get("/sensor-data/piso/{piso}", response_model=List[schemas.SensorDataResponse])
def get_sensor_by_floor(
    piso: int,
    edificio: str = "A",
    limit: int = 50,
    db: Session = Depends(get_db)
):
    """Obtener datos de un piso específico"""
    return crud.get_sensor_data(db, edificio, piso, limit)


# ========== PREDICTION ENDPOINTS ==========

@app.get("/predict/{piso}/{variable}")
def predict_variable(
    piso: int,
    variable: str,
    edificio: str = "A",
    db: Session = Depends(get_db)
):
    """
    Predecir valor de variable 60 minutos adelante
    Variables válidas: temp_c, humedad_pct, energia_kw
    """
    valid_variables = ["temp_c", "humedad_pct", "energia_kw"]
    
    if variable not in valid_variables:
        raise HTTPException(
            status_code=400,
            detail=f"Variable inválida. Use: {', '.join(valid_variables)}"
        )
    
    # Obtener datos históricos recientes
    historical_data = crud.get_recent_data_for_prediction(db, edificio, piso, 60)
    
    if not historical_data:
        raise HTTPException(
            status_code=404,
            detail="No hay datos suficientes para predicción"
        )
    
    # Convertir a diccionarios
    data_dicts = [
        {
            "timestamp": d.timestamp,
            "temp_c": d.temp_c,
            "humedad_pct": d.humedad_pct,
            "energia_kw": d.energia_kw
        }
        for d in historical_data
    ]
    
    # Realizar predicción
    prediction = predictor.predict(data_dicts, variable)
    
    # Crear alerta si hay riesgo alto
    if prediction["riesgo"] == "alto":
        alert = schemas.AlertCreate(
            edificio=edificio,
            piso=piso,
            tipo=variable,
            severidad="high",
            mensaje=f"Predicción de riesgo alto en {variable}",
            recomendacion="; ".join(prediction["recomendaciones"])
        )
        crud.create_alert(db, alert)
    
    return {
        "piso": piso,
        "variable": variable,
        **prediction
    }


# ========== ALERT ENDPOINTS ==========

@app.get("/alerts/", response_model=List[schemas.AlertResponse])
def get_alerts(
    edificio: str = "A",
    piso: Optional[int] = None,
    solo_activas: bool = True,
    db: Session = Depends(get_db)
):
    """Obtener alertas"""
    if solo_activas:
        return crud.get_active_alerts(db, edificio, piso)
    return crud.get_all_alerts(db, edificio)


@app.post("/alerts/", response_model=schemas.AlertResponse)
def create_alert(
    alert: schemas.AlertCreate,
    db: Session = Depends(get_db)
):
    """Crear nueva alerta"""
    return crud.create_alert(db, alert)


@app.put("/alerts/{alert_id}/resolver")
def resolve_alert(alert_id: int, db: Session = Depends(get_db)):
    """Marcar alerta como resuelta"""
    alert = crud.mark_alert_resolved(db, alert_id)
    if not alert:
        raise HTTPException(status_code=404, detail="Alerta no encontrada")
    return {"message": "Alerta resuelta", "alert_id": alert_id}


# ========== DASHBOARD ENDPOINT ==========

@app.get("/dashboard/{piso}")
def get_dashboard_data(
    piso: int,
    edificio: str = "A",
    db: Session = Depends(get_db)
):
    """Obtener todos los datos para el dashboard de un piso"""
    
    # Datos recientes
    recent_data = crud.get_sensor_data(db, edificio, piso, 1)
    
    # Alertas activas
    alerts = crud.get_active_alerts(db, edificio, piso)
    
    # Predicciones
    predictions = {}
    historical_data = crud.get_recent_data_for_prediction(db, edificio, piso, 60)
    
    if historical_data:
        data_dicts = [
            {
                "timestamp": d.timestamp,
                "temp_c": d.temp_c,
                "humedad_pct": d.humedad_pct,
                "energia_kw": d.energia_kw
            }
            for d in historical_data
        ]
        
        for var in ["temp_c", "humedad_pct", "energia_kw"]:
            predictions[var] = predictor.predict(data_dicts, var)
    
    return {
        "piso": piso,
        "edificio": edificio,
        "datos_actuales": recent_data[0] if recent_data else None,
        "alertas_activas": alerts,
        "predicciones": predictions
    }


if name == "main":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)