#!/usr/bin/env bash
set -euo pipefail

# Apply Dotfiles Configuration

log_header "⚙️  Applying Dotfiles"

DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

# Function to apply a dotfile
apply_dotfile() {
    local src=$1
    local dst=$2

    # Backup existing file
    backup_file "$dst"

    # Create directory if needed
    mkdir -p "$(dirname "$dst")"

    # Copy file
    cp "$src" "$dst"
    log_success "Applied: $(basename "$dst")"
}

# Apply .zshrc
if [ -f "$DOTFILES_DIR/dot_zshrc" ]; then
    log_info "Applying .zshrc..."
    apply_dotfile "$DOTFILES_DIR/dot_zshrc" "$HOME/.zshrc"
else
    log_warning ".zshrc not found in dotfiles"
fi

# Apply .gitconfig
if [ -f "$DOTFILES_DIR/dot_gitconfig" ]; then
    log_info "Applying .gitconfig..."
    apply_dotfile "$DOTFILES_DIR/dot_gitconfig" "$HOME/.gitconfig"
else
    log_warning ".gitconfig not found in dotfiles"
fi

# Apply .gitignore_global
if [ -f "$DOTFILES_DIR/empty_dot_gitignore_global" ]; then
    log_info "Applying .gitignore_global..."
    apply_dotfile "$DOTFILES_DIR/empty_dot_gitignore_global" "$HOME/.gitignore_global"

    # Configure git to use it
    git config --global core.excludesfile "$HOME/.gitignore_global"
    log_success "Configured git to use global gitignore"
else
    log_warning ".gitignore_global not found in dotfiles"
fi

# Apply Starship config
if [ -f "$DOTFILES_DIR/dot_config/empty_starship.toml" ]; then
    log_info "Applying Starship prompt config..."
    apply_dotfile "$DOTFILES_DIR/dot_config/empty_starship.toml" "$HOME/.config/starship.toml"
else
    log_warning "Starship config not found in dotfiles"
fi

# Apply mise config
if [ -f "$DOTFILES_DIR/dot_config/mise/config.toml" ]; then
    log_info "Applying mise config..."
    apply_dotfile "$DOTFILES_DIR/dot_config/mise/config.toml" "$HOME/.config/mise/config.toml"
else
    log_warning "mise config not found in dotfiles"
fi

log_success "Dotfiles applied successfully"
echo ""
echo -e "${CYAN}ℹ Applied configurations:${NC}"
echo "  • .zshrc - Enhanced shell with modern tools"
echo "  • .gitconfig - Git user configuration"
echo "  • .gitignore_global - Global git ignore patterns"
echo "  • starship.toml - Beautiful prompt configuration"
echo "  • mise/config.toml - Python version manager config"
echo ""
echo -e "${YELLOW}⚠ Run 'source ~/.zshrc' or restart terminal to apply changes${NC}"
