#!/usr/bin/env bash

# Install AI Coding Tools (Ollama + DeepSeek Coder)

log_header "🤖 Installing AI Coding Tools"

if ! command_exists brew; then
    log_error "Homebrew is required but not installed. Please install Homebrew first."
    exit 1
fi

# Install Ollama
if command_exists ollama; then
    log_success "Ollama is already installed"
else
    log_info "Installing Ollama (local AI inference server)..."
    brew install ollama
    log_success "Ollama installed"
fi

# Start Ollama service
log_info "Starting Ollama service..."
brew services start ollama
sleep 3  # Wait for service to start

# Download DeepSeek Coder model
log_info "Downloading DeepSeek Coder model (~3.8 GB)..."
echo -e "${YELLOW}⚠ This may take several minutes depending on your internet connection${NC}"

if ollama list | grep -q "deepseek-coder"; then
    log_success "DeepSeek Coder model already downloaded"
else
    ollama pull deepseek-coder:6.7b
    log_success "DeepSeek Coder model downloaded"
fi

# Configure Continue extension
CONTINUE_CONFIG_SRC="$SCRIPT_DIR/dotfiles/continue/config.json"
CONTINUE_CONFIG_DST="$HOME/.continue/config.json"

if [ -f "$CONTINUE_CONFIG_SRC" ]; then
    log_info "Applying Continue AI configuration..."

    # Backup existing config
    backup_file "$CONTINUE_CONFIG_DST"

    # Copy new config
    mkdir -p "$(dirname "$CONTINUE_CONFIG_DST")"
    cp "$CONTINUE_CONFIG_SRC" "$CONTINUE_CONFIG_DST"

    log_success "Continue AI configured to use Ollama + DeepSeek Coder"
else
    log_warning "Continue config not found: $CONTINUE_CONFIG_SRC"
fi

log_success "AI tools installation complete"
echo ""
echo -e "${CYAN}ℹ To use AI coding assistant:${NC}"
echo "  • In VS Code, open Continue panel (Cmd+Shift+P → 'Continue')"
echo "  • Chat with DeepSeek Coder for free, locally"
echo "  • GitHub Copilot works for autocompletion (if you have access)"
echo ""
echo -e "${CYAN}ℹ To test Ollama directly:${NC}"
echo "  ollama run deepseek-coder:6.7b"
