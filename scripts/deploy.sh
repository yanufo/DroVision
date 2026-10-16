#!/bin/bash
# Deploy script for Drovision

set -e

echo "🚀 Drovision Deployment Script"
echo "=============================="
echo ""

# Parse arguments
ACTION=""
REBUILD=false

while [[ $# -gt 0 ]]; do
    case $1 in
        start|stop|restart|logs|build)
            ACTION=$1
            shift
            ;;
        --rebuild)
            REBUILD=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 {start|stop|restart|logs|build} [--rebuild]"
            exit 1
            ;;
    esac
done

# Check required files
check_requirements() {
    if [ ! -f "config/.env" ]; then
        echo "❌ Error: config/.env file not found!"
        echo "   Please create config/.env from .env.example first."
        exit 1
    fi
    
    if [ ! -f "docker-compose.yml" ]; then
        echo "❌ Error: docker-compose.yml not found!"
        exit 1
    fi
}

case $ACTION in
    start)
        check_requirements
        
        echo "📋 Checking configuration..."
        if grep -q "your_password_here" config/.env 2>/dev/null; then
            echo "⚠️  Warning: config/.env contains placeholder values"
            echo "   The application may not connect to database properly."
            echo ""
        fi
        
        echo "🚀 Starting application..."
        if [ "$REBUILD" = true ]; then
            ./scripts/build.sh
        fi
        docker-compose up -d
        
        echo ""
        echo "✅ Application started!"
        echo "   Access at: http://localhost:8501"
        echo "   View logs: docker-compose logs -f"
        echo ""
        ;;
        
    stop)
        echo "🛑 Stopping application..."
        docker-compose down
        echo "✅ Application stopped!"
        echo ""
        ;;
        
    restart)
        echo "🔄 Restarting application..."
        docker-compose restart
        echo "✅ Application restarted!"
        echo ""
        ;;
        
    logs)
        echo "📋 Showing logs (press Ctrl+C to exit)..."
        docker-compose logs -f
        ;;
        
    build)
        echo "🔨 Building application..."
        ./scripts/build.sh
        ;;
        
    *)
        echo "Usage: $0 {start|stop|restart|logs|build} [--rebuild]"
        echo ""
        echo "Options:"
        echo "  start       Start the application"
        echo "  stop        Stop the application"
        echo "  restart     Restart the application"
        echo "  logs        Show application logs"
        echo "  build       Build the Docker image"
        echo ""
        echo "Flags:"
        echo "  --rebuild   Rebuild image before starting"
        echo ""
        exit 1
        ;;
esac