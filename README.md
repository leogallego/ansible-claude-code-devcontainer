# Ansible DevTools with Claude Code

[![Release](https://github.com/leogallego/ansible-claude-code-devcontainer/actions/workflows/release.yml/badge.svg)](https://github.com/leogallego/ansible-claude-code-devcontainer/actions/workflows/release.yml)
[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-blue)](LICENSE)

AI-assisted Ansible development environment as a dev container template. Claude Code with Ansible MCP servers, skills, and the Abbenay AI gateway pre-configured, built on the official [community-ansible-dev-tools](https://github.com/ansible/ansible-dev-tools) image. One command to start.

## What's Included

### Ansible Toolchain

Built on the [community-ansible-dev-tools](https://github.com/ansible/ansible-dev-tools) container image (Fedora) — the same toolchain Red Hat ships for Ansible development. The base image version is pinned in the [Dockerfile](src/claude-code-ansible/.devcontainer/Dockerfile). Includes all 10 tools from the ansible-dev-tools bundle:

ansible-core, ansible-builder, ansible-creator, ansible-lint, ansible-navigator, ansible-sign, molecule, pytest-ansible, tox-ansible, ansible-dev-environment

Plus podman for execution environment support.

### AI Tooling

Claude Code CLI with Ansible-specific integrations configured at container startup:

- **[ansible-know](https://github.com/leogallego/ansible-know-mcp)** MCP server — module/role documentation lookup, Galaxy search, skill generation
- **[ansible-devtools-mcp](https://github.com/ansible/vscode-ansible)** — ansible-lint, ansible-navigator, project scaffolding, best practices
- **[ansible-skills plugin](https://github.com/leogallego/claude-ansible-skills)** — 7 skills for scaffolding roles/collections/EEs/molecule scenarios, reviewing code against CoP good practices, querying Ansible docs, and applying the Zen of Ansible

All integrations are configured automatically via `postCreateCommand` — no manual MCP setup required.

### Abbenay AI Gateway

[Abbenay](https://github.com/redhat-developer/abbenay) is bundled as an OpenAI-compatible API gateway that abstracts 19+ LLM providers behind a single endpoint. The daemon starts automatically on port 8788 and can be used by Ansible Lightspeed or any tool that speaks the OpenAI API.

Set `ABBENAY_VERSION=none` as a build arg to opt out.

### AI Provider Support

The template supports multiple AI backends for Claude Code and Abbenay. All variables are optional and forwarded from your host.

**Claude Code** — configure the Claude Code CLI and VS Code extension. Use either an Anthropic API key or Vertex AI credentials.

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Anthropic API key (alternative to Vertex AI or `claude login`) |
| `CLAUDE_CODE_USE_VERTEX` | Enable Vertex AI backend |
| `ANTHROPIC_VERTEX_PROJECT_ID` | GCP project ID |
| `CLOUD_ML_REGION` | Vertex AI region, e.g. `us-east5` |

**Abbenay** — configure these to use Abbenay as an AI gateway for Ansible Lightspeed, GitHub Copilot, and other VS Code extensions that use the Language Model API. Abbenay also exposes an OpenAI-compatible endpoint on port 8788. Set the variables for whichever LLM provider you want to use (Vertex AI, OpenRouter, Google AI Studio, or local Ollama).

| Variable | Description |
|----------|-------------|
| `GOOGLE_VERTEX_PROJECT` | GCP project ID (for Vertex AI providers like Claude, Gemini) |
| `GOOGLE_VERTEX_LOCATION` | Vertex AI region |
| `OPENROUTER_API_KEY` | OpenRouter API key (access to 100+ models) |
| `GOOGLE_GENERATIVE_AI_API_KEY` | Google Generative AI API key (for Gemini via AI Studio) |

The container mounts `~/.config/gcloud` read-only for credential access. Vertex AI users do not need an Anthropic account or API key.

### Environment Variables

All environment variables are optional and forwarded from your host automatically.

| Variable | Description |
|----------|-------------|
| `GH_TOKEN` | GitHub personal access token (for `gh` CLI and GitHub MCP) |
| `ANSIBLE_GALAXY_SERVER_AUTOMATION_HUB_TOKEN` | Ansible Automation Hub token (also populates `AH_TOKEN` and `ANSIBLE_GALAXY_SERVER_AH_TOKEN`) |
| `REGISTRY_REDHAT_IO_TOKEN` | Red Hat container registry (`registry.redhat.io`) token |
| `QUAY_TOKEN` | Quay.io container registry token |
| `DOCKER_TOKEN` | Docker Hub token |
| `DOCKER_USER` | Docker Hub username (required with `DOCKER_TOKEN`) |

Container registry tokens are used at startup to authenticate via `podman login`, enabling pulls of execution environment images from private registries.

### Persistent Volumes

The container uses named container volumes (Docker or Podman) to persist data across rebuilds:

- **Bash history** — command history survives container recreation
- **Claude config** (`~/.claude`) — Claude Code settings, MCP config, and session data
- **VS Code extensions** — avoids reinstalling extensions on rebuild

### VS Code Extensions

Claude Code, Ansible, YAML, Python, Pylance, Black, AsciiDoc

## Prerequisites

- **Docker** or **Podman** running on your host
- **VS Code** with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- A Claude Code account (Anthropic API key, Vertex AI credentials, or `claude login`). Not required when using Vertex AI.

## Quick Start

### Option 1: VS Code UI

1. Open your project in VS Code
2. `Ctrl+Shift+P` / `Cmd+Shift+P` -> **Dev Containers: Add Dev Container Configuration Files...**
3. Select **Add to workspace**
4. Search for **Ansible Development Tools**
5. No additional options to configure — select **OK** / **Done**
6. **Dev Containers: Reopen in Container**

Alternatively, select **Add to user data folder** in step 3 to store the configuration in your VS Code user settings instead of the project. This lets you use the same devcontainer across multiple projects without adding files to each repo.

### Option 2: CLI

Apply the template to your project directory, then open it in VS Code:

```bash
cd your-ansible-project/
npx @devcontainers/cli templates apply \
  -t ghcr.io/leogallego/ansible-claude-code-devcontainer/claude-code-ansible
```

Then in VS Code: `Ctrl+Shift+P` / `Cmd+Shift+P` -> **Dev Containers: Reopen in Container**

### First start

The first build pulls the base image and installs dependencies (~3-5 minutes). On startup the container automatically:

- Installs the Claude Code CLI
- Registers the ansible-know and ansible-mcp-server MCP servers
- Installs the ansible-skills plugin with all 7 skills
- Extracts and starts the Abbenay daemon on port 8788
- Runs container registry authentication (if credentials are provided)

Subsequent starts reuse cached layers and are fast.

### Authenticating Claude Code

Once inside the container, run `claude` in the terminal. On first launch you'll be prompted to authenticate — follow the instructions to log in with your Anthropic account or API key.

For Vertex AI authentication, see the [AI Provider Support](#ai-provider-support) section above.

### Checking the version

From inside the container:

```bash
echo $DEVCONTAINER_TEMPLATE_VERSION
# or
cat /etc/devcontainer-version
```

## Contributing

1. Fork the repository.
2. Make changes in the `src/` directory.
3. Test locally with `devcontainer templates apply` or by opening the template in VS Code.
4. Open a pull request.

## Author

[Leo Gallego](https://github.com/leogallego)

## License

GPL-3.0
