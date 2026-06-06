# syntax=docker/dockerfile:1.4
FROM python:3.13.2-slim

# Set working directory
WORKDIR /app

# Set non-sensitive environment variables
ARG APP_ENV=production

ENV APP_ENV=${APP_ENV} \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=0 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    UV_CACHE_DIR=/root/.cache/uv

# Install system dependencies (cached across builds)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && pip install --upgrade pip \
    && pip install uv

# Copy pyproject.toml and requirements files first (better layer caching)
COPY pyproject.toml uv.lock* ./

# Install dependencies with uv (cached mount for faster re-builds)
RUN --mount=type=cache,target=/root/.cache/uv,sharing=locked \
    uv venv && . .venv/bin/activate && uv pip install -e .

# Copy the application
COPY . .

# Make entrypoint script executable - do this before changing user
RUN chmod +x /app/scripts/docker-entrypoint.sh

# Create a non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Create log directory
RUN mkdir -p /app/logs

# Default port
EXPOSE 8000

# Log the environment we're using
RUN echo "Using ${APP_ENV} environment"

# Command to run the application
ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["/app/.venv/bin/uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
