FROM python:3.14-slim-bookworm@sha256:f0540d0436a220db0a576ccfe75631ab072391e43a24b88972ef9833f699095f

# Installer git
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# Installer uv / patchright / Chromium
COPY --from=ghcr.io/astral-sh/uv:latest@sha256:78a7ff97cd27b7124a5f3c2aefe146170793c56a1e03321dd31a289f6d82a04f /uv /uvx /bin/
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/patchright
RUN uv sync --frozen \
    && uv run patchright install-deps chromium \
    && uv run patchright install chromium \
    && chmod -R 755 /opt/patchright

# Copier projet et start.sh
WORKDIR /app
COPY --chown=1000:1000 . /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Créer user non-root
RUN useradd -m -s /bin/bash pwuser || true
RUN chown -R pwuser:pwuser /app

USER pwuser

# Entrypoint
ENTRYPOINT ["/app/start.sh"]
