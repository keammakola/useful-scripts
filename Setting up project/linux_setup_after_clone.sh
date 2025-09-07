#!/bin/bash
set -e

echo "Starting setup"

# Check if python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python not installed"
    exit 1
fi

# Create virtual environment if not exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment"
    python3 -m venv venv
    sleep 5
fi

# Activate virtual environment
echo "Activating virtual environment"
source venv/bin/activate

# Upgrade pip
echo "Updating pip"
pip install --upgrade pip

# Install dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies"
    pip install -r requirements.txt
fi

# Install dev dependencies
if [ -f "requirements-dev.txt" ]; then
    echo "Installing dev dependencies"
    pip install -r requirements-dev.txt
fi

# Setup pre-commit hooks
if [ -f ".pre-commit-config.yaml" ]; then
    echo "Setting up pre-commit hooks"
    pip install pre-commit
    pre-commit install
fi

echo "Setup complete"
