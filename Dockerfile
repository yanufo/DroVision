# =========================
# Runtime stage
# =========================
FROM python:3.12.3-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# =========================
# Python dependencies
# =========================

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# =========================
# 3D Models
# =========================

COPY models /app/models

# =========================
# Streamlit entrypoint
# =========================

COPY app_prototype.py /app/app_prototype.py

COPY pages /app/pages

COPY .streamlit /app/.streamlit

# =========================
# Application assets
# =========================

COPY images /app/images

RUN mkdir -p /app/inspection

COPY inspection/config.yml /app/inspection/config.yml

# =========================
# UI modules
# =========================

COPY ui /app/ui

# =========================
# SQL modules
# =========================

COPY sql_tool /app/sql_tool

# =========================
# Services
# =========================

COPY services /app/services

# =========================
# Package markers
# =========================

RUN touch /app/ui/__init__.py
RUN touch /app/sql_tool/__init__.py
RUN touch /app/services/__init__.py

# =========================
# Streamlit
# =========================

EXPOSE 8501

HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=30s \
    --retries=3 \
    CMD curl --fail http://localhost:8501/_stcore/health || exit 1

ENTRYPOINT ["streamlit", "run", "/app/app_prototype.py", "--server.port=8501", "--server.address=0.0.0.0"]
