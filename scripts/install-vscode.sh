#!/usr/bin/env bash
set -euo pipefail

# Install VS Code and Extensions

log_header "💻 Setting up VS Code"

if ! command_exists brew; then
    log_error "Homebrew is required but not installed. Please install Homebrew first."
    exit 1
fi

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
        if code --list-extensions | grep -q "^$extension$"; then
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

    # Backup existing settings
    backup_file "$SETTINGS_DST"

    # Copy new settings
    mkdir -p "$(dirname "$SETTINGS_DST")"
    cp "$SETTINGS_SRC" "$SETTINGS_DST"

    log_success "VS Code settings applied"
else
    log_warning "Settings file not found: $SETTINGS_SRC"
fi

log_success "VS Code setup complete"
