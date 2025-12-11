#!/bin/bash
# Start script for Render deployment

echo "Starting Gestational Diabetes ML API..."
uvicorn fastapi_backend_modified:app --host 0.0.0.0 --port ${PORT:-8000}
