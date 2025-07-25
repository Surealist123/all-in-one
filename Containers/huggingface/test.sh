#!/bin/bash

# Simple test script for Hugging Face container
echo "Testing Hugging Face AI Container Setup"
echo "======================================="

# Check if required files exist
echo "✓ Checking required files..."
files=("Dockerfile" "app.py" "requirements.txt" "start.sh" "healthcheck.sh" "templates/index.html" "static/style.css" "static/script.js")

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing"
        exit 1
    fi
done

# Check Python syntax
echo "✓ Checking Python syntax..."
python3 -m py_compile app.py
if [ $? -eq 0 ]; then
    echo "  ✓ app.py syntax valid"
else
    echo "  ✗ app.py syntax error"
    exit 1
fi

# Check if requirements are valid
echo "✓ Checking requirements.txt..."
if [ -s "requirements.txt" ]; then
    echo "  ✓ requirements.txt is not empty"
else
    echo "  ✗ requirements.txt is empty"
    exit 1
fi

# Check if scripts are executable
echo "✓ Checking script permissions..."
for script in "start.sh" "healthcheck.sh"; do
    if [ -x "$script" ]; then
        echo "  ✓ $script is executable"
    else
        echo "  ✗ $script is not executable"
        exit 1
    fi
done

echo ""
echo "All tests passed! ✅"
echo "The Hugging Face container is ready for deployment."