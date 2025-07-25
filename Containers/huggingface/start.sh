#!/bin/bash

echo "Starting Hugging Face service..."
exec gunicorn --bind 0.0.0.0:${PORT} --workers 1 --timeout 300 app:app