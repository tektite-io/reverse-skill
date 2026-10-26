# Installation and Download Security Guide

## Prefer uv for Managing Python Environments

Standalone command-line tools can be installed with `uv tool install <package>`. For project dependencies, first create a virtual environment:

    uv venv
    uv pip install -r requirements.txt

Do not mechanically replace all `pip` commands. `uv pip` is suitable for already-created virtual environments, while standalone CLI tools are usually better installed with `uv tool install`. To improve reproducibility, pin dependency versions or commit a lock file whenever possible.

## Safely Handling Downloaded Archives

Reverse engineering and security testing tools may contain binaries, debuggers, packers, or security test data, so they can easily trigger heuristic detection by antivirus software. An antivirus warning does not prove safety, nor does it prove maliciousness.

Do not disable antivirus software or blindly ignore warnings. Before opening an archive, confirm the file comes from the expected HTTPS repository or release page; if a checksum or release digest is available, compare it first; then inspect the archive contents and scan with the latest security software. Do not directly execute unknown binaries, scripts, or installers from a file just because it downloaded successfully.
