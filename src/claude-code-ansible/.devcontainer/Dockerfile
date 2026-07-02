FROM ghcr.io/ansible/community-ansible-dev-tools:v26.6.1

ENV TZ="UTC"

# Install Node.js, sudo, and CLI tools (Fedora uses dnf)
RUN dnf install -y nodejs npm sudo curl jq gh uv tmux unzip && dnf clean all

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Download Abbenay AI provider gateway (VS Code extension + bundled daemon)
# Set to "none" to skip. See: https://github.com/redhat-developer/abbenay
ARG ABBENAY_VERSION=v2026.6.4
RUN if [ "$ABBENAY_VERSION" != "none" ]; then \
      arch=$(uname -m | sed 's/x86_64/x64/' | sed 's/aarch64/arm64/') && \
      version_num=$(echo "$ABBENAY_VERSION" | sed 's/^v//') && \
      curl -fsSL -L "https://github.com/redhat-developer/abbenay/releases/download/${ABBENAY_VERSION}/abbenay-provider-linux-${arch}-${version_num}.vsix" \
        -o /opt/abbenay-provider.vsix; \
    fi

# Default Abbenay config (env var based, no keychain in containers)
RUN mkdir -p /root/.config/abbenay
COPY abbenay-config.yaml /root/.config/abbenay/config.yaml

ENV DEVCONTAINER=true

# Symlink ~/.ansible to /workspace/.ansible so all Ansible tools
# (galaxy, lint, navigator) converge under the workspace mount
RUN rm -rf /root/.ansible && ln -s /workspace/.ansible /root/.ansible

# Copy and set up registry auth script
COPY init-registry-auth.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-registry-auth.sh

WORKDIR /workspace
