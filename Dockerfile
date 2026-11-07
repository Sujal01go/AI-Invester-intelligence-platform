FROM python:3.12-slim

WORKDIR /app

# Prevent Python from writing .pyc files and enable unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=7860

# Install uv package installer
RUN pip install --no-cache-dir uv

# Copy requirements and install dependencies
COPY requirements.txt ./
RUN uv pip install --system --no-cache -r requirements.txt

# Create non-root user (UID 1000) for Hugging Face Spaces compatibility
RUN useradd -m -u 1000 user && \
    mkdir -p /app/data/raw_pdfs /app/data/markdown && \
    chown -R user:user /app

# Copy application files with ownership
COPY --chown=user:user . /app

# Switch to non-root user
USER user

# Expose default port (7860 for Hugging Face Spaces)
EXPOSE 7860

# Run uvicorn respecting dynamic PORT
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port ${PORT:-7860}"]
