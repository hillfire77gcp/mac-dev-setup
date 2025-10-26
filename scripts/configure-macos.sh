#!/usr/bin/env bash

# Configure macOS System Preferences

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
    return 0
fi

log_info "Applying macOS settings..."

# Finder: show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Set a faster keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable tap to click for trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart quotes and dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

log_success "macOS settings applied"
echo ""
echo -e "${YELLOW}⚠ Some changes require logging out and back in to take effect${NC}"
echo ""
echo -e "${CYAN}ℹ To restart Finder and apply changes now:${NC}"
echo "  killall Finder"
