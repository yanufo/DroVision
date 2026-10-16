# DroVision - Drone Inspection System

A Streamlit-based application for managing drone inspection reports.

## Project Structure

```
drovision/
├── 📂 src/                          # Application source code
│   ├── app_prototype.py            # Main Streamlit application
│   ├── pages/                      # Streamlit sub-pages (uncompiled)
│   ├── ui/                         # UI modules (Nuitka-compiled)
│   ├── sql_tool/                   # Database layer (Nuitka-compiled)
│   └── services/                   # Business logic (Nuitka-compiled)
│
├── 📂 config/                       # Configuration files
│   ├── app.yml                     # Application configuration
│   ├── .env                        # Environment variables (credentials)
│   └── database/
│       └── init.sql                # Database schema
│
├── 📂 docker/                       # Docker infrastructure
│   ├── Dockerfile                  # Multi-stage build with Nuitka
│   ├── docker-compose.yml          # Container orchestration
│   └── wait-for-mysql.sh           # MySQL readiness script
│
├── 📂 scripts/                      # Development scripts
│   ├── build.sh                    # Build script with validation
│   ├── deploy.sh                   # Deployment automation
│   └── cleanup.sh                  # Cleanup runtime data
│
├── 📂 static/                       # Static assets (included in image)
│   ├── .streamlit/                 # Streamlit configuration
│   ├── images/                     # Application images
│   └── models/                     # 3D models
│
├── 📂 runtime/                      # Runtime data (gitignored)
│   ├── logs/                       # Application logs
│   ├── backups/                    # Database backups
│   └── mysql_data/                 # MySQL data directory
│
├── requirements.txt                 # Python dependencies
├── .env.example                     # Environment variable template
├── .dockerignore                    # Docker build exclusions
└── .gitignore                       # Git exclusions
```

## Quick Start

### Development

```bash
# Build and start
./scripts/build.sh
./scripts/deploy.sh start

# Or use docker-compose directly
docker-compose up --build -d
```

### Production Deployment

1. Copy deployment package to target machine:
   ```bash
   docker save drovision-drovision-app -o drovision-app.tar
   scp drovision-app.tar user@target:/opt/drovision/
   scp config/ user@target:/opt/drovision/
   scp docker-compose.yml user@target:/opt/drovision/
   ```

2. On target machine:
   ```bash
   docker load -i drovision-app.tar
   cd /opt/drovision
   ./scripts/deploy.sh start
   ```

## Configuration

### Environment Variables (.env)

Copy `.env.example` to `.env` and update:

- `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` - Database connection
- `MYSQL_ROOT_PASSWORD` - MySQL root password
- `AIRFLOW_URL`, `AIRFLOW_API_USER`, `AIRFLOW_API_PASSWORD` - Airflow integration

### Application Config (config/app.yml)

- `directories.output` - Row inspection output path
- `directories.solar_output` - Solar inspection output path

## Cleaning

```bash
# Remove runtime data
./scripts/cleanup.sh --runtime

# Remove build artifacts
./scripts/cleanup.sh --build

# Remove everything
./scripts/cleanup.sh --all
```

## Tech Stack

- **Frontend**: Streamlit
- **Backend**: Python 3.12
- **Database**: MySQL 8.0
- **Compilation**: Nuitka (for source code protection)
- **Deployment**: Docker & Docker Compose

## License

Proprietary - All rights reserved