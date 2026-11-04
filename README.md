# OpenClaw secure Mac setup

Configs, diagrams and a threat model for running [OpenClaw](https://github.com/openclaw/openclaw) as a locked-down, single-user agent in a macOS virtual machine, with Slack DMs and Google Cloud Vertex AI. Everything here comes from a lab build tested by [Truvo Cyber](https://truvocyber.com) in October 2026.

**Tested versions:** OpenClaw 2026.10.7, Lume 0.6.1, macOS 26.5.2 guest, Node.js 24.22.1. OpenClaw changes quickly. Re-check each setting after every update.

**Write-ups:**
- [How to Set Up OpenClaw Safely on a Mac: 10 Security Settings We Tested](https://truvocyber.com/blog/set-up-openclaw-safely-mac)
- [What Is OpenClaw? Answers From a Security Consultant's Install](https://truvocyber.com/blog/what-is-openclaw)

## The 10 security settings

| # | Setting | Where in this repo |
|---|---|---|
| 1 | Run OpenClaw in a macOS VM (Lume), no shared folders, no Apple ID | [Setup post, step 1](https://truvocyber.com/blog/set-up-openclaw-safely-mac) |
| 2 | Agent-owned Google Cloud service account, one role: Vertex AI User | [`docs/threat-model.md`](docs/threat-model.md), [`config/openclaw-gateway-wrapper.sh`](config/openclaw-gateway-wrapper.sh) |
| 3 | Enforced spend cap on Vertex AI | [`docs/threat-model.md`](docs/threat-model.md) |
| 4 | Messaging tool profile, shell/file/web groups denied | [`config/openclaw-tools.json5`](config/openclaw-tools.json5) |
| 5 | Code mode off | [`config/openclaw-tools.json5`](config/openclaw-tools.json5) |
| 6 | Gateway on loopback with token auth | [`config/openclaw-network.json5`](config/openclaw-network.json5) |
| 7 | Bonjour and mDNS discovery off | [`config/openclaw-network.json5`](config/openclaw-network.json5) |
| 8 | DM-only Slack app, Socket Mode, allowlist of named users | [`config/slack-app-manifest.json`](config/slack-app-manifest.json), [`config/openclaw-slack.json5`](config/openclaw-slack.json5) |
| 9 | Tokens typed into the OpenClaw secret store | [`config/openclaw-slack.json5`](config/openclaw-slack.json5) |
| 10 | macOS firewall on, Lume blocked inbound, key-only SSH from the host | [`config/macos-firewall.sh`](config/macos-firewall.sh), [`config/sshd-openclaw-vm.conf`](config/sshd-openclaw-vm.conf) |

## Diagrams

Editable [draw.io](https://www.drawio.com) sources plus PNG exports:

- [`diagrams/openclaw-security-settings-map.drawio`](diagrams/openclaw-security-settings-map.drawio): where each of the 10 settings applies
- [`diagrams/openclaw-reference-architecture.drawio`](diagrams/openclaw-reference-architecture.drawio): the reference architecture. The SVG export animates data flows

Line and border conventions: a solid line with a dot is a network connection (the dot marks the side that opens it), moving or thin lines are data, dashed boxes are trust zones, grey dotted items are planned and not built.

## Threat model

[`docs/threat-model.md`](docs/threat-model.md) lists every credential with scope, storage and revocation, the network checks to run from a second device, accepted risks, top risks with mitigations, what to change before giving the agent a shell, and the kill switch.

## Disclaimer

Provided as-is for learning and reference. Review each setting against your own environment and the current OpenClaw documentation before use. Not affiliated with the OpenClaw Foundation or Lume.

## License

- `config/`: MIT, see [LICENSE](LICENSE)
- `diagrams/`, `docs/` and this README: CC BY 4.0, see [LICENSE-DIAGRAMS-AND-DOCS.md](LICENSE-DIAGRAMS-AND-DOCS.md). Reuse is welcome with credit to Truvo Cyber.

## Maintainer

Maintained by Ali Aleali, CISSP, CCSP, Truvo Cyber. Issues and suggestions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for what a good issue or pull request looks like and [SECURITY.md](SECURITY.md) for reporting problems.
