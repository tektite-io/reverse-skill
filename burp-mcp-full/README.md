# BurpSuite MCP Full Control Extension

Control all core BurpSuite features via the MCP protocol. Cross-platform support for Windows / Linux (Kali) / macOS.

## Quick Start

### 1. Compile the extension

**Windows**:
```cmd
cd burp-mcp-full
build.bat
```

**Linux / Kali / macOS**:
```bash
cd burp-mcp-full
chmod +x build.sh
./build.sh
```

The build script automatically: detects JDK 21+, downloads dependencies (montoya-api 2025.5 / gson / nanohttpd), compiles, packages the extension descriptor (`META-INF/extensions/burp-extension.properties`) into the jar, and builds a fat jar. No Gradle required.

Output: `build/libs/burp-mcp-full.jar`.

### 2. Load into Burp

```
Burp Suite → Extensions → Add → Java → select build/libs/burp-mcp-full.jar
```

After loading, you will see in Output:
```
[MCP] Server started on http://127.0.0.1:9876
```

### 3. Authentication (enabled by default since v2)

The extension automatically generates a random token at startup and writes it to `~/.burp-mcp-token`. `mcp-bridge.js` automatically reads this file and includes the `Authorization: Bearer <token>` header in every request; no manual configuration is required.

To use a fixed token (for example, when sharing across multiple clients), you can use:
- JVM argument: `-Dburp.mcp.token=<token>`
- Environment variable: `BURP_MCP_TOKEN=<token>` (also used by the bridge side)

All `/health`, `/tools`, and `/` (POST) requests require this header; otherwise they return 403. CORS has been tightened to allow only `http://127.0.0.1` origins.

### 4. Configure the MCP client

Add the following in any MCP client (Claude Code / Kiro / Cursor / Cline / Windsurf) (stdio mode):

```json
{
  "mcpServers": {
    "burpsuite": {
      "command": "node",
      "args": ["<path-to-this-directory>/mcp-bridge.js"]
    }
  }
}
```

### 5. Start using it

Tell the AI: "Analyze the requests in Burp proxy history and find security vulnerabilities"

## Feature List

The extension exposes 78 tools. Common categories are listed below (for the complete list, see `getToolList()` in `src/main/java/com/burpmcp/McpHttpServer.java`, or access `GET http://127.0.0.1:9876/tools`, which requires the Authorization header):

| Category | Tools |
|------|------|
| Proxy history | `proxy_history`, `proxy_detail`, `proxy_history_filtered`, `proxy_websocket`, `proxy_clear`, `search_history`, `highlight`, `annotate`, `compare` |
| Send requests | `send_request`, `send_to_repeater`, `repeater_send`, `repeater_modify_send`, `send_to_intruder` |
| Intruder attacks | `intruder_attack`, `intruder_attack_async`, `intruder_attack_wordlist`, `intruder_pitchfork`, `intruder_cluster_bomb`, `intruder_battering_ram`, `intruder_with_options`, `payload_process` |
| Scanning / crawling | `scan` (active/passive), `scan_active`, `scan_results`, `scan_issue_detail`, `crawl`, `sequencer` |
| Scope / Sitemap | `sitemap`, `target_info`, `get_scope`, `add_to_scope`, `remove_from_scope`, `add_issue` |
| Interception / rules | `intercept_toggle`, `register_http_handler`, `remove_http_handler`, `register_proxy_rule`, `remove_proxy_rule` |
| Encoding/decoding | `encode`, `decode`, `convert_request`, `export_request`, `generate_csrf_poc`, `extract_from_response`, `token_analysis` |
| Collaborator | `collaborator_generate`, `collaborator_poll` |
| Configuration | `export_config`, `import_config`, `set_upstream_proxy`, `set_dns_override`, `set_http2`, `cookie_jar`, `save_project`, `burp_version`, `extensions_list`, `log` |

> Scanning/crawling (`scan`, `scan_active`, `crawl`) requires **Burp Professional**. The Community edition returns an explicit license error. Manually added issues (`add_issue`) are written to the Site map.

## Key Tool Parameters

### `intruder_attack` — automated enumeration attack

| Parameter | Description |
|------|------|
| `url_template` | URL template; the placeholder defaults to `@@` |
| `placeholder` | Placeholder string (default `@@`) |
| `from` / `to` | Enumeration start/end values |
| `pad_digits` | Zero-padding width (0 means no padding) |
| `method` | HTTP method (default GET) |
| `body_template` | Request body template (contains the placeholder) |
| `headers` | Request headers object |
| `success_length_not` | Hit condition: response length ≠ this value |
| `success_contains` | Hit condition: response body contains this string |

### `scan` — start an audit

| Parameter | Description |
|------|------|
| `url` | Target URL (required; automatically added to scope) |
| `mode` | `active` (default) or `passive` |

After starting, use `scan_results` to poll issues and active audit status (request count, error count, insertion point count).

### `register_proxy_rule` — proxy request interception rule

| Parameter | Description |
|------|------|
| `url_contains` | Hit condition: URL contains this string |
| `intercept` | `true` to intercept / `false` to pass through without interception (default true) |

Deregister a rule with `remove_proxy_rule` (based on `Registration.deregister()`, which truly unloads it from Burp).

## Usage Examples

### View proxy history
```json
POST http://127.0.0.1:9876
{"tool": "proxy_history", "params": {"limit": 10, "url_filter": "personalblog"}}
```

### Send a request
```json
POST http://127.0.0.1:9876
{"tool": "send_request", "params": {"method": "GET", "url": "https://example.com/api/test"}}
```

### Automated enumeration attack (core feature)
```json
POST http://127.0.0.1:9876
{
  "tool": "intruder_attack",
  "params": {
    "url_template": "https://target.com/api/verify?code=@@",
    "method": "POST",
    "from": 0,
    "to": 999999,
    "pad_digits": 6,
    "success_length_not": 176,
    "headers": {"User-Agent": "Mozilla/5.0"}
  }
}
```

### Toggle interception
```json
POST http://127.0.0.1:9876
{"tool": "intercept_toggle", "params": {"enable": false}}
```

## Port Configuration

By default it listens on `127.0.0.1:9876`. To change it (for example, when it conflicts with the official PortSwigger MCP extension on the same port):

1. **Burp side**: Pass the JVM argument `-Dburp.mcp.port=9877` when starting Burp, or set the environment variable `BURP_MCP_PORT=9877`.
2. **Bridge side**: In the MCP client configuration, set the environment variables `BURP_MCP_PORT=9877` and `BURP_MCP_HOST=127.0.0.1`.

The ports on both sides must match. If Burp is not running or the port is unreachable, the bridge returns clear connection error guidance in `tools/list` and `tools/call`.

## Troubleshooting

| Symptom | Troubleshooting |
|------|------|
| No "[MCP] Server started" in Burp Output | Port occupied or extension failed to load; check the Burp Errors panel |
| MCP client reports "Burp MCP not connected" | Confirm Burp is running and the extension is loaded; confirm both sides use the same port |
| Scan returns "requires Burp Professional" | Normal; the Community edition does not support the Scanner API |
| `remove_http_handler` / `remove_proxy_rule` has no effect | Confirm that the previous `register_*` returned success=true |

## Build from Source (Gradle optional)

```bash
cd burp-mcp-full
gradle jar      # requires Gradle 8.7+ installed locally
# output: build/libs/burp-mcp-full.jar
```

> We recommend `build.bat` / `build.sh` (zero dependencies, automatically downloads jars). The Gradle path is only an alternative.
