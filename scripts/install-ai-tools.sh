#!/usr/bin/env bash
# Install AI Coding Tools (Ollama + DeepSeek Coder)

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "🤖 Installing AI Coding Tools"

check_homebrew

# Install Ollama
install_tool ollama "Local AI inference server"

# Start Ollama service
log_info "Starting Ollama service..."
brew services start ollama
wait_for_service ollama 3

# Download DeepSeek Coder model
log_info "Downloading DeepSeek Coder model (~3.8 GB)..."
echo -e "${YELLOW}⚠ This may take several minutes depending on your internet connection${NC}"

if ollama list 2>/dev/null | grep -q "deepseek-coder"; then
    log_success "DeepSeek Coder model already downloaded"
else
    ollama pull deepseek-coder:6.7b
    log_success "DeepSeek Coder model downloaded"
fi

# Configure Continue extension (use config.yaml)
CONTINUE_CONFIG_SRC="$SCRIPT_DIR/dotfiles/continue/config.yaml"
CONTINUE_CONFIG_DST="$HOME/.continue/config.yaml"

if [ -f "$CONTINUE_CONFIG_SRC" ]; then
    log_info "Applying Continue AI configuration..."
    safe_copy "$CONTINUE_CONFIG_SRC" "$CONTINUE_CONFIG_DST"
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
