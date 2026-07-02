FROM ghcr.io/ansible/community-ansible-dev-tools:v26.6.1

ENV TZ="UTC"

# Install Node.js, sudo, and CLI tools (Fedora uses dnf)
RUN dnf install -y nodejs npm sudo curl jq gh uv tmux && dnf clean all

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

ENV DEVCONTAINER=true

# Symlink ~/.ansible to /workspace/.ansible so all Ansible tools
# (galaxy, lint, navigator) converge under the workspace mount
RUN rm -rf /root/.ansible && ln -s /workspace/.ansible /root/.ansible

# Copy and set up registry auth script
COPY init-registry-auth.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-registry-auth.sh

WORKDIR /workspace
