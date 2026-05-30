# Hermes Agent Docker Setup

This repository contains a Docker Compose setup for running
[NousResearch Hermes Agent](https://github.com/NousResearch/hermes-agent) in a
CUDA Ubuntu container.

The default Compose file is configured to run on Docker Desktop without an
NVIDIA GPU. A separate override file is included for NVIDIA Linux hosts.

## Files

- `compose.yaml` - default Docker Compose service definition.
- `compose.gpu.yaml` - optional NVIDIA GPU override.
- `docker/Dockerfile` - builds the Hermes image from `nvidia/cuda`.
- `docker/entrypoint.sh` - prepares the writable Hermes home directory.

## Requirements

- Docker Desktop or Docker Engine
- Docker Compose
- Internet access during the first build
- Optional: NVIDIA Container Toolkit for GPU acceleration on Linux

## Build

```bash
docker compose build
```

The build installs system packages, Node.js, Playwright Chromium, `uv`, and the
Hermes Python package.

By default, it builds Hermes version `v2026.4.30`. To use another version:

```bash
HERMES_VERSION=v2026.4.30 docker compose build
```

## Run

Start Hermes Gateway:

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
docker compose logs -f hermes
```

Stop it:

```bash
docker compose down
```

## NVIDIA GPU Mode

On a machine with NVIDIA GPU support configured for Docker, start with the GPU
override:

```bash
docker compose -f compose.yaml -f compose.gpu.yaml up -d
```

You can override the GPU selection with `HERMES_GPUS`:

```bash
HERMES_GPUS='"device=0"' docker compose -f compose.yaml -f compose.gpu.yaml up -d
```

## Configure Hermes

The container stores Hermes runtime state in `.hermes/` inside this directory.
On first start, the entrypoint creates `.hermes/.env` from Hermes defaults.

Run the setup wizard:

```bash
docker compose exec hermes hermes setup
```

Or inspect the current configuration:

```bash
docker compose exec hermes hermes status
```

At minimum, Hermes needs a model/provider configured before it can answer
requests. Messaging platforms such as Slack, Telegram, or WhatsApp must also be
enabled separately.

## Useful Commands

```bash
docker compose exec hermes hermes --help
docker compose exec hermes hermes status
docker compose exec hermes hermes doctor
docker compose exec hermes hermes logs
docker compose exec hermes hermes gateway --help
```

## Notes

- The project directory is bind-mounted into the container at `/workspace`.
- Hermes home is set to `/workspace/.hermes`.
- Playwright browsers are installed under `/opt/playwright` in the image.
- The default service uses `network_mode: host`.
