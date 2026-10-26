# [Seed] JS Signature Reverse Engineering (Webpack + AES + Timestamp)

## Scenario Classification
JS Signature

## Goal Overview
Reverse engineer the `sign` parameter generation algorithm for a web application's API and implement local reproduction.

## Complete Execution Chain

1. Capture packets in the browser → discover a POST request with `sign` and `timestamp` parameters.
2. Search the JS source code for "sign" → locate the webpack-bundled chunk file.
3. Set a breakpoint at the sign assignment → hit it and view the call stack.
4. Trace the call stack back → find the signing function (inside a webpack module).
5. Analyze the signature logic: `sign = HmacSHA256(sorted_params + timestamp, secret_key)`.
6. Key source: hardcoded in another webpack module.
7. Local reproduction with Node.js → the generated sign matches the browser's.
8. Verification: use the reproduced sign to request the API → returns normal data.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Too many results when searching for "sign" | Variable names are minified after webpack bundling | Search for `sign=` instead, or find the request in the Network panel and trace back using the initiator | 15min |
| Breakpoint hit but code is incomprehensible | Webpack minification + variable name obfuscation | Use Chrome's Pretty Print to format, then use SourceMap (if available) | 10min |
| Local reproduction result does not match | Parameter sorting method is wrong | Carefully examine the sort logic in the source code (alphabetical order by key + special character handling) | 30min |
| Timestamp precision is wrong | Server uses seconds, I used milliseconds | `Math.floor(Date.now() / 1000)` | 5min |
| Key not found | Key is imported via require in another chunk file | Use console.log to print the key variable at the breakpoint | 10min |

## Toolchain Findings

- The initiator column in Chrome DevTools is faster for locating the signing function than searching the source code.
- For webpack-bundled code, Pretty Print + breakpoints are more efficient than hard reading.
- If a SourceMap (.map file) is available, directly restore the original code.
- Node.js's `crypto` module can directly reproduce most signature algorithms.

## Key Code/Commands

```javascript
// Node.js reproduction
const crypto = require('crypto');

function generateSign(params, timestamp, secretKey) {
    // 1. Sort parameters alphabetically by key
    const sorted = Object.keys(params).sort().map(k => `${k}=${params[k]}`).join('&');
    // 2. Append timestamp
    const message = sorted + '&timestamp=' + timestamp;
    // 3. HMAC-SHA256
    return crypto.createHmac('sha256', secretKey).update(message).digest('hex');
}

const params = { user_id: '123', action: 'query' };
const timestamp = Math.floor(Date.now() / 1000);
const secretKey = 'hardcoded_key_from_webpack';
console.log(generateSign(params, timestamp, secretKey));
```

## Suggestions for This Package

- js-reverse's env-patching.md should include "how to handle dependencies between webpack chunks".
- Suggest adding a quick reference for "common signature algorithm identification" (HMAC-SHA256 vs MD5 vs custom).

## Reusable Patterns/Script Snippets

**Standard JS signature reverse engineering workflow**:
```text
1. Capture packets to find the signed request
2. Locate the signing function using the initiator/call stack
3. Analyze the signature logic (parameter sorting + concatenation + encryption)
4. Find the key source (hardcoded/API response/time-derived)
5. Reproduce in Node.js
6. Compare and verify
```

**Common signature patterns**:
```text
- HmacSHA256(sorted_params, key) → most common
- MD5(params + salt + timestamp) → older systems
- AES(JSON.stringify(params), key) → encryption rather than signing
- RSA sign → rare, usually financial
```

## Evolution Actions
- [ ] No need to update routing matrix
- [ ] No need to update bootstrap-manifest
- [ ] No need to update sub-skill documentation

## Environment Information
- OS: Windows
- Tool versions: Chrome DevTools, Node.js 20+
- Target platform: Web (Webpack-bundled SPA)

## Anonymization Requirements
This entry is seed data, written based on public technical patterns, and does not involve real targets.

---
<!-- [Community Contribution] Seed data, no PR required -->
