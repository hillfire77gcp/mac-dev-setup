#!/usr/bin/env bash

# Install Essential CLI Tools

log_header "🔧 Installing CLI Development Tools"

if ! command_exists brew; then
    log_error "Homebrew is required but not installed. Please install Homebrew first."
    exit 1
fi

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
)

log_info "Installing CLI tools..."

for tool in "${!tools[@]}"; do
    if command_exists "$tool"; then
        log_success "$tool already installed - ${tools[$tool]}"
    else
        log_info "Installing $tool - ${tools[$tool]}"
        brew install "$tool"
        log_success "$tool installed"
    fi
done

# Install ruff separately (Python linter/formatter)
if command_exists ruff; then
    log_success "ruff already installed - Python linter and formatter"
else
    log_info "Installing ruff - Python linter and formatter"
    brew install ruff
    log_success "ruff installed"
fi

log_success "CLI tools installation complete"
