#!/usr/bin/env bash
# Configure macOS System Preferences

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "🍎 Configuring macOS System Preferences"

echo "This will configure some sensible macOS defaults for developers."
echo ""
echo -e "${YELLOW}Changes include:${NC}"
echo "  • Show hidden files in Finder"
echo "  • Show file extensions"
echo "  • Disable .DS_Store on network drives"
echo "  • Faster key repeat rate"
echo "  • Enable tap to click"
echo "  • Show path bar in Finder"
echo ""

if ! ask_confirm "Apply these macOS settings?" "n"; then
    log_info "Skipping macOS configuration"
    exit 0
fi

log_info "Applying macOS settings..."

# Finder settings
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Keyboard settings
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad settings
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Panel settings
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable autocorrect features
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

log_success "macOS settings applied"
echo ""
echo -e "${YELLOW}⚠ Some changes require logging out and back in to take effect${NC}"
echo ""
echo -e "${CYAN}ℹ To restart Finder and apply changes now:${NC}"
echo "  killall Finder"
