#!/usr/bin/env bash
set -eu

# -----------------------------------------------------------------------------
# Ansible install script for POSIX systems
#  - Requires Python3 and pip
#  - Installs pipx + Ansible
# -----------------------------------------------------------------------------

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Check for Python3
if ! command -v python3 >/dev/null 2>&1; then
  abort "❌ Python3 not found. It is required to install ansible."
fi

# Check for pip
if ! command -v pip >/dev/null 2>&1; then
  abort "❌ pip not found. It is required to install ansible."
fi

echo "📦 Installing or upgrading pipx using pip..."
# Install pipx
python3 -m pip install --break-system-packages --user pipx
# Adds pipx local binary directory to PATH
python3 -m pipx ensurepath --force
# Force reload of shell profile to ensure PATH is updated for this session
source "$HOME/.bashrc" 2>/dev/null || source "$HOME/.bash_profile" 2>/dev/null

echo "📦 Installing ansible using pipx..."
pipx install --include-deps --force ansible

if ! command -v ansible >/dev/null 2>&1; then
  abort "❌ ansible not found."
fi

echo "✅ Ansible was installed successfully."
