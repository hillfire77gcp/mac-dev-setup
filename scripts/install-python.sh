#!/usr/bin/env bash
set -euo pipefail

# Install Python Environment

log_header "🐍 Setting up Python Environment"

if ! command_exists mise; then
    log_error "mise is required but not installed. Please install CLI tools first."
    exit 1
fi

# Install Python 3.12 via mise
log_info "Installing Python 3.12 via mise..."

if mise list python | grep -q "3.12"; then
    log_success "Python 3.12 already installed via mise"
else
    mise install python@3.12
    log_success "Python 3.12 installed"
fi

# Set Python 3.12 as global default
log_info "Setting Python 3.12 as global default..."
mise use -g python@3.12

# Verify installation
PYTHON_VERSION=$(mise exec python@3.12 -- python --version)
log_success "Python installed: $PYTHON_VERSION"

# Install common Python tools globally
log_info "Installing Python development tools..."
mise exec python@3.12 -- python -m pip install --upgrade pip setuptools wheel

log_success "Python environment setup complete"
