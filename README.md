# Ansible DevTools with Claude Code

[![Release](https://github.com/leogallego/ansible-claude-code-devcontainer/actions/workflows/release.yml/badge.svg)](https://github.com/leogallego/ansible-claude-code-devcontainer/actions/workflows/release.yml)
[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-blue)](LICENSE)

AI-assisted Ansible development environment as a dev container template. Claude Code with Ansible MCP servers and skills pre-configured, built on the official [community-ansible-dev-tools](https://github.com/ansible/ansible-dev-tools) image. One command to start.

## What's Included

### Ansible Toolchain

Built on `ghcr.io/ansible/community-ansible-dev-tools:latest` (Fedora) — the same toolchain Red Hat ships for Ansible development. Includes all 10 tools from the [ansible-dev-tools](https://github.com/ansible/ansible-dev-tools) bundle:

ansible-core, ansible-builder, ansible-creator, ansible-lint, ansible-navigator, ansible-sign, molecule, pytest-ansible, tox-ansible, ansible-dev-environment

Plus podman for execution environment support.

### AI Tooling

Claude Code CLI with Ansible-specific integrations configured at container startup:

- **[ansible-know](https://github.com/ansible-community/ansible-know-mcp)** MCP server — module/role documentation lookup, Galaxy search, skill generation
- **[ansible-mcp-server](https://github.com/ansible/ansible-mcp-server)** — ansible-lint, ansible-navigator, project scaffolding, best practices
- **[ansible-skills plugin](https://github.com/leogallego/claude-ansible-skills)** — 6 skills for scaffolding roles/collections/EEs, reviewing code against CoP good practices, querying Ansible docs, and applying the Zen of Ansible

All integrations are configured automatically via `postCreateCommand` — no manual MCP setup required.

### Vertex AI Support

The template supports Claude Code via Vertex AI. Set these environment variables on your host before opening the container:

| Variable | Description |
|----------|-------------|
| `CLAUDE_CODE_USE_VERTEX` | Enable Vertex AI backend |
| `ANTHROPIC_VERTEX_PROJECT_ID` | Your GCP project ID |
| `CLOUD_ML_REGION` | Vertex AI region (e.g., `us-east5`) |

The container mounts `~/.config/gcloud` read-only for credential access.

### Environment Variables

All environment variables are optional and forwarded from your host automatically.

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Anthropic API key for Claude Code (alternative to `claude login`) |
| `GH_TOKEN` | GitHub personal access token (for `gh` CLI and GitHub MCP) |
| `AH_TOKEN` | Ansible Automation Hub token |
| `REGISTRY_REDHAT_IO_TOKEN` | Red Hat container registry (`registry.redhat.io`) token |
| `QUAY_TOKEN` | Quay.io container registry token |
| `DOCKER_TOKEN` | Docker Hub token |
| `DOCKER_USER` | Docker Hub username (required with `DOCKER_TOKEN`) |

Container registry tokens are used at startup to authenticate via `podman login`, enabling pulls of execution environment images from private registries.

### Persistent Volumes

The container uses named Docker volumes to persist data across rebuilds:

- **Bash history** — command history survives container recreation
- **Claude config** (`~/.claude`) — Claude Code settings, MCP config, and session data
- **VS Code extensions** — avoids reinstalling extensions on rebuild

### VS Code Extensions

Claude Code, Ansible, YAML, Python, Pylance, Black, GitLens, AsciiDoc

## Prerequisites

- **Docker** or **Podman** running on your host
- **VS Code** with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- A Claude Code account (Anthropic API key or Vertex AI credentials)

## Quick Start

### Option 1: CLI

Apply the template to your project directory, then open it in VS Code:

```bash
cd your-ansible-project/
npx @devcontainers/cli templates apply \
  -t ghcr.io/leogallego/ansible-claude-code-devcontainer/claude-code-ansible
```

Then in VS Code: `Ctrl+Shift+P` / `Cmd+Shift+P` → **Dev Containers: Reopen in Container**

### Option 2: VS Code UI

1. Open your project in VS Code
2. `Ctrl+Shift+P` / `Cmd+Shift+P` → **Dev Containers: Add Dev Container Configuration Files...**
3. Select **Add to workspace** or **Add to user data folder**
4. Search for `claude-code-ansible`
5. Choose template options (Claude Code version, timezone)
6. **Dev Containers: Reopen in Container**

### First start

The first build pulls the base image and installs dependencies (~3-5 minutes). On startup the container automatically:

- Installs the Claude Code CLI
- Registers the ansible-know and ansible-mcp-server MCP servers
- Installs the ansible-skills plugin with all 6 skills
- Runs container registry authentication (if credentials are provided)

Subsequent starts reuse cached layers and are fast.

### Authenticating Claude Code

Once inside the container, run `claude` in the terminal. On first launch you'll be prompted to authenticate — follow the instructions to log in with your Anthropic account or API key.

For Vertex AI authentication, see the [Vertex AI Support](#vertex-ai-support) section below.

## Template Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `claudeCodeVersion` | string | `latest` | Version of the Claude Code CLI to install. |
| `timezone` | string | `America/Argentina/Buenos_Aires` | Container timezone (TZ identifier). |

## Contributing

1. Fork the repository.
2. Make changes in the `src/` directory.
3. Test locally with `devcontainer templates apply` or by opening the template in VS Code.
4. Open a pull request.

## Author

[Leo Gallego](https://github.com/leogallego)

## License

GPL-3.0
