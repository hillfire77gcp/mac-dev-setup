#!/usr/bin/env bash
# Install VS Code and Extensions

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "💻 Setting up VS Code"

check_homebrew

# Install VS Code
if command_exists code; then
    log_success "VS Code is already installed"
else
    log_info "Installing VS Code..."
    brew install --cask visual-studio-code
    log_success "VS Code installed"
fi

# Wait for code command to be available
sleep 2

# Install extensions
EXTENSIONS_FILE="$SCRIPT_DIR/dotfiles/vscode/extensions.txt"

if [ -f "$EXTENSIONS_FILE" ]; then
    log_info "Installing VS Code extensions..."

    while IFS= read -r extension; do
        # Skip empty lines and comments
        [[ -z "$extension" || "$extension" =~ ^# ]] && continue

        if code --list-extensions | grep -qi "^$extension$"; then
            log_success "$extension already installed"
        else
            log_info "Installing extension: $extension"
            code --install-extension "$extension" --force 2>/dev/null || log_warning "Failed to install $extension"
        fi
    done < "$EXTENSIONS_FILE"

    log_success "VS Code extensions installation complete"
else
    log_warning "Extensions file not found: $EXTENSIONS_FILE"
fi

# Apply VS Code settings
SETTINGS_SRC="$SCRIPT_DIR/dotfiles/vscode/settings.json"
SETTINGS_DST="$HOME/Library/Application Support/Code/User/settings.json"

if [ -f "$SETTINGS_SRC" ]; then
    log_info "Applying VS Code settings..."
    safe_copy "$SETTINGS_SRC" "$SETTINGS_DST"
    log_success "VS Code settings applied"
else
    log_warning "Settings file not found: $SETTINGS_SRC"
fi

log_success "VS Code setup complete"
