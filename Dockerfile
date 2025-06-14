# Use Python 3.12-slim as the base image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=config.settings \
    DB_NAME=certificate_db \
    DB_USER=root \
    DB_PASSWORD=vkoCPvy3OSyZ9xE57sqF0mZU \
    DB_HOST=db \
    DB_PORT=5432 \
    VALIDATION_SERVICE_URL=https://actualfastapi-app.liara.run/api/v1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user first
RUN useradd -m appuser

# Copy requirements file
COPY --chown=appuser:appuser requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files with correct ownership
COPY --chown=appuser:appuser . .

# Create static directory and collect static files
RUN mkdir -p /app/static && \
    python manage.py collectstatic --noinput && \
    chown -R appuser:appuser /app/staticfiles

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Command to run the application
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"] 
