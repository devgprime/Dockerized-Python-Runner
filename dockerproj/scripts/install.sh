#!/bin/sh
set -euo pipefail

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO]: $1"
}

is_poetry_repo() {
    if [ -f "pyproject.toml" ] && grep -q "^\[tool.poetry\]" pyproject.toml; then
        return 0
    fi
    return 1
}

log "Starting dependency installation"

# Debugging: Check if poetry is available
if ! command -v poetry &> /dev/null; then
    log "Poetry is not installed or not in PATH."
    exit 1
fi

if is_poetry_repo; then
    log "Installing Poetry dependencies"
    poetry config virtualenvs.create false
    poetry config virtualenvs.in-project true
    poetry lock --no-interaction
    poetry install --only main --no-root --no-interaction

elif [ -f "requirements.txt" ]; then
    log "Installing pip dependencies"
    pip install --no-cache-dir -r requirements.txt
else
    echo "No dependencies found to install"
fi

log "Installation completed successfully"