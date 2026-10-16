#!/bin/bash
# Build script for Drovision

set -e

echo "🔨 Drovision Build Script"
echo "========================"
echo ""

# Check if .env exists
if [ ! -f "config/.env" ]; then
    echo "⚠️  config/.env file not found!"
    echo "   Creating from .env.example..."
    cp .env.example config/.env
    echo "   Please edit config/.env with your configuration before building."
    echo ""
    exit 1
fi

# Check if .env contains placeholder values
if grep -q "your_password_here" config/.env; then
    echo "⚠️  config/.env file contains placeholder values!"
    echo "   Please edit config/.env with actual credentials before building."
    echo ""
    exit 1
fi

echo "📋 Configuration check passed!"
echo ""

# Build the image
echo "🐳 Building Docker image..."
docker-compose build

echo ""
echo "✅ Build complete!"
echo ""
echo "To start the application:"
echo "  docker-compose up -d"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""