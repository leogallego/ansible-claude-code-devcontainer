<!-- BEGIN ANSIBLE-DEVCONTAINER -->
## Ansible Development Environment

This workspace runs inside the Ansible Development Tools devcontainer,
built on community-ansible-dev-tools (Fedora).

### Installed Toolchain

ansible-core, ansible-builder, ansible-creator, ansible-lint,
ansible-navigator, ansible-sign, molecule, pytest-ansible,
tox-ansible, ansible-dev-environment, podman

### MCP Servers

- **ansible-know** (ansible-know-mcp, @ansible-know) — Galaxy search,
  module/role/plugin documentation lookup, collection manifests, skill
  generation. Package: uvx ansible-know-mcp.
- **ansible** (ansible-devtools-mcp, @ansible/ansible-mcp-server,
  ansible-mcp-server) — ansible-lint, ansible-navigator, ansible-creator
  project scaffolding, execution environment definition, best practices
  guidance. Package: npx @ansible/ansible-mcp-server.

### Key Paths

- Workspace: /workspace
- Ansible data: /workspace/.ansible/{collections,roles,galaxy_cache,tmp}
- Collections: ANSIBLE_COLLECTIONS_PATH=/workspace/collections:/root/.ansible/collections:/usr/share/ansible/collections
- Roles: ANSIBLE_ROLES_PATH=/workspace/roles:/root/.ansible/roles:/usr/share/ansible/roles
- Cache: XDG_CACHE_HOME=/workspace/.cache

### Abbenay AI Gateway

OpenAI-compatible API on localhost:8788. Abstracts 19+ LLM providers behind
a single endpoint. Used by Ansible Lightspeed and any tool that speaks the
OpenAI API.

### Key Ansible Rules

1. Always use fully qualified collection names: ansible.builtin.copy, not copy
2. Prefix all role variables with the role name: myrole_packages, not packages
3. Prefix internal variables with double underscore: __myrole_internal_var
4. Use true/false for booleans, never yes/no or True/False
5. Every role must be idempotent — second run produces no changes
6. Add changed_when: to command/shell tasks
7. Use ansible_facts['distribution'] bracket notation, never ansible_distribution
8. Keep playbooks simple — logic belongs in roles, not playbooks
9. Never mix roles: and tasks: in the same play
10. Use snake_case for all names (files, variables, roles, dictionary keys)

### Workflow Tips

- Look up module documentation via the ansible-know MCP server before
  guessing parameters or syntax
- Use ansible-lint (via the ansible MCP server or CLI) before committing
- Use ansible-navigator for playbook execution and troubleshooting
- Use ansible-creator for scaffolding new collections, roles, and projects
<!-- END ANSIBLE-DEVCONTAINER -->
