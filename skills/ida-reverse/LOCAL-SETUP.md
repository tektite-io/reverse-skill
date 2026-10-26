# IDA ↔ reverse-skill Integration (Portable)

This page provides generic steps and does not include absolute paths for any specific machine. The local readiness report stays in the repository root at `LOCAL-READINESS.md` (already gitignored).

## Target Shape

| Item | Convention |
|----|------|
| IDA installation directory | Environment variable `IDADIR` (the directory contains `ida.exe` or `ida.dll`) |
| HTTP MCP | `http://127.0.0.1:13337/mcp` |
| Client server name | Keep only **`idapro`** (do not also register `ida-pro-mcp`) |
| Startup | `scripts/start.ps1` (`--unsafe`, no `?ext=dbg`) |
| Opening a database | For large files prefer `scripts/open.ps1`; do not call `idb_open` directly through some clients |

Two MCP names pointing to the same 13337 will register the tools twice and compete with the idalib worker for the port.

## Installation

```powershell
setx IDADIR "<your IDA installation directory>"

# Must use mrexodia/ida-pro-mcp; do not install the PyPI ida-mcp
python -m pip install "git+https://github.com/mrexodia/ida-pro-mcp.git"

# Activate idalib (adjust the path to your local IDA)
python "<IDADIR>\idalib\python\py-activate-idalib.py" -d "<IDADIR>"

# Install plugin + client configuration
python -m ida_pro_mcp --install --transport streamable-http --scope global
```

## Startup and Keepalive

An MCP entry with `type: http` will not launch the process on your behalf. When 13337 is not listening, all clients report an error.

| Script | Purpose |
|------|------|
| `scripts/start.ps1` | If healthy, `OK:<n>:reuse` and refresh last-healthy; if the port is listening but RPC times out, treat it as busy and do not kill; replace the managed supervisor only when nobody is listening, `py_eval` is missing, or tools/list keeps failing for more than 3 minutes (and there is no `opening.lock`); never kill `ida.exe` |
| `scripts/watchdog.ps1` | Inspect every minute; reuse when healthy; GUI / `open.ps1` database lock / last-healthy less than 3 minutes → reuse; **`-Force` only after tools/list keeps failing for more than 3 minutes** |
| `scripts/recover.ps1` | Immediately `-Force` restart the supervisor (without killing `ida.exe`). Use this when an HTTP client marks `idapro` as error |
| `scripts/install-autostart.ps1` | Register scheduled task `reverse-skill-ida-mcp` (at logon + every minute) |
| `scripts/start-gui.ps1` | Launch the GUI plugin when idalib license fails |
| `scripts/open.ps1` | Call `idb_open` directly over HTTP, bypassing schema validation in some clients |

Logs: `%LOCALAPPDATA%\reverse-skill\ida-mcp\supervisor.log` and `watchdog.log`.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "skills\ida-reverse\scripts\start.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "skills\ida-reverse\scripts\open.ps1" -Path "C:\path\to\target.exe" -TimeoutSeconds 600
powershell -NoProfile -ExecutionPolicy Bypass -File "skills\ida-reverse\scripts\install-autostart.ps1"
```

When the GUI occupies 13337 but does not respond for a while, `start.ps1` outputs `WARN:gui_busy` and exits, avoiding killing the IDA instance currently being analyzed.

## Clients

All point to Streamable HTTP: `http://127.0.0.1:13337/mcp`, server name `idapro`.

You must open a new session after changing the configuration. If Cursor starts when the port is not listening, starting the service later **will not reconnect automatically**; you need to refresh manually in the MCP panel.

## Known Caveats

1. System32 files: `open.ps1` copies them to a temporary path (output includes `(temp copy)`)
2. Do not call `idb_open` directly through some clients' MCP
3. `start.ps1` prefers `python -m ida_pro_mcp.idalib_supervisor`, which is more stable than the `.cmd` wrapper
4. When a formal installation and a desktop portable package coexist, `IDADIR` takes precedence
5. Do not add `?ext=dbg` (the debugger tools are not exposed by default)
