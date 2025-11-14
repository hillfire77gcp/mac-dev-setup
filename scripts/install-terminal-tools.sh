#!/usr/bin/env bash
set -euo pipefail

# Install Modern Terminal Tools

log_header "✨ Installing Modern Terminal Tools"

if ! command_exists brew; then
    log_error "Homebrew is required but not installed. Please install Homebrew first."
    exit 1
fi

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

for tool in "${!tools[@]}"; do
    if command_exists "$tool"; then
        log_success "$tool already installed - ${tools[$tool]}"
    else
        log_info "Installing $tool - ${tools[$tool]}"
        brew install "$tool"
        log_success "$tool installed"
    fi
done

# Install fzf key bindings and fuzzy completion
if command_exists fzf; then
    log_info "Setting up fzf key bindings..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true
fi

log_success "Modern terminal tools installation complete"
