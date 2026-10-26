# reverse-skill Quick Start and Community FAQ

## Project Positioning

`reverse-skill` is a collection of reverse engineering and security research skills, rules, and tool documentation readable by AI clients. It is not a single executable application. Before use, confirm that you have explicit authorization for the analysis target, or that you are using a legitimate CTF, educational, or test environment.

## Basic Usage

First download the project:

    git clone https://github.com/zhaoxuya520/reverse-skill.git
    cd reverse-skill

Then give the project directory to the AI client you use as a workspace or document source. Core documents include:

- `RULES.md`: general rules and security boundaries.
- `skills/MASTER-ROUTING.md`: skill routing and task triage.
- `skills/*/SKILL.md`: skill descriptions for each specialized domain.
- `docs/platforms/`: tool installation instructions for different operating systems.

This project remains client-neutral, so the actual loading method for OpenCode, Codex, Cursor, Claude Code, and other clients still follows each client's official documentation; do not assume that one client's plugin or synchronization format applies to other clients.

The most reliable general approach is to open the complete repository root as the workspace, rather than copying only the `skills/` subdirectory into the client. Confirm that the client can read `AGENTS.md` / `RULES.md` in the root directory, then run the platform-native `master-route`; if the client does not automatically load project rules, explicitly reference `RULES.md` and the target `SKILL.md` in the conversation.

## OpenCode, Codex, and Synchronization Issues

If the client shows `Not Synchronizable` or cannot synchronize, first confirm whether the workspace points to the complete repository root, whether file permissions allow reading, and whether the client supports that directory format. The most reliable alternative is to open the repository directly in the local workspace and explicitly reference the required rules or skill documents in the conversation. If the problem is still reproducible, include the client version, operating system, full error message, and minimal reproduction steps in the report.

## AI Refuses to Process Analysis Requests

An AI's safety policy will not necessarily allow all operations just because "I am authorized" is added to the prompt. Only handle legally authorized targets and avoid requesting unauthorized intrusion, credential theft, persistence, or destructive operations; you can limit requests to code comprehension, sample analysis, vulnerability remediation, CTF, or defensive validation. For a specific APK, website, or account, first prepare a verifiable authorization scope and test environment.

## Python Tools and uv

Standalone command-line tools can use:

    uv tool install PACKAGE_NAME

Project dependencies should use an isolated environment:

    uv venv
    uv pip install -r requirements.txt

Do not mechanically replace all `pip` strings with `uv pip`; `python -m pip`, `pipx` bootstrap, and existing virtual environments each serve different purposes. If `uv` is not yet installed, use the operating system package manager or an explicitly created virtual environment; do not install security tools directly into the system-wide Python.

For more complete installation and archive security instructions, see [Installation and Download Security Guide](UV-AND-DOWNLOAD-SECURITY_zh.md).

## ZIP Virus Alerts and Download Security

Reverse engineering tools may contain binaries, debuggers, packers, or test data, which can easily trigger heuristic detection by antivirus software. An antivirus warning does not prove safety, nor does it prove maliciousness. Do not disable antivirus software or blindly ignore warnings.

Before opening an archive, download from the expected HTTPS repository or release page, verify the checksum or release digest (if provided), inspect the archive contents, and scan with the latest security software. Do not directly execute unknown binaries, scripts, or installers from a file just because it downloaded successfully.

## Accounts, Contributions, and Vague Reports

Please comply with the terms of service of AI clients, GitHub, tool vendors, and the target environment. The repository itself cannot guarantee that third-party platforms will not restrict accounts, nor can it decide account policies on behalf of the platform. To contribute radare2 or other skills, first read `skills/CONTRIBUTING.md` and submit via small, verifiable Pull Requests.

Only issues that include the full error message, environment information, and reproduction steps are suitable for further fixing. Reports that only say "virus", "gaha", or "test" should add the file name, download URL, scanning product, version, and reproduction method.

## External Models and APIs

This repository does not bundle, proxy, or resell the Grok/xAI API, and does not collect or distribute Grok API keys. Models and API endpoints are configured by users in their chosen AI client or provider; when using third-party forwarding services, verify the provider, data processing terms, and key risks yourself.
