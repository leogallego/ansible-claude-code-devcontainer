FROM ghcr.io/ansible/community-ansible-dev-tools:latest

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=latest

# Install Node.js, sudo, and CLI tools (Fedora uses dnf)
RUN dnf install -y nodejs npm sudo curl jq gh uv && dnf clean all

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

ENV DEVCONTAINER=true

# Copy and set up registry auth script
COPY init-registry-auth.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-registry-auth.sh

WORKDIR /workspace
