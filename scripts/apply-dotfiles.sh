#!/usr/bin/env bash
# Apply Dotfiles Configuration

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "⚙️  Applying Dotfiles"

DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

# Apply dotfiles - simplified using safe_copy
declare -A dotfiles=(
    ["dot_zshrc"]="$HOME/.zshrc"
    ["dot_gitconfig"]="$HOME/.gitconfig"
    ["empty_dot_gitignore_global"]="$HOME/.gitignore_global"
    ["dot_config/empty_starship.toml"]="$HOME/.config/starship.toml"
    ["dot_config/mise/config.toml"]="$HOME/.config/mise/config.toml"
)

log_info "Applying dotfiles..."

for src_name in "${!dotfiles[@]}"; do
    src="$DOTFILES_DIR/$src_name"
    dst="${dotfiles[$src_name]}"

    if [ -f "$src" ]; then
        safe_copy "$src" "$dst"
        log_success "Applied: $(basename "$dst")"
    else
        log_warning "File not found: $src_name"
    fi
done

# Configure git to use global gitignore
if [ -f "$HOME/.gitignore_global" ]; then
    git config --global core.excludesfile "$HOME/.gitignore_global"
    log_success "Configured git to use global gitignore"
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
