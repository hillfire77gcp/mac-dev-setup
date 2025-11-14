#!/usr/bin/env bash
set -euo pipefail

# Install Nerd Fonts for Terminal

log_header "🔤 Installing Nerd Fonts"

if ! command_exists brew; then
    log_error "Homebrew is required but not installed. Please install Homebrew first."
    exit 1
fi

# Tap the cask-fonts repository
log_info "Adding Homebrew font cask..."
brew tap homebrew/cask-fonts 2>/dev/null || true

# Install MesloLGS Nerd Font (recommended for Starship)
log_info "Installing MesloLGS Nerd Font..."
if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
    log_success "MesloLGS Nerd Font already installed"
else
    brew install --cask font-meslo-lg-nerd-font
    log_success "MesloLGS Nerd Font installed"
fi

log_info "Font installation complete"
echo ""
echo -e "${YELLOW}⚠ To use the font:${NC}"
echo "  1. Restart your terminal"
echo "  2. Set terminal font to 'MesloLGS NF' in preferences"
echo "  3. For VS Code, it's already configured in settings.json"
