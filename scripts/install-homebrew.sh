#!/usr/bin/env bash
set -euo pipefail

# Install Homebrew Package Manager

log_header "🍺 Installing Homebrew"

if command_exists brew; then
    log_success "Homebrew is already installed"
    brew --version
else
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Verify installation succeeded
    if ! command_exists brew; then
        log_error "Homebrew installation failed. Please install manually from https://brew.sh"
        exit 1
    fi

    log_success "Homebrew installed successfully"
fi

# Update Homebrew
log_info "Updating Homebrew..."
brew update

log_success "Homebrew setup complete"
