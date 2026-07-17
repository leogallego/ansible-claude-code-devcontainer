<!-- BEGIN ANSIBLE-DEVCONTAINER -->
@AGENTS.md

## Claude Code Tooling

### MCP Servers (Claude-specific)

Tools are prefixed with the server name in Claude Code:

- **mcp__ansible-know__** — search_collections, search_modules,
  search_plugins, get_module_doc, get_role_doc, get_plugin_doc,
  get_collection_docs, get_collection_manifest, search_docs, fetch_doc,
  ensure_collection, generate_skill, generate_role_skill,
  generate_plugin_skill, generate_collection_skills
- **mcp__ansible__** — ansible_lint, ansible_navigator,
  create_ansible_projects, define_and_build_execution_env,
  ansible_content_best_practices, ade_setup_environment,
  ade_environment_info, adt_check_env, zen_of_ansible

### Skills (claude-ansible-skills plugin)

- **ansible-docs** — answer Ansible questions and review code using official
  documentation from ansible-core, ansible-lint, ansible-navigator,
  ansible-builder, ansible-creator, and molecule
- **ansible-good-practices** — review Ansible roles, playbooks, collections,
  and inventory against Red Hat CoP automation good practices
- **ansible-zen** — display the Zen of Ansible principles and review code
  for simplicity, readability, and clarity
- **ansible-new-collection** — scaffold a new Ansible collection
- **ansible-new-role** — scaffold a new Ansible role
- **ansible-new-ee** — scaffold a new execution environment definition
- **ansible-new-molecule** — scaffold a new Molecule test scenario

### Workflow

- Use /ansible-good-practices to review code against CoP rules
- Use /ansible-docs to answer questions from official documentation
- Use /ansible-zen for simplicity and clarity review
- Use mcp__ansible-know__ tools to look up module docs before writing tasks
- Use mcp__ansible__ ansible_lint to lint before committing
<!-- END ANSIBLE-DEVCONTAINER -->
