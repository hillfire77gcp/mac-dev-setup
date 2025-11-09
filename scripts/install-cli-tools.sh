#!/usr/bin/env bash
# Install Essential CLI Tools

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "🔧 Installing CLI Development Tools"

check_homebrew

# Define tools to install
declare -A tools=(
    ["mise"]="Version manager for Python, Node.js, etc."
    ["uv"]="Fast Python package installer"
    ["just"]="Command runner (like make but better)"
    ["gh"]="GitHub CLI"
    ["git"]="Version control"
    ["jq"]="JSON processor"
    ["yq"]="YAML processor"
    ["chezmoi"]="Dotfiles manager"
    ["copier"]="Project template tool"
    ["ruff"]="Python linter and formatter"
)

log_info "Installing CLI tools..."
install_brew_tools tools

log_success "CLI tools installation complete"
