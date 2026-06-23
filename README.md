# Ansible DevTools with Claude Code

[![Release](https://github.com/leogallego/ansible-claude-code-devcontainer/actions/workflows/release.yml/badge.svg)](https://github.com/leogallego/ansible-claude-code-devcontainer/actions/workflows/release.yml)
[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-blue)](LICENSE)

AI-assisted Ansible development environment as a dev container template. Claude Code with Ansible MCP servers and skills pre-configured, built on the official [community-ansible-dev-tools](https://github.com/ansible/ansible-dev-tools) image. One command to start.

## What's Included

### Ansible Toolchain

Built on `ghcr.io/ansible/community-ansible-dev-tools:latest` (Fedora) — the same toolchain Red Hat ships for Ansible development:

- ansible, ansible-lint, ansible-navigator, ansible-builder
- molecule, pytest, podman (execution environment ready)
- python, pip, git

### AI Tooling

Claude Code CLI with Ansible-specific integrations configured at container startup:

- **[ansible-know](https://github.com/ansible-community/ansible-know-mcp)** MCP server — module/role documentation lookup, Galaxy search, skill generation
- **[ansible-mcp-server](https://github.com/ansible/ansible-mcp-server)** — ansible-lint, ansible-navigator, project scaffolding, best practices
- **[ansible-skills plugin](https://github.com/leogallego/claude-ansible-skills)** — 6 skills for scaffolding roles/collections/EEs, reviewing code against CoP good practices, querying Ansible docs, and applying the Zen of Ansible

### VS Code Extensions

Claude Code, Ansible, YAML, Python, Pylance, debugpy, Black, GitLens, AsciiDoc, Remote Containers

### Container Registry Auth

Built-in multi-registry authentication via environment variables — pass `REGISTRY_REDHAT_IO_TOKEN`, `QUAY_TOKEN`, or `DOCKER_TOKEN` to authenticate with Red Hat, Quay.io, or Docker Hub automatically at startup.

## Quick Start

### VS Code

1. Open the command palette (`Ctrl+Shift+P` / `Cmd+Shift+P`).
2. Run **Dev Containers: Add Dev Container Configuration Files...**
3. Search for `claude-code-ansible` and select the template.
4. Configure the template options when prompted.
5. Reopen the folder in the container.

### CLI

```bash
devcontainer templates apply -t ghcr.io/leogallego/ansible-claude-code-devcontainer/claude-code-ansible
```

## Template Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `claudeCodeVersion` | string | `latest` | Version of the Claude Code CLI to install. |
| `timezone` | string | `America/Argentina/Buenos_Aires` | Container timezone (TZ identifier). |

## AI-Assisted Ansible Development

The MCP servers and skills plugin give Claude Code deep Ansible awareness inside the container:

- **Module docs** — look up parameters, examples, and return values for any Ansible module directly from official documentation or Galaxy
- **Best practices review** — review roles and playbooks against Red Hat Communities of Practice automation good practices
- **Scaffolding** — generate new roles, collections, and execution environments following CoP conventions
- **Linting** — run ansible-lint with fix suggestions from within Claude Code
- **Galaxy search** — discover collections and modules by keyword without leaving the terminal

All integrations are configured automatically via `postCreateCommand` — no manual MCP setup required.

## Vertex AI Support

The template supports Claude Code via Vertex AI. Set these environment variables on your host:

- `CLAUDE_CODE_USE_VERTEX` — enable Vertex AI backend
- `ANTHROPIC_VERTEX_PROJECT_ID` — your GCP project ID
- `CLOUD_ML_REGION` — Vertex AI region (e.g., `us-east5`)

The container mounts `~/.config/gcloud` read-only for credential access.

## Contributing

1. Fork the repository.
2. Make changes in the `src/` directory.
3. Test locally with `devcontainer templates apply` or by opening the template in VS Code.
4. Open a pull request.

## License

GPL-3.0
