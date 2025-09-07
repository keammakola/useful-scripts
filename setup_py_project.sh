#!/bin/bash

# TO RUN THIS SCRIPT:
# chmod +x setup_py_project.sh
# source setup_py_project.sh

# setup_py_project.sh
# Automates Python project setup:
# - Checks for Python
# - Creates and activates a virtual environment
# - Upgrades pip
# - Installs project and dev dependencies
# - Sets up pre-commit hooks with a default config if needed

set -e

echo "Starting setup"

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python not installed"
    return 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment"
    python3 -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment"
source venv/bin/activate

# Upgrade pip
echo "Updating pip"
python -m pip install --upgrade pip

# Install project dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies"
    pip install -r requirements.txt
else
    echo "No requirements.txt found, skipping project dependencies"
fi

# Install dev dependencies if requirements-dev.txt exists
if [ -f "requirements-dev.txt" ]; then
    echo "Installing dev dependencies"
    pip install -r requirements-dev.txt
else
    echo "No requirements-dev.txt found, skipping dev dependencies"
fi

# Setup pre-commit hooks
echo "Setting up pre-commit hooks"
pip install pre-commit

# Create default pre-commit config if missing
if [ ! -f ".pre-commit-config.yaml" ]; then
    echo "Creating default .pre-commit-config.yaml"
    cat <<EOL > .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: check-yaml

  - repo: https://github.com/psf/black
    rev: 23.7.0
    hooks:
      - id: black

  - repo: https://github.com/PyCQA/isort
    rev: 6.0.0
    hooks:
      - id: isort

  - repo: https://github.com/PyCQA/bandit
    rev: 1.8.1
    hooks:
      - id: bandit


EOL
fi

if [ -d ".git" ]; then
    pre-commit install
    echo "Pre-commit hooks installed"
else
    echo "Git not initialized, skipping pre-commit installation"
fi

echo "Setup complete"
