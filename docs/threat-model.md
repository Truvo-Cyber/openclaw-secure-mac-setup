# OpenClaw on a Mac: threat model and mitigations

Template for a single-user, messaging-only OpenClaw agent in a macOS virtual machine, with Slack DMs and Google Cloud Vertex AI. Based on a lab build tested 2026-10-23 to 2026-10-25 on OpenClaw 2026.10.7 and Lume 0.6.1. Fill in the bracketed parts for your own build and keep one row per credential.

## Credentials the agent holds

| Credential | Scope | Where it is stored | How to revoke |
|---|---|---|---|
| Google Cloud service account key (JSON) | One role: Vertex AI User (`roles/aiplatform.user`), in a dedicated project with an enforced spend cap on Vertex AI | Inside the VM only, `~/.openclaw-secrets/`, mode 0600 | Cloud Console, IAM, Service accounts, `[name]`, Keys, delete |
| Slack bot token (`xoxb-`) and app token (`xapp-`) | DM only: `chat:write`, `im:history`, `im:read`, `im:write`, `users:read`. OpenClaw answers an allowlist of named users | OpenClaw protected secret store (write-only to CLI, UI and agent). The store is an unencrypted SQLite file readable by the VM user | api.slack.com/apps, `[app]`, revoke tokens or remove the app |
| OpenClaw gateway token | Local gateway clients | OpenClaw protected secret store | Rotate in OpenClaw or reinstall |

Clones of the VM hold copies of every credential. Revoke at the source, and delete clones when the experiment ends.

## What the agent cannot reach

- Host Mac files, browser sessions, keychain and Apple ID (no shared folders, no Apple ID in the VM)
- Shell, files, web, browser, nodes, automation, sub-agents (denied tool groups, code mode off)
- Inbound network access from other devices (loopback gateway, Socket Mode outbound only, host firewall, key-only SSH from the host)
- Third-party skills (none installed)

## Network exposure checks

| Check | How to verify | Expected |
|---|---|---|
| Gateway listen address | `lsof -iTCP -sTCP:LISTEN` inside the VM | `127.0.0.1:18789` and `::1` only |
| Network discovery | Config: Bonjour plugin disabled, `discovery.mdns.mode: off` | No mDNS advertisement |
| VM screen (Lume VNC) | VNC connection from a second device to the Mac's LAN address | Fails or times out |
| VM SSH | SSH from a second device, and password login from the host | Both refused |

A test from the Mac itself proves nothing: traffic to the Mac's own address never leaves the Mac.

## Accepted risks

- **Automatic login for the VM user.** OpenClaw installs as a LaunchAgent, which needs a logged-in session. macOS stores the password obfuscated, not encrypted, in `/etc/kcpassword`. The VM screen is reachable from the host only.
- **Service account key readable by the VM user.** The messaging-only agent has no file or shell tools to read the key. Anything else running as the VM user can.
- **VM user is an admin inside the VM.** Keep a passphrase on the account. An empty password gives anything running as that user an easy path to root.

## Top risks and mitigations

OWASP mapping uses the [OWASP Top 10 for Agentic Applications 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026) (ASI) and the [OWASP Top 10 for LLM Applications 2025](https://genai.owasp.org/llm-top-10/) (LLM).

| Risk | OWASP mapping | Mitigation |
|---|---|---|
| Prompt injection through content the agent reads | ASI01 Agent Goal Hijack, LLM01 Prompt Injection | Messaging-only tools, no web access, no business data yet. Add data sources one at a time with read-only credentials, and keep web access and private data in separate agents |
| Token theft from the VM | ASI03 Identity and Privilege Abuse, LLM02 Sensitive Information Disclosure | Narrow scopes, every credential revocable at the source in minutes, no inbound path to the VM except host SSH |
| Runaway spend | LLM10 Unbounded Consumption | Enforced spend cap on Vertex AI. Confirm the cap covers every model the agent can reach, including Marketplace-billed models |
| Agent gains a code-execution tool through a plugin, config drift or a new default | ASI05 Unexpected Code Execution (RCE), LLM06 Excessive Agency | Explicit tool deny list, code mode off, and a tool-list check in a fresh session after every OpenClaw update |
| Unreviewed plugins or skills | ASI04 Agentic Supply Chain Vulnerabilities, LLM03 Supply Chain | No third-party skills. Set `plugins.allow` and pin plugin installs to exact versions (both flagged by `openclaw security audit`) |
| Gateway or VM screen reachable from the network | No direct OWASP entry (infrastructure exposure) | Loopback gateway, discovery off, host firewall with the VM manager blocked, key-only SSH from the host. Verify from a second device |

## Before giving the agent a shell

With sandboxing off (the OpenClaw default, confirmed with `openclaw sandbox explain`), shell commands run as the VM user and can read the service account key, the secret store database and anything else in the VM, and can reach the internet. Before enabling `group:runtime`:

- Set exec security to `allowlist` or `ask` (the audit flags `full`)
- Run commands in a sandbox backend, or on a separate disposable machine over SSH that holds only what the job needs
- Keep web access off for any agent that holds private data
- Add a row to the credentials table for every new key

## Kill switch

1. Stop the VM: `lume stop [vm-name]`
2. Revoke at the source: service account key first, then the Slack app or both Slack tokens
3. Restore the clean clone before any restart
