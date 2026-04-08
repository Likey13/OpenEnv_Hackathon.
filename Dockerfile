FROM python:3.11-slim

# HF Spaces requires a non-root user with UID 1000
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Install dependencies first (better layer caching)
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY --chown=appuser:appuser . .

# Switch to non-root user
USER appuser

# HF Spaces always uses 7860; shell form so $PORT expands correctly
ENV PORT=7860
EXPOSE 7860

# Shell form (not exec form) so $PORT is expanded at runtime
CMD python -m uvicorn app:app --host 0.0.0.0 --port ${PORT}
