# Use official Python Alpine image
FROM python:3.12-alpine3.18

USER root

# Create directory structure
RUN mkdir -p /usr/src/app/{logs,static,scripts,pypoetry} && \
    chmod -R 777 /usr/src/app && \
    mkdir -p /tmp /var/tmp /usr/tmp && \
    chmod 1777 /tmp /var/tmp /usr/tmp

WORKDIR /usr/src/app

# Install system dependencies (including bash for pipx)
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    bash \
    libffi-dev \
    python3-dev \
    build-base \
    poppler-utils \
    tesseract-ocr \
    zlib-dev \
    jpeg-dev \
    tiff-dev

# Copy application files
COPY . /usr/src/app

# Install Python dependencies
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir pipx && \
    pipx ensurepath && \
    pipx install poetry

# Add Poetry to the PATH
ENV PATH="${PATH}:/root/.local/bin"    

# Copy and make scripts executable
COPY scripts/install.sh scripts/run.sh /usr/src/app/scripts/
RUN chmod +x /usr/src/app/scripts/*.sh

# Install project dependencies
RUN ./scripts/install.sh

# Cleanup build dependencies (optional)
# RUN apk del build-base python3-dev

EXPOSE 8000

ENTRYPOINT ["/bin/sh", "/usr/src/app/scripts/run.sh"]