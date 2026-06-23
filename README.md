# Ansible DevTools with Claude Code

Dev container template for Ansible development with Claude Code, published to GHCR. Provides a pre-configured container with the Ansible community dev tools, the Claude Code CLI, and a network sandbox.

## Template

### claude-code-ansible

Ansible development environment based on Fedora with the Ansible community dev tools image.

- ansible, ansible-lint, molecule, ansible-navigator
- Claude Code CLI
- VS Code extensions: Claude Code, Ansible, YAML, Python, GitLens, AsciiDoc
- Proxy sandbox (Tinyproxy + nftables)

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
| `timezone` | string | `America/Los_Angeles` | Container timezone (TZ identifier). |
| `enableProxy` | boolean | `true` | Enable the Tinyproxy + nftables network sandbox at startup. |

## Network Sandbox

When `enableProxy` is `true`, the container starts a Tinyproxy forward proxy enforced by nftables rules. All outbound traffic is routed through the proxy, and direct connections are blocked. HTTPS CONNECT requests are filtered by domain against an allowlist.

**Commands:**

```bash
# Check status
sudo /usr/local/bin/init-proxy.sh --status

# Disable the sandbox
sudo /usr/local/bin/init-proxy.sh --disable

# Re-enable the sandbox
sudo /usr/local/bin/init-proxy.sh
```

**Editing the allowlist:**

The runtime allowlist is at `/etc/tinyproxy/allowlist` (one regex pattern per line). To add a domain temporarily:

```bash
echo 'newdomain\.example\.com' >> /etc/tinyproxy/allowlist
sudo pkill tinyproxy && sudo tinyproxy -c /etc/tinyproxy/tinyproxy.conf
```

To make the change permanent, edit `proxy-allowlist.txt` in the template source under `src/` and rebuild the container.

Proxy logs are written to `/var/log/tinyproxy/tinyproxy.log`.

## Contributing

1. Fork the repository.
2. Make changes in the `src/` directory.
3. Test locally with `devcontainer templates apply` or by opening the template in VS Code.
4. Open a pull request.

## License

GPL-3.0
