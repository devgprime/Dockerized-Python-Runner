#!/bin/sh
set -euo pipefail

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") [INFO]: $1"
}

error() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") [ERROR]: $1" >&2
    exit 1
}

is_poetry_repo() {
    if [ -f "pyproject.toml" ]; then
        if grep -q "^\[tool.poetry\]" pyproject.toml; then
            log "Detected Poetry project: pyproject.toml contains [tool.poetry]."
            return 0
        else
            log "pyproject.toml exists but does not contain [tool.poetry]. Not a Poetry project."
        fi
    else
        log "pyproject.toml not found."
    fi
    return 1
}

find_requirements_file() {
    find . -type f -name "*requirements*.txt" | head -n 1
}

find_entry_point() {
    ENTRY_POINT=$(find . -type f \( -name "main.py" -o -name "app.py" \) | head -n 1)
    if [ -z "$ENTRY_POINT" ]; then
        error "No entry point file (main.py or app.py) found in the project."
    else
        echo "$ENTRY_POINT"
    fi
}

log "Starting application"

if is_poetry_repo; then
    log "Running Poetry project"
    ENTRY_POINT=$(find_entry_point)
    log "Found entry point file: $ENTRY_POINT"
    poetry run python "$ENTRY_POINT"

else
    REQ_FILE=$(find_requirements_file)
    if [ -n "$REQ_FILE" ]; then
        log "Detected standard Python project with requirements file: $REQ_FILE"
        ENTRY_POINT=$(find_entry_point)
        log "Found entry point file: $ENTRY_POINT"
        pip install -r "$REQ_FILE"
        python "$ENTRY_POINT"
    else
        error "No valid project type detected. Ensure the project contains either 'pyproject.toml' (for Poetry) or a file with 'requirements' in its name (for standard Python)."
    fi
fi
