#!/usr/bin/env bash
# Install Python Environment

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "🐍 Setting up Python Environment"

check_dependency mise "mise is required. Please run option #2 (CLI Tools) first."

# Install Python 3.12 via mise
log_info "Installing Python 3.12 via mise..."

if mise list python 2>/dev/null | grep -q "3.12"; then
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
mise exec python@3.12 -- python -m pip install --quiet --upgrade pip setuptools wheel

log_success "Python environment setup complete"
