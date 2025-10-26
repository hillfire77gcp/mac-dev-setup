#!/usr/bin/env bash

# macOS Development Environment Setup Script
# Author: hillfire77gcp
# Repository: https://github.com/hillfire77gcp/mac-dev-setup

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$SCRIPT_DIR/backups/$(date +%Y%m%d_%H%M%S)"

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

log_success() {
    echo -e "${GREEN}✓${NC}  $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

log_error() {
    echo -e "${RED}✗${NC}  $1"
}

log_header() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Backup function
backup_file() {
    local file=$1
    if [ -f "$file" ] || [ -d "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        local backup_path="$BACKUP_DIR/$(basename "$file")"
        cp -r "$file" "$backup_path"
        log_success "Backed up: $file → $backup_path"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Ask user confirmation
ask_confirm() {
    local question=$1
    local default=${2:-n}

    if [ "$default" = "y" ]; then
        read -p "$(echo -e "${CYAN}?${NC} $question [Y/n]: ")" response
        response=${response:-y}
    else
        read -p "$(echo -e "${CYAN}?${NC} $question [y/N]: ")" response
        response=${response:-n}
    fi

    [[ "$response" =~ ^[Yy]$ ]]
}

# Display menu and get choice
show_menu() {
    local title=$1
    shift
    local options=("$@")

    echo -e "\n${MAGENTA}$title${NC}"
    for i in "${!options[@]}"; do
        echo -e "  ${GREEN}$((i+1))${NC}. ${options[$i]}"
    done
    echo -e "  ${GREEN}0${NC}. Skip this section"
    echo ""
}

# Main menu
main_menu() {
    log_header "🚀 macOS Development Environment Setup"

    echo "This script will help you set up a complete development environment."
    echo "You can choose which components to install."
    echo ""
    echo -e "${YELLOW}Features:${NC}"
    echo "  • Automatic backup of existing configurations"
    echo "  • Homebrew and essential CLI tools"
    echo "  • Modern Python development environment (mise, uv, ruff)"
    echo "  • VS Code with extensions and settings"
    echo "  • Free AI coding assistants (Ollama + DeepSeek Coder)"
    echo "  • Beautiful terminal (Starship, zoxide, fzf, modern tools)"
    echo "  • Dotfiles management with detailed configs"
    echo "  • Python CLI project templates"
    echo ""

    if ! ask_confirm "Ready to begin?" "y"; then
        log_warning "Setup cancelled by user"
        exit 0
    fi
}

# Check GitHub authentication
check_github_auth() {
    log_header "🔐 GitHub Authentication"

    if command_exists gh && gh auth status &>/dev/null; then
        log_success "GitHub CLI is authenticated"
        gh auth status
        echo ""
        if ask_confirm "Use this GitHub authentication?" "y"; then
            return 0
        else
            log_info "Will prompt for new authentication"
            return 1
        fi
    else
        log_warning "GitHub CLI not authenticated"
        echo ""
        echo "GitHub authentication is optional but recommended for:"
        echo "  • Cloning private repositories"
        echo "  • Creating repositories"
        echo "  • Higher API rate limits"
        echo ""
        if ask_confirm "Set up GitHub authentication now?" "n"; then
            return 1
        else
            log_info "Continuing without GitHub authentication (local setup only)"
            return 2
        fi
    fi
}

# Component installation menu
component_menu() {
    log_header "📦 Select Components to Install"

    echo "Select which components you want to install:"
    echo ""

    local -a components
    components=(
        "Homebrew (Package manager - required for other tools)"
        "CLI Tools (mise, uv, just, ruff, etc.)"
        "Python Environment (Python 3.12 via mise)"
        "Modern Terminal Tools (starship, zoxide, fzf, eza, bat, fd, ripgrep)"
        "VS Code + Extensions (IDE setup)"
        "AI Coding Tools (Ollama + DeepSeek Coder ~3.8GB)"
        "Nerd Fonts (MesloLGS for terminal)"
        "Dotfiles (Apply shell configs, git config, etc.)"
        "Python Templates (CLI project templates)"
        "macOS System Preferences (Optional tweaks)"
    )

    echo -e "${CYAN}Enter component numbers to install (space-separated), or 'all':${NC}"
    for i in "${!components[@]}"; do
        echo -e "  ${GREEN}$((i+1))${NC}. ${components[$i]}"
    done
    echo ""

    read -p "Selection: " selection

    # Convert selection to array
    if [ "$selection" = "all" ]; then
        INSTALL_HOMEBREW=1
        INSTALL_CLI_TOOLS=1
        INSTALL_PYTHON=1
        INSTALL_TERMINAL=1
        INSTALL_VSCODE=1
        INSTALL_AI=1
        INSTALL_FONTS=1
        INSTALL_DOTFILES=1
        INSTALL_TEMPLATES=1
        INSTALL_MACOS_PREFS=1
    else
        INSTALL_HOMEBREW=0
        INSTALL_CLI_TOOLS=0
        INSTALL_PYTHON=0
        INSTALL_TERMINAL=0
        INSTALL_VSCODE=0
        INSTALL_AI=0
        INSTALL_FONTS=0
        INSTALL_DOTFILES=0
        INSTALL_TEMPLATES=0
        INSTALL_MACOS_PREFS=0

        for num in $selection; do
            case $num in
                1) INSTALL_HOMEBREW=1 ;;
                2) INSTALL_CLI_TOOLS=1 ;;
                3) INSTALL_PYTHON=1 ;;
                4) INSTALL_TERMINAL=1 ;;
                5) INSTALL_VSCODE=1 ;;
                6) INSTALL_AI=1 ;;
                7) INSTALL_FONTS=1 ;;
                8) INSTALL_DOTFILES=1 ;;
                9) INSTALL_TEMPLATES=1 ;;
                10) INSTALL_MACOS_PREFS=1 ;;
            esac
        done
    fi
}

# Run installation
run_installation() {
    log_header "🔧 Starting Installation"

    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    log_info "Backups will be saved to: $BACKUP_DIR"

    # Install components
    [ $INSTALL_HOMEBREW -eq 1 ] && source "$SCRIPT_DIR/scripts/install-homebrew.sh"
    [ $INSTALL_CLI_TOOLS -eq 1 ] && source "$SCRIPT_DIR/scripts/install-cli-tools.sh"
    [ $INSTALL_PYTHON -eq 1 ] && source "$SCRIPT_DIR/scripts/install-python.sh"
    [ $INSTALL_TERMINAL -eq 1 ] && source "$SCRIPT_DIR/scripts/install-terminal-tools.sh"
    [ $INSTALL_FONTS -eq 1 ] && source "$SCRIPT_DIR/scripts/install-fonts.sh"
    [ $INSTALL_VSCODE -eq 1 ] && source "$SCRIPT_DIR/scripts/install-vscode.sh"
    [ $INSTALL_AI -eq 1 ] && source "$SCRIPT_DIR/scripts/install-ai-tools.sh"
    [ $INSTALL_DOTFILES -eq 1 ] && source "$SCRIPT_DIR/scripts/apply-dotfiles.sh"
    [ $INSTALL_TEMPLATES -eq 1 ] && source "$SCRIPT_DIR/scripts/install-templates.sh"
    [ $INSTALL_MACOS_PREFS -eq 1 ] && source "$SCRIPT_DIR/scripts/configure-macos.sh"
}

# Show completion message
show_completion() {
    log_header "🎉 Setup Complete!"

    echo -e "${GREEN}Your development environment has been set up successfully!${NC}"
    echo ""
    echo -e "${CYAN}Backup Location:${NC}"
    echo "  $BACKUP_DIR"
    echo ""
    echo -e "${CYAN}To restore from backup:${NC}"
    echo "  cp -r $BACKUP_DIR/filename ~/.original/location"
    echo ""
    echo -e "${CYAN}Next Steps:${NC}"
    echo "  1. Restart your terminal to apply all changes"
    echo "  2. Run 'source ~/.zshrc' to reload shell configuration"
    echo "  3. Test the setup:"
    echo "     • Run 'python --version' to verify Python installation"
    echo "     • Run 'code .' to test VS Code"
    echo "     • Run 'githubstats repo fastapi/fastapi' to test CLI tools"
    echo ""
    echo -e "${CYAN}Documentation:${NC}"
    echo "  • Setup guide: $SCRIPT_DIR/docs/SETUP-GUIDE.md"
    echo "  • Session log: $SCRIPT_DIR/docs/SETUP-LOG.md"
    echo ""
    echo -e "${YELLOW}⚠ Important:${NC} Some changes require a terminal restart to take effect"
    echo ""
}

# Main execution
main() {
    main_menu
    check_github_auth
    GITHUB_AUTH_STATUS=$?
    export GITHUB_AUTH_STATUS
    component_menu
    run_installation
    show_completion
}

# Run main function
main
