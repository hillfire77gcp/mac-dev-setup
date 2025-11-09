#!/usr/bin/env bash
# Install Modern Terminal Tools

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "✨ Installing Modern Terminal Tools"

check_homebrew

# Define modern CLI tools
declare -A tools=(
    ["starship"]="Beautiful cross-shell prompt"
    ["zoxide"]="Smarter cd command"
    ["fzf"]="Fuzzy finder"
    ["eza"]="Modern replacement for ls"
    ["bat"]="Better cat with syntax highlighting"
    ["fd"]="Better find command"
    ["ripgrep"]="Better grep (rg)"
    ["tldr"]="Simplified man pages"
    ["htop"]="Interactive process viewer"
    ["ncdu"]="Disk usage analyzer"
)

log_info "Installing modern terminal tools..."
install_brew_tools tools

# Install fzf key bindings and fuzzy completion
if command_exists fzf; then
    log_info "Setting up fzf key bindings..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true
fi

log_success "Modern terminal tools installation complete"
