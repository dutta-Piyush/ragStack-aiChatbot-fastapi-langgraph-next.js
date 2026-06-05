#!/bin/bash
set -e

# Print initial environment values (before loading .env)
echo "Starting with these environment variables:"
echo "APP_ENV: ${APP_ENV:-development}"
echo "Initial Database Host: $( [[ -n ${POSTGRES_HOST:-${DB_HOST:-}} ]] && echo 'set' || echo 'Not set' )"
echo "Initial Database Port: $( [[ -n ${POSTGRES_PORT:-${DB_PORT:-}} ]] && echo 'set' || echo 'Not set' )"
echo "Initial Database Name: $( [[ -n ${POSTGRES_DB:-${DB_NAME:-}} ]] && echo 'set' || echo 'Not set' )"
echo "Initial Database User: $( [[ -n ${POSTGRES_USER:-${DB_USER:-}} ]] && echo 'set' || echo 'Not set' )"

# Load environment variables from the appropriate .env file
if [ -f ".env.${APP_ENV}" ]; then
    echo "Loading environment from .env.${APP_ENV}"
    set -a
    source ".env.${APP_ENV}"
    set +a
elif [ -f ".env" ]; then
    echo "Loading environment from .env"
    set -a
    source ".env"
    set +a
else
    echo "Warning: No .env file found. Using system environment variables."
fi

# Check required sensitive environment variables
required_vars=("JWT_SECRET_KEY" "OPENAI_API_KEY")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -gt 0 ]]; then
    echo "ERROR: The following required environment variables are missing:"
    for var in "${missing_vars[@]}"; do
        echo "  - $var"
    done
    echo "Please provide these variables through environment or .env files."
    exit 1
fi

# Print final environment info
echo -e "\nFinal environment configuration:"
echo "Environment: ${APP_ENV:-development}"

echo "Database Host: $( [[ -n ${POSTGRES_HOST:-${DB_HOST:-}} ]] && echo 'set' || echo 'Not set' )"
echo "Database Port: $( [[ -n ${POSTGRES_PORT:-${DB_PORT:-}} ]] && echo 'set' || echo 'Not set' )"
echo "Database Name: $( [[ -n ${POSTGRES_DB:-${DB_NAME:-}} ]] && echo 'set' || echo 'Not set' )"
echo "Database User: $( [[ -n ${POSTGRES_USER:-${DB_USER:-}} ]] && echo 'set' || echo 'Not set' )"

echo "LLM Model: ${DEFAULT_LLM_MODEL:-Not set}"
echo "Debug Mode: ${DEBUG:-false}"

# Run database migrations if necessary
# e.g., alembic upgrade head

# Run database migrations
echo "Running database migrations..."
/app/.venv/bin/alembic upgrade head
echo "Database migrations completed."

# Execute the CMD
exec "$@"
