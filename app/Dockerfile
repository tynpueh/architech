# Builder stage: build wheels
FROM python:3.12.9-slim AS builder
WORKDIR /app

# Install build tools only in builder
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements early for caching
COPY requirements.txt .

# Upgrade pip and build wheel files for all requirements
RUN python -m pip install --upgrade pip setuptools wheel && \
    python -m pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# Final stage: minimal runtime (no build tools)
FROM python:3.12.9-slim
WORKDIR /app

# Create a non-root user
RUN addgroup --system app && adduser --system --ingroup app app

# Copy prebuilt wheels and requirements
COPY --from=builder /wheels /wheels
COPY requirements.txt .

# Install packages from wheels into system site-packages (no venv)
RUN python -m pip install --no-index --no-cache-dir --find-links=/wheels -r requirements.txt && \
    rm -rf /wheels /root/.cache/pip

# Copy application code and set ownership to the app user (requires BuildKit for --chown)
COPY --chown=app:app app/ .

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER app

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]