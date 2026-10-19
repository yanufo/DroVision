# =========================
# Build stage
# =========================
FROM python:3.12.3 AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    patchelf \
    && rm -rf /var/lib/apt/lists/*

# Copy application source code and dependencies
COPY . .

# Install all application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Nuitka
RUN pip install --no-cache-dir nuitka


# =========================
# Compile application modules (protected source code)
# =========================

RUN mkdir -p /build/compiled/src/ui
RUN mkdir -p /build/compiled/src/sql_tool
RUN mkdir -p /build/compiled/src/services


# -------------------------
# UI
# -------------------------

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/ui \
    src/ui/upload.py

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/ui \
    src/ui/download.py

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/ui \
    src/ui/ui_tools.py

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/ui \
    src/ui/preview.py

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/ui \
    src/ui/drone_model.py

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/ui \
    src/ui/usagi_model.py


# -------------------------
# SQL
# -------------------------

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/sql_tool \
    src/sql_tool/connection.py

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/sql_tool \
    src/sql_tool/queries.py


# -------------------------
# Services
# -------------------------

RUN python -m nuitka \
    --module \
    --output-dir=/build/compiled/src/services \
    src/services/report_service.py


# =========================
# Runtime stage
# =========================

FROM python:3.12.3-slim

WORKDIR /app

ENV PYTHONPATH=/app

RUN apt-get update && apt-get install -y \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*


# =========================
# Wait for MySQL script
# =========================

COPY docker/wait-for-mysql.sh /wait-for-mysql.sh
RUN chmod +x /wait-for-mysql.sh


# =========================
# Python dependencies
# =========================

COPY --from=builder /build/requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt


# =========================
# Application assets
# =========================

COPY --from=builder /build/assets /app/assets


# =========================
# Streamlit entrypoint
# =========================

COPY --from=builder /build/app.py /app/app.py

COPY --from=builder /build/src/pages /app/src/pages

COPY --from=builder /build/.streamlit /app/.streamlit


# =========================
# Compiled UI modules (protected)
# =========================

RUN mkdir -p /app/src/ui

COPY --from=builder /build/compiled/src/ui/ /app/src/ui/


# =========================
# Compiled SQL modules (protected)
# =========================

RUN mkdir -p /app/src/sql_tool

COPY --from=builder /build/compiled/src/sql_tool/ /app/src/sql_tool/


# =========================
# Compiled services (protected)
# =========================

RUN mkdir -p /app/src/services

COPY --from=builder /build/compiled/src/services/ /app/src/services/


# =========================
# Package markers
# =========================

RUN touch /app/src/__init__.py
RUN touch /app/src/ui/__init__.py
RUN touch /app/src/sql_tool/__init__.py
RUN touch /app/src/services/__init__.py


# =========================
# Runtime Configuration Files (uncompiled - mounted via docker-compose)
# =========================
# The following files are NOT included in this image:
# - config.yml: Application configuration paths
# - .env: Environment variables (DB credentials, API URLs)
# These are mounted at runtime to allow on-site modification without rebuild


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

ENTRYPOINT ["/wait-for-mysql.sh", "streamlit", "run", "/app/app.py", "--server.port=8501", "--server.address=0.0.0.0"]