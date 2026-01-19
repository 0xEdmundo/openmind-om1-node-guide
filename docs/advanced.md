# Advanced Configuration

This document covers advanced configuration options for your OM1 node.

## Environment Variables

The `.env` file supports the following configuration options:

| Variable | Description | Required |
|----------|-------------|----------|
| `OM_API_KEY` | Your OpenMind API key | ✅ Yes |
| `OM_LOG_LEVEL` | Logging verbosity (DEBUG, INFO, WARN, ERROR) | No |
| `OM_MODEL` | LLM model to use | No |

## Running with Systemd (Production)

For a production setup, create a systemd service:

```bash
sudo nano /etc/systemd/system/om1.service
```

Add the following content:

```ini
[Unit]
Description=OpenMind OM1 Node
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/OM1
Environment="PATH=/home/YOUR_USERNAME/.cargo/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/home/YOUR_USERNAME/OM1/.venv/bin/python -m uv run src/run.py conversation
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable om1
sudo systemctl start om1
```

Check status:

```bash
sudo systemctl status om1
sudo journalctl -u om1 -f
```

## Docker Setup (Alternative)

If you prefer Docker:

```dockerfile
FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    portaudio19-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install uv

WORKDIR /app
RUN git clone https://github.com/OpenMind/OM1.git .
RUN git submodule update --init --recursive
RUN uv venv && uv sync

COPY .env .env

CMD ["uv", "run", "src/run.py", "conversation"]
```

Build and run:

```bash
docker build -t om1-node .
docker run -d --name om1 --restart unless-stopped om1-node
```

## Monitoring

### Check Node Status

```bash
# If using screen
screen -r om1

# If using systemd
sudo systemctl status om1

# View logs
sudo journalctl -u om1 -f --no-pager -n 100
```

### Resource Usage

```bash
# Check memory and CPU
htop

# Check disk usage
df -h
```

## Updating the Node

```bash
cd ~/OM1
git pull
git submodule update --init --recursive
source .venv/bin/activate
uv sync
```

Then restart the node using your preferred method.
