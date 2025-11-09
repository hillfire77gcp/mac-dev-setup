#!/usr/bin/env bash
# Common functions used across installation scripts
# Source this file at the beginning of modular scripts

set -euo pipefail

#############################################
# Dependency Checks
#############################################

# Check if Homebrew is installed
check_homebrew() {
    if ! command_exists brew; then
        log_error "Homebrew is required but not installed."
        log_info "Please run option #1 (Install Homebrew) first or install manually:"
        log_info "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
}

# Check if a specific tool/dependency is installed
check_dependency() {
    local tool="$1"
    local error_message="${2:-$tool is required but not installed}"

    if ! command_exists "$tool"; then
        log_error "$error_message"
        exit 1
    fi
}

#############################################
# Installation Functions
#############################################

# Install multiple Homebrew packages from an associative array
# Usage: install_brew_tools tools_array_name
install_brew_tools() {
    local -n tools_ref=$1  # nameref to associative array

    for tool in "${!tools_ref[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool already installed - ${tools_ref[$tool]}"
        else
            log_info "Installing $tool - ${tools_ref[$tool]}"
            brew install "$tool" || {
                log_error "Failed to install $tool"
                exit 1
            }
            log_success "$tool installed"
        fi
    done
}

# Install a single tool with description
install_tool() {
    local tool="$1"
    local description="${2:-}"

    if command_exists "$tool"; then
        log_success "$tool already installed${description:+ - $description}"
    else
        log_info "Installing $tool${description:+ - $description}"
        brew install "$tool" || {
            log_error "Failed to install $tool"
            exit 1
        }
        log_success "$tool installed"
    fi
}

#############################################
# File System Functions
#############################################

# Create directory with validation
create_directory() {
    local dir="$1"

    if ! mkdir -p "$dir" 2>/dev/null; then
        log_error "Failed to create directory: $dir"
        log_error "Check permissions and disk space"
        exit 1
    fi

    if [ ! -w "$dir" ]; then
        log_error "Directory is not writable: $dir"
        exit 1
    fi
}

# Validate directory exists and is writable
validate_directory() {
    local dir="$1"

    if [ ! -d "$dir" ]; then
        log_error "Directory does not exist: $dir"
        exit 1
    fi

    if [ ! -w "$dir" ]; then
        log_error "Directory is not writable: $dir"
        exit 1
    fi
}

#############################################
# Utility Functions
#############################################

# Copy file with backup and error handling
safe_copy() {
    local src="$1"
    local dst="$2"

    if [ ! -f "$src" ]; then
        log_error "Source file not found: $src"
        exit 1
    fi

    # Backup existing file if it exists
    if [ -f "$dst" ]; then
        backup_file "$dst"
    fi

    # Create parent directory if needed
    local parent_dir
    parent_dir="$(dirname "$dst")"
    create_directory "$parent_dir"

    # Copy file
    if ! cp "$src" "$dst"; then
        log_error "Failed to copy $src to $dst"
        exit 1
    fi
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only"
        log_error "Current OS: $OSTYPE"
        exit 1
    fi
}

# Wait for service to start
wait_for_service() {
    local service="$1"
    local max_wait="${2:-10}"
    local count=0

    log_info "Waiting for $service to start..."

    while [ $count -lt "$max_wait" ]; do
        sleep 1
        count=$((count + 1))
    done
}

#############################################
# Git Configuration Detection
#############################################

# Get git config value with fallback
get_git_config() {
    local key="$1"
    local default="${2:-}"

    git config --get "$key" 2>/dev/null || echo "$default"
}
