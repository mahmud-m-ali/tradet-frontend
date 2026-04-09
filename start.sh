#!/bin/bash
# HalalEt - Sharia & Ethiopian Trade Compliant Trading Platform
# Start script for development

echo "========================================="
echo "  HalalEt - Halal Trading Platform"
echo "  Sharia & Ethiopian Trade Compliant"
echo "========================================="
echo ""

# Start backend API
echo "[1/2] Starting Backend API on http://localhost:8000..."
cd "$(dirname "$0")/backend"

# Initialize database if needed
./venv/bin/python database.py 2>/dev/null

# Start Flask API in background
./venv/bin/python app.py &
BACKEND_PID=$!
echo "Backend started (PID: $BACKEND_PID)"

# Wait for backend to be ready
sleep 2

# Start Flutter web app
echo ""
echo "[2/2] Starting Flutter Web App..."
cd "$(dirname "$0")/halalet_app"
flutter run -d chrome --web-port 3000 &
FLUTTER_PID=$!
echo "Flutter web app starting (PID: $FLUTTER_PID)"

echo ""
echo "========================================="
echo "  Backend API:  http://localhost:8000/api/health"
echo "  Flutter Web:  http://localhost:3000"
echo "========================================="
echo ""
echo "Press Ctrl+C to stop all services"

# Cleanup on exit
trap "kill $BACKEND_PID $FLUTTER_PID 2>/dev/null; exit" INT TERM
wait
