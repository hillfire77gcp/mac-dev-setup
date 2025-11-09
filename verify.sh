#!/usr/bin/env bash
# Verify Development Environment Installation
# This script checks if all tools are properly installed and configured

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}🔍 Development Environment Verification${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Track results
total_checks=0
passed_checks=0
failed_checks=0

# Check if command exists
check_command() {
    local cmd="$1"
    local display_name="${2:-$cmd}"
    local optional="${3:-false}"

    total_checks=$((total_checks + 1))

    if command -v "$cmd" &> /dev/null; then
        local version_info=""
        case "$cmd" in
            python|python3)
                version_info=$(python3 --version 2>&1 | cut -d' ' -f2)
                ;;
            mise|uv|ruff|just|gh|git|brew)
                version_info=$("$cmd" --version 2>&1 | head -n1 | awk '{print $NF}')
                ;;
            *)
                version_info="installed"
                ;;
        esac
        echo -e "${GREEN}✅ $display_name${NC} - $version_info"
        passed_checks=$((passed_checks + 1))
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo -e "${YELLOW}⚠️  $display_name${NC} - not installed (optional)"
        else
            echo -e "${RED}❌ $display_name${NC} - NOT FOUND"
            failed_checks=$((failed_checks + 1))
        fi
        return 1
    fi
}

# Check file exists
check_file() {
    local file="$1"
    local display_name="${2:-$file}"

    total_checks=$((total_checks + 1))

    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $display_name${NC}"
        passed_checks=$((passed_checks + 1))
        return 0
    else
        echo -e "${RED}❌ $display_name${NC} - NOT FOUND"
        failed_checks=$((failed_checks + 1))
        return 1
    fi
}

# Check directory exists
check_directory() {
    local dir="$1"
    local display_name="${2:-$dir}"

    total_checks=$((total_checks + 1))

    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅ $display_name${NC}"
        passed_checks=$((passed_checks + 1))
        return 0
    else
        echo -e "${RED}❌ $display_name${NC} - NOT FOUND"
        failed_checks=$((failed_checks + 1))
        return 1
    fi
}

echo "📦 Core Package Manager"
echo "----------------------"
check_command brew "Homebrew"
echo ""

echo "🔧 CLI Development Tools"
echo "------------------------"
check_command mise "mise"
check_command uv "uv"
check_command ruff "ruff"
check_command just "just"
check_command gh "GitHub CLI"
check_command git "Git"
check_command jq "jq"
check_command yq "yq"
check_command chezmoi "chezmoi"
check_command copier "copier"
echo ""

echo "🐍 Python Environment"
echo "---------------------"
check_command python3 "Python 3"
if command -v mise &> /dev/null; then
    if mise which python &> /dev/null; then
        python_path=$(mise which python)
        echo -e "${GREEN}✅ Python managed by mise${NC} - $python_path"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${YELLOW}⚠️  Python not configured in mise${NC}"
    fi
    total_checks=$((total_checks + 1))
fi
echo ""

echo "✨ Modern Terminal Tools"
echo "------------------------"
check_command starship "starship"
check_command zoxide "zoxide"
check_command fzf "fzf"
check_command eza "eza"
check_command bat "bat"
check_command fd "fd"
check_command rg "ripgrep"
check_command tldr "tldr" true
check_command htop "htop" true
check_command ncdu "ncdu" true
echo ""

echo "💻 VS Code"
echo "----------"
if [ -d "/Applications/Visual Studio Code.app" ]; then
    echo -e "${GREEN}✅ VS Code Application${NC}"
    passed_checks=$((passed_checks + 1))

    if command -v code &> /dev/null; then
        ext_count=$(code --list-extensions 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}✅ code command${NC} - $ext_count extensions installed"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${YELLOW}⚠️  code command not in PATH${NC}"
        failed_checks=$((failed_checks + 1))
    fi
    total_checks=$((total_checks + 2))
else
    echo -e "${RED}❌ VS Code${NC} - NOT INSTALLED"
    failed_checks=$((failed_checks + 1))
    total_checks=$((total_checks + 1))
fi
echo ""

echo "🤖 AI Coding Tools"
echo "------------------"
check_command ollama "Ollama" true
if command -v ollama &> /dev/null; then
    if brew services list 2>/dev/null | grep ollama | grep -q started; then
        echo -e "${GREEN}✅ Ollama service${NC} - running"
        passed_checks=$((passed_checks + 1))

        if ollama list 2>/dev/null | grep -q deepseek-coder; then
            echo -e "${GREEN}✅ DeepSeek Coder model${NC} - installed"
            passed_checks=$((passed_checks + 1))
        else
            echo -e "${YELLOW}⚠️  DeepSeek Coder model${NC} - not downloaded"
        fi
        total_checks=$((total_checks + 2))
    else
        echo -e "${YELLOW}⚠️  Ollama service${NC} - not running"
        total_checks=$((total_checks + 1))
    fi
fi
echo ""

echo "⚙️  Configuration Files"
echo "-----------------------"
check_file "$HOME/.zshrc" ".zshrc"
check_file "$HOME/.gitconfig" ".gitconfig"
check_file "$HOME/.gitignore_global" ".gitignore_global"
check_file "$HOME/.config/starship.toml" "starship.toml"
check_file "$HOME/.config/mise/config.toml" "mise config"
echo ""

echo "📋 Templates"
echo "------------"
check_directory "$HOME/dev" "~/dev directory"
check_directory "$HOME/dev/python-templates" "Python templates"
check_directory "$HOME/dev/python-templates/cli-template" "CLI template"
echo ""

echo "🔤 Fonts"
echo "--------"
if [ -d "$HOME/Library/Fonts" ]; then
    if ls "$HOME/Library/Fonts"/*Meslo* &> /dev/null || \
       ls /Library/Fonts/*Meslo* &> /dev/null; then
        echo -e "${GREEN}✅ MesloLGS Nerd Font${NC}"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${YELLOW}⚠️  MesloLGS Nerd Font${NC} - not found"
    fi
    total_checks=$((total_checks + 1))
fi
echo ""

echo "🔍 Shell Integration"
echo "--------------------"
if grep -q "mise activate" "$HOME/.zshrc" 2>/dev/null; then
    echo -e "${GREEN}✅ mise activation in .zshrc${NC}"
    passed_checks=$((passed_checks + 1))
else
    echo -e "${YELLOW}⚠️  mise not activated in .zshrc${NC}"
fi

if grep -q "starship init" "$HOME/.zshrc" 2>/dev/null; then
    echo -e "${GREEN}✅ starship initialization in .zshrc${NC}"
    passed_checks=$((passed_checks + 1))
else
    echo -e "${YELLOW}⚠️  starship not initialized in .zshrc${NC}"
fi

if grep -q "zoxide init" "$HOME/.zshrc" 2>/dev/null; then
    echo -e "${GREEN}✅ zoxide initialization in .zshrc${NC}"
    passed_checks=$((passed_checks + 1))
else
    echo -e "${YELLOW}⚠️  zoxide not initialized in .zshrc${NC}"
fi
total_checks=$((total_checks + 3))
echo ""

# Summary
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}📊 Verification Summary${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo "Total checks: $total_checks"
echo -e "${GREEN}Passed: $passed_checks${NC}"

if [ $failed_checks -gt 0 ]; then
    echo -e "${RED}Failed: $failed_checks${NC}"
fi

echo ""

# Final status
if [ $failed_checks -eq 0 ]; then
    echo -e "${GREEN}✅ All critical checks passed!${NC}"
    echo -e "${GREEN}Your development environment is ready.${NC}"
    exit 0
elif [ $failed_checks -le 3 ]; then
    echo -e "${YELLOW}⚠️  Some optional components are missing.${NC}"
    echo -e "${YELLOW}Your core environment is functional.${NC}"
    exit 0
else
    echo -e "${RED}❌ Multiple components are missing.${NC}"
    echo -e "${RED}Please run ./setup.sh to complete installation.${NC}"
    exit 1
fi
