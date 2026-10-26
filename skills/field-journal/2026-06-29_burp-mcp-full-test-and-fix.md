# 2026-06-29 burp-mcp-full Full Test and Fix

## Scenario Classification
BurpSuite extension development/testing

## Goal Overview
Run full runtime availability tests on the burp-mcp-full extension (Burp Suite Professional MCP Full Control, 63 tools), and find and fix 3 bugs + 1 bridge-layer race condition.

## Full Execution Chain

1. Static verification: check the 63-tool consistency across the Java dispatch table / getToolList() / bridge buildToolDefinitions
2. Compile: build.bat automates fat-jar packaging (JDK 21, montoya-api 2025.5, gson 2.11.0, nanohttpd 2.3.1)
3. Load: load the extension in Burp Suite Professional 2026.4.2 and confirm `[MCP] Server started`
4. Runtime testing: in 5 batches, call 127.0.0.1:9876 directly through a node http client:
   - Batch 1: 30 read-only/encode-decode/query tools (zero side effects)
   - Batch 2: network-sending tools (send_request / repeater / intruder, target scanme.nmap.org)
   - Batch 3: 7 Intruder variants (attack/async/wordlist/pitchfork/cluster_bomb/battering_ram/with_options, small-scope enumeration)
   - Batch 4: Scope/config/rules/handler/add_issue/compare
   - Batch 5: crawl + proxy_clear
5. Found and fixed 3 bugs; regression verification passed

## Pitfalls

| Problem | Cause | Solution | Time |
|------|------|---------|------|
| `scan()` request_count is always 0 | AuditConfiguration does not accept a seed URL, and the code forgot to call addRequest | Parse host/port/path from the url, build a GET HttpRequest, and feed it to activeAudit.addRequest() | 2h (incl. verification) |
| `send_to_intruder()` reports HttpRequest must have an HttpService | Used the HttpRequest.httpRequest(raw) overload without a service | Added buildRequestWithService(): parse host/port/https from the Host header via regex → HttpService, then use the httpRequest(HttpService, raw) overload | 20min |
| `set_upstream_proxy()` NPE on missing parameter | params.get("proxy_host") returns null → .getAsString() NPE | Add a null check: if (!params.has("proxy_host")) return a clear error | 5min |
| mcp-bridge.js API async race condition: the 4th of 4 rapid requests loses its response | process.exit(0) on stdin close kills the unfinished HTTP request | pending counter + stdinClosed flag → exit only after all requests complete | 1h (incl. mock tests) |
| curl HTTP_CODE=000 cannot probe the port | curl is sandbox-blocked on this machine | Switch to the node http module for probing | 5min |
| Montoya API Audit package path guessed wrong | Inferred from online javadoc that Audit is under the scanner package | Use javap to decompile the real montoya-api-2025.5.jar and confirm it is under scanner.audit | 30min |
| File encoding issue causes Edit tool match failures | UTF-8 with BOM Chinese content displays with shifted encoding in the terminal | Switch to Python for replacement, specifying utf-8-sig | 10min |

## Toolchain Findings

- In montoya-api 2025.5, Audit is at `burp.api.montoya.scanner.audit.Audit` (not scanner.Audit)
- The AuditConfiguration factory method does not accept a seed URL; the seed must be fed in via Audit.addRequest(HttpRequest)
- The HttpRequest.httpRequest(raw) overload without a service is sufficient for Repeater, but Intruder requires an HttpService
- Intruder.sendToIntruder(HttpRequest) requires the request to have a service attached
- api.burpSuite().version()'s major()/minor()/build() went from deprecation to removal in 2025.5; use buildNumber()/edition()/toString() instead
- send_request goes through http.sendRequest() and does not enter proxy history
- curl is sandbox-blocked on this machine; use node http for probing
- The IDA MCP port is not fixed at 13337 (it increments between instances), but the Burp MCP port is configurable via system property/env and is fixed

## Key Code/Commands

### Full Test Script Pattern
```javascript
const http = require('http');
function call(tool, params={}, timeoutMs=30000) {
  return new Promise((resolve) => {
    const body = JSON.stringify({tool, params});
    const req = http.request({hostname:'127.0.0.1',port:9876,path:'/',method:'POST',
      headers:{'Content-Type':'application/json','Content-Length':Buffer.byteLength(body)}}, (res)=>{
      let d=''; res.on('data',c=>d+=c); res.on('end',()=>{ try{resolve(JSON.parse(d));}catch(e){resolve({__raw:d.slice(0,200)});} });
    });
    req.on('error', e => resolve({__err: e.message}));
    req.on('timeout', () => { req.destroy(); resolve({__timeout:true}); });
    req.setTimeout(timeoutMs);
    req.write(body); req.end();
  });
}
```

### buildRequestWithService (core fix)
```java
private HttpRequest buildRequestWithService(String rawRequest) {
    java.util.regex.Matcher m = java.util.regex.Pattern.compile(
            "(?im)^Host:\\s*([^:\r\n]+)(?::(\\d+))?\\s*$").matcher(rawRequest);
    if (!m.find()) return HttpRequest.httpRequest(rawRequest);
    String host = m.group(1).trim();
    boolean isHttps = rawRequest.contains("https://") || rawRequest.contains(":443");
    int port = m.group(2) != null ? Integer.parseInt(m.group(2))
              : (isHttps ? 443 : 80);
    HttpService svc = HttpService.httpService(host, port, isHttps);
    return HttpRequest.httpRequest(svc, rawRequest);
}
```

### Bridge-Layer Race Condition Fix (mcp-bridge.js)
```javascript
let pending = 0;
let stdinClosed = false;
rl.on('line', async (line) => { ... pending++; ... finally { pending--; if (stdinClosed && pending === 0) process.exit(0); } });
rl.on('close', () => { stdinClosed = true; if (pending === 0) process.exit(0); });
```

### scan() Seed Fix
```java
// Build a GET seed request from the URL and feed it to audit
java.net.URL u = new java.net.URL(url);
String host = u.getHost();
boolean isHttps = "https".equalsIgnoreCase(u.getProtocol());
int port = u.getPort() > 0 ? u.getPort() : (isHttps ? 443 : 80);
String path = (u.getPath() == null || u.getPath().isEmpty()) ? "/" : u.getPath();
String pathQuery = u.getQuery() != null ? path + "?" + u.getQuery() : path;
HttpService svc = HttpService.httpService(host, port, isHttps);
HttpRequest seedReq = HttpRequest.httpRequest(svc,
    "GET " + pathQuery + " HTTP/1.1\r\nHost: " + host + "\r\nConnection: close\r\n\r\n");
activeAudit.addRequest(seedReq);
```

## Suggestions for This Package

- The routing matrix already covers BurpSuite MCP; no change needed
- `burpsuite-mcp-guide.md` has had a changelog appended (3 fixes + bridge layer + full verification results)
- The tool table has been updated for Scanner (scan gained a mode parameter) and Intruder (send_to_intruder Host header requirement)
- No new bootstrap entry needed (the build script build.bat is self-contained)
- The IDA MCP port is not fixed; recommend noting this in the MCP service management table

## Reusable Patterns/Script Fragments

- The 63-tool full availability test script pattern (see Key Code above). Applicable to regression testing of any HTTP-based MCP extension.
- The buildRequestWithService pattern: parse an HttpService from the Host header. Applicable to all Montoya API scenarios that need to construct an HttpRequest + HttpService from a raw request.

## Evolution Actions
- [x] Updated the routing matrix (route already covered, no change needed)
- [ ] Updated the tool-index (uses .template, no change needed)
- [ ] Updated the bootstrap-manifest (no new tools)
- [x] Updated sub-skill documentation (changelog appended to burpsuite-mcp-guide.md)
- [x] Added a pitfall record (this entry)
- [ ] No update needed

## Environment Information
- OS: Windows 11 Pro for Workstations 10.0.26200
- Tool versions: JDK 21.0.11+10 / Burp Suite Professional 2026.4.2 (20260402000047704)
- Target platform: montoya-api 2025.5 / gson 2.11.0 / nanohttpd 2.3.1
- Test target: scanme.nmap.org (authorized test site)

## Anonymization Requirements
The test target is the public test site scanme.nmap.org; no anonymization needed. Contains no real domains/IPs/tokens/usernames.

## Index Sync (final step before commit)

After writing this log, `_index.md` must be updated in sync:

1. Add a row to the corresponding subsection under "by scenario classification" (with date and keywords)
2. Update the "cumulative statistics" counts and the "last updated" date

---
<!-- [Community contribution] After completion, ask the user whether to PR to the main repository. See CONTRIBUTE-BACK.md for the flow. -->
