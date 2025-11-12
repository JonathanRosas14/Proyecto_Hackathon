from sqlalchemy.orm import Session
from sqlalchemy import desc
from datetime import datetime, timedelta
from typing import List, Optional
from app import models, schemas

# ========== SENSOR DATA ==========

def create_sensor_data(db: Session, data: schemas.SensorDataCreate):
    """Crea un nuevo registro de datos de sensor"""
    db_data = models.SensorData(**data.model_dump())
    db.add(db_data)
    db.commit()
    db.refresh(db_data)
    return db_data


def get_sensor_data(
    db: Session,
    edificio: str = "A",
    piso: Optional[int] = None,
    limit: int = 100
) -> List[models.SensorData]:
    """Obtiene datos de sensores con filtros opcionales"""
    query = db.query(models.SensorData).filter(
        models.SensorData.edificio == edificio
    )
    
    if piso is not None:
        query = query.filter(models.SensorData.piso == piso)
    
    return query.order_by(desc(models.SensorData.timestamp)).limit(limit).all()


def get_recent_data_for_prediction(
    db: Session,
    edificio: str,
    piso: int,
    minutes: int = 60
) -> List[models.SensorData]:
    """Obtiene datos recientes para predicción"""
    cutoff_time = datetime.utcnow() - timedelta(minutes=minutes)
    
    return db.query(models.SensorData).filter(
        models.SensorData.edificio == edificio,
        models.SensorData.piso == piso,
        models.SensorData.timestamp >= cutoff_time
    ).order_by(models.SensorData.timestamp).all()


# ========== ALERTS ==========

def create_alert(db: Session, alert: schemas.AlertCreate):
    """Crea una nueva alerta"""
    db_alert = models.Alert(**alert.model_dump())
    db.add(db_alert)
    db.commit()
    db.refresh(db_alert)
    return db_alert


def get_active_alerts(
    db: Session,
    edificio: str = "A",
    piso: Optional[int] = None
) -> List[models.Alert]:
    """Obtiene alertas activas (no resueltas)"""
    query = db.query(models.Alert).filter(
        models.Alert.edificio == edificio,
        models.Alert.resuelta == False
    )
    
    if piso is not None:
        query = query.filter(models.Alert.piso == piso)
    
    return query.order_by(desc(models.Alert.timestamp)).all()


def mark_alert_resolved(db: Session, alert_id: int):
    """Marca una alerta como resuelta"""
    alert = db.query(models.Alert).filter(models.Alert.id == alert_id).first()
    if alert:
        alert.resuelta = True
        db.commit()
        db.refresh(alert)
    return alert


def get_all_alerts(
    db: Session,
    edificio: str = "A",
    limit: int = 50
) -> List[models.Alert]:
    """Obtiene todas las alertas (resueltas y activas)"""
    return db.query(models.Alert).filter(
        models.Alert.edificio == edificio
    ).order_by(desc(models.Alert.timestamp)).limit(limit).all()