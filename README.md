# Ansible DevTools with Claude Code

Dev container template for Ansible development with Claude Code, published to GHCR. Provides a pre-configured container with the Ansible community dev tools and the Claude Code CLI.

## Template

### claude-code-ansible

Ansible development environment based on Fedora with the Ansible community dev tools image.

- ansible, ansible-lint, molecule, ansible-navigator
- Claude Code CLI
- VS Code extensions: Claude Code, Ansible, YAML, Python, GitLens, AsciiDoc

## Usage

### VS Code Command Palette

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

The template accepts the following options:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `claudeCodeVersion` | string | `latest` | Version of the Claude Code CLI to install. |
| `timezone` | string | `America/Argentina/Buenos_Aires` | Container timezone (TZ identifier). |

## Contributing

1. Fork the repository.
2. Make changes in the `src/` directory.
3. Test locally with `devcontainer templates apply` or by opening the template in VS Code.
4. Open a pull request.

## License

GPL-3.0
