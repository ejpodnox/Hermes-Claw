ARG HERMES_VERSION=v2026.4.30

FROM nvidia/cuda:12.9.0-devel-ubuntu22.04

ARG HERMES_VERSION
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/playwright
ENV HERMES_HOME=/workspace/.hermes
ENV HOME=/workspace
ENV XDG_CACHE_HOME=/workspace/.cache
ENV PATH=/usr/local/bin:/opt/hermes/venv/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash \
      build-essential \
      ca-certificates \
      curl \
      ffmpeg \
      git \
      libffi-dev \
      procps \
      python3 \
      python3-dev \
      python3-venv \
      ripgrep \
      wget && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh

RUN git clone --branch "${HERMES_VERSION}" --depth 1 https://github.com/NousResearch/hermes-agent.git /opt/hermes

WORKDIR /opt/hermes

RUN npm install --prefer-offline --no-audit && \
    npx playwright install --with-deps chromium --only-shell && \
    cd /opt/hermes/scripts/whatsapp-bridge && \
    npm install --prefer-offline --no-audit && \
    npm cache clean --force

RUN mkdir -p /opt/uv-home && chmod 755 /opt/uv-home && \
    HOME=/opt/uv-home uv venv /opt/hermes/venv --python 3.11 && \
    HOME=/opt/uv-home VIRTUAL_ENV=/opt/hermes/venv uv pip install --no-cache-dir -e ".[all]"

COPY patch-openai-responses-null-output.py /tmp/patch-openai-responses-null-output.py
RUN /opt/hermes/venv/bin/python /tmp/patch-openai-responses-null-output.py && \
    rm /tmp/patch-openai-responses-null-output.py

COPY entrypoint.sh /usr/local/bin/hermes-container-entrypoint
RUN chmod +x /usr/local/bin/hermes-container-entrypoint

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/hermes-container-entrypoint"]
