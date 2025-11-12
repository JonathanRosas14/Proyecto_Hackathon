import pandas as pd
from datetime import datetime, timedelta
from typing import Dict, List

class SimplePredictor:
    """
    Predictor simple basado en tendencias y promedios móviles
    (Alternativa ligera a Prophet para MVP)
    """
    
    def init(self):
        self.temp_range = (18, 26)  # Rango confortable de temperatura
        self.humedad_range = (30, 60)  # Rango confortable de humedad
        self.energia_max = 10.0  # kW máximo por piso
    
    def predict(self, data: List[Dict], variable: str) -> Dict:
        """
        Predice el valor de una variable 60 minutos adelante
        usando promedio móvil simple
        """
        if not data or len(data) < 3:
            return {
                "prediccion_60min": 0,
                "riesgo": "sin_datos",
                "recomendaciones": ["Insuficientes datos históricos"]
            }
        
        df = pd.DataFrame(data)
        df = df.sort_values('timestamp')
        
        # Calcular promedio móvil de últimos 10 minutos
        recent_avg = df[variable].tail(10).mean()
        
        # Calcular tendencia (pendiente simple)
        if len(df) >= 5:
            x = list(range(len(df.tail(5))))
            y = df[variable].tail(5).values
            trend = (y[-1] - y[0]) / len(x) if len(x) > 0 else 0
        else:
            trend = 0
        
        # Predicción simple: valor actual + tendencia * 60 minutos
        prediction = recent_avg + (trend * 60)
        
        # Evaluar riesgo y generar recomendaciones
        riesgo, recomendaciones = self._evaluate_risk(variable, prediction, recent_avg)
        
        return {
            "prediccion_60min": round(prediction, 2),
            "riesgo": riesgo,
            "recomendaciones": recomendaciones
        }
    
    def _evaluate_risk(self, variable: str, prediction: float, current: float) -> tuple:
        """Evalúa el riesgo basado en la predicción"""
        recomendaciones = []
        
        if variable == "temp_c":
            if prediction < self.temp_range[0]:
                riesgo = "alto"
                recomendaciones.append(f"Temperatura bajará a {prediction:.1f}°C")
                recomendaciones.append("Reducir ventilación o incrementar calefacción")
            elif prediction > self.temp_range[1]:
                riesgo = "alto"
                recomendaciones.append(f"Temperatura subirá a {prediction:.1f}°C")
                recomendaciones.append("Incrementar ventilación o aire acondicionado")
            elif abs(prediction - current) > 3:
                riesgo = "medio"
                recomendaciones.append("Se detecta cambio brusco de temperatura")
            else:
                riesgo = "bajo"
                recomendaciones.append("Temperatura dentro de rango confortable")
        
        elif variable == "humedad_pct":
            if prediction < self.humedad_range[0]:
                riesgo = "medio"
                recomendaciones.append(f"Humedad bajará a {prediction:.1f}%")
                recomendaciones.append("Considerar humidificadores")
            elif prediction > self.humedad_range[1]:
                riesgo = "medio"
                recomendaciones.append(f"Humedad subirá a {prediction:.1f}%")
                recomendaciones.append("Incrementar ventilación o deshumidificación")
            else:
                riesgo = "bajo"
                recomendaciones.append("Humedad dentro de rango confortable")
        
        elif variable == "energia_kw":
            if prediction > self.energia_max:
                riesgo = "alto"
                recomendaciones.append(f"Consumo alcanzará {prediction:.1f} kW")
                recomendaciones.append("Revisar equipos activos y redistribuir carga")
            elif prediction > self.energia_max * 0.8:
                riesgo = "medio"
                recomendaciones.append("Consumo energético elevándose")
                recomendaciones.append("Monitorear equipos HVAC")
            else:
                riesgo = "bajo"
                recomendaciones.append("Consumo energético normal")
        
        return riesgo, recomendaciones