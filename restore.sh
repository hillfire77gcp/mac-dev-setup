#!/usr/bin/env bash

# Restore Script for Backed Up Configurations

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_BASE="$SCRIPT_DIR/backups"

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC}  $1"; }
log_success() { echo -e "${GREEN}✓${NC}  $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC}  $1"; }
log_error() { echo -e "${RED}✗${NC}  $1"; }

# Show available backups
show_backups() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  Available Backups${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    if [ ! -d "$BACKUP_BASE" ] || [ -z "$(ls -A "$BACKUP_BASE" 2>/dev/null)" ]; then
        log_warning "No backups found in $BACKUP_BASE"
        exit 0
    fi

    local backups=()
    local index=1

    for backup_dir in "$BACKUP_BASE"/*; do
        if [ -d "$backup_dir" ]; then
            local timestamp=$(basename "$backup_dir")
            local count=$(find "$backup_dir" -type f | wc -l | tr -d ' ')
            backups+=("$backup_dir")
            echo -e "  ${GREEN}$index${NC}. $timestamp ($count files)"
            index=$((index + 1))
        fi
    done

    echo ""
    read -p "$(echo -e "${CYAN}?${NC} Select backup to restore (1-$((index-1))) or 0 to cancel: ")" choice

    # Validate input is a number
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        log_error "Invalid input. Please enter a number between 0 and $((index-1))"
        exit 1
    fi

    if [ "$choice" -eq 0 ]; then
        log_info "Restore cancelled"
        exit 0
    fi

    if [ "$choice" -lt 1 ] || [ "$choice" -ge "$index" ]; then
        log_error "Invalid selection. Please enter a number between 1 and $((index-1))"
        exit 1
    fi

    SELECTED_BACKUP="${backups[$((choice-1))]}"
    echo ""
    log_info "Selected backup: $(basename "$SELECTED_BACKUP")"
}

# Show files in backup
show_backup_files() {
    echo ""
    echo -e "${CYAN}Files in this backup:${NC}"

    local files=()
    local index=1

    for file in "$SELECTED_BACKUP"/*; do
        if [ -e "$file" ]; then
            local filename=$(basename "$file")
            files+=("$file")
            echo -e "  ${GREEN}$index${NC}. $filename"
            index=$((index + 1))
        fi
    done

    echo ""
    echo -e "  ${GREEN}a${NC}. Restore all files"
    echo -e "  ${GREEN}0${NC}. Cancel"
    echo ""
}

# Restore file
restore_file() {
    local src=$1
    local filename=$(basename "$src")

    # Determine destination based on filename
    local dst=""
    case "$filename" in
        .zshrc) dst="$HOME/.zshrc" ;;
        .gitconfig) dst="$HOME/.gitconfig" ;;
        .gitignore_global) dst="$HOME/.gitignore_global" ;;
        starship.toml) dst="$HOME/.config/starship.toml" ;;
        config.toml) dst="$HOME/.config/mise/config.toml" ;;
        settings.json) dst="$HOME/Library/Application Support/Code/User/settings.json" ;;
        config.yaml) dst="$HOME/.continue/config.yaml" ;;
        config.json) dst="$HOME/.continue/config.yaml" ;;  # Legacy support
        *)
            log_warning "Unknown file type: $filename"
            read -p "Enter destination path: " dst

            # Validate path is not empty and starts with / or ~
            if [ -z "$dst" ]; then
                log_error "No destination specified"
                return 1
            fi

            if [[ ! "$dst" =~ ^[/~] ]]; then
                log_error "Destination path must be absolute (start with / or ~)"
                return 1
            fi
            ;;
    esac

    if [ -z "$dst" ]; then
        log_error "No destination specified"
        return 1
    fi

    # Confirm restore
    echo ""
    log_warning "This will overwrite: $dst"
    read -p "$(echo -e "${CYAN}?${NC} Continue with restore? [y/N]: ")" confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_info "Skipped: $filename"
        return 0
    fi

    # Create directory if needed
    mkdir -p "$(dirname "$dst")"

    # Restore file
    cp "$src" "$dst"
    log_success "Restored: $filename → $dst"
}

# Main restore process
main() {
    show_backups
    show_backup_files

    read -p "Selection: " selection

    # Validate input
    if [ -z "$selection" ]; then
        log_error "No selection provided"
        exit 1
    fi

    if [ "$selection" = "0" ]; then
        log_info "Restore cancelled"
        exit 0
    fi

    if [ "$selection" = "a" ] || [ "$selection" = "A" ]; then
        # Restore all files
        log_info "Restoring all files..."
        for file in "$SELECTED_BACKUP"/*; do
            if [ -f "$file" ]; then
                restore_file "$file"
            fi
        done
    else
        # Restore specific file
        local files=("$SELECTED_BACKUP"/*)
        local index=$((selection - 1))

        if [ "$index" -lt 0 ] || [ "$index" -ge "${#files[@]}" ]; then
            log_error "Invalid selection"
            exit 1
        fi

        restore_file "${files[$index]}"
    fi

    echo ""
    log_success "Restore complete!"
    echo ""
    echo -e "${YELLOW}⚠ You may need to restart your terminal for changes to take effect${NC}"
}

main
