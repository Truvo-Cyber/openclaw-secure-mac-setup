# Contributing

Issues are welcome. Pull requests are welcome for corrections to docs and diagrams and for changes verified against the OpenClaw version listed in the README.

## What this repo is

Configs, diagrams and a threat model from a lab build tested by Truvo Cyber. Each setting was tested on the versions in the README, so a merged change needs the same test. OpenClaw changes quickly, and a setting that moved in a newer version is a useful report.

## Good issues and pull requests

- A setting name, default or behavior that differs on a newer OpenClaw, Lume or macOS version. Include the version and the command output that shows it.
- A typo, broken link or unclear sentence in the README, threat model or diagrams.
- A mismatch between a diagram and the configs.

## How changes are reviewed

- One change per pull request, with the version you tested on.
- A maintainer re-tests configuration changes in the lab before merging. Merging can take time.
- Pull requests that add third-party skills, plugins, or settings that widen the agent's tools or network access are declined.
- Contributions to `config/` are licensed under MIT. Contributions to `diagrams/`, `docs/` and the README are licensed under CC BY 4.0, matching the repo's license files.

## Security reports

See [SECURITY.md](SECURITY.md). Do not post secrets, tokens or private keys in issues or pull requests.
