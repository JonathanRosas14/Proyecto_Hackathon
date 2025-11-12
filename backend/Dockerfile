# Base image
FROM python:3.11-slim

# Evitar buffers en la salida y mantener pip comportamiento compatible
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias del sistema necesarias para paquetes como psycopg2 y compilación
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    curl \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Copiar requirements y luego instalar dependencias Python
COPY requirements.txt ./
RUN pip install --upgrade pip setuptools wheel && pip install -r requirements.txt

# Copiar el código de la aplicación
COPY . /app

# Exponer el puerto por defecto (Render provee $PORT en tiempo de ejecución)
EXPOSE 8000

# Comando por defecto: usar gunicorn con el worker de uvicorn.
# Bind usa la variable $PORT si está presente, sino 8000.
CMD ["sh", "-c", "gunicorn -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:${PORT:-8000}"]
