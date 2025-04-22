
FROM python:3.9-slim

WORKDIR /apps/

# Copiar dependencias
COPY src/requirements.txt .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código de la aplicación
COPY src/app.py .

# Puerto de la aplicación
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Comando para iniciar la aplicación
CMD ["python", "app.py"]