#!/usr/bin/env bash
# ida-start.sh — Start the IDA Pro MCP HTTP service (Linux edition)
# Equivalent to the Windows edition's ida-reverse/scripts/start.ps1

set -euo pipefail

# ─── Configuration (adjust to your actual installation) ──────────────────────────────

IDADIR="${IDADIR:-/opt/idapro}"
MCP_PORT="${IDA_MCP_PORT:-13337}"

# idalib-mcp executable path (usually on PATH after pip install)
MCP_SERVER_CMD="${IDA_MCP_SERVER:-ida-pro-mcp}"

# ─── Checks ────────────────────────────────────────────────────────────────────────

if [[ ! -d "$IDADIR" ]]; then
    echo "ERR: IDADIR does not exist: $IDADIR"
    echo "Please set the IDADIR environment variable to point to the IDA Pro installation directory"
    exit 1
fi

if ! command -v "$MCP_SERVER_CMD" &>/dev/null; then
    echo "ERR: $MCP_SERVER_CMD not found"
    echo "Please run first: pip3 install git+https://github.com/mrexodia/ida-pro-mcp.git"
    exit 1
fi

# ─── Kill old processes ───────────────────────────────────────────────────────────

pkill -f "ida-pro-mcp" 2>/dev/null || true
sleep 1

# ─── Start the service ────────────────────────────────────────────────────────────

echo "INFO: Starting IDA MCP HTTP service (port $MCP_PORT) ..."
export IDADIR

nohup "$MCP_SERVER_CMD" --port "$MCP_PORT" > /tmp/ida-mcp.log 2>&1 &
MCP_PID=$!

# ─── Wait until ready ─────────────────────────────────────────────────────────────

TIMEOUT=45
ELAPSED=0

while [[ $ELAPSED -lt $TIMEOUT ]]; do
    if nc -z 127.0.0.1 "$MCP_PORT" 2>/dev/null; then
        echo "OK: IDA MCP service is ready (PID=$MCP_PID, port=$MCP_PORT)"
        exit 0
    fi
    sleep 2
    ELAPSED=$((ELAPSED + 2))
done

echo "ERR: Timed out after ${TIMEOUT}s; the service is not ready"
echo "Check the log: /tmp/ida-mcp.log"
exit 1
