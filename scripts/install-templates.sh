#!/usr/bin/env bash
# Install Python Project Templates

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log_header "📋 Installing Python Project Templates"

TEMPLATES_SRC="$SCRIPT_DIR/templates"
TEMPLATES_DST="$HOME/dev/python-templates"

if [ ! -d "$TEMPLATES_SRC" ]; then
    log_error "Templates directory not found: $TEMPLATES_SRC"
    exit 1
fi

log_info "Installing Python CLI template to: $TEMPLATES_DST"

# Create dev directory with validation
create_directory "$HOME/dev"

# Backup existing templates
backup_file "$TEMPLATES_DST"

# Copy templates
cp -r "$TEMPLATES_SRC" "$TEMPLATES_DST"

log_success "Templates installed successfully"
echo ""
echo -e "${CYAN}ℹ Available templates:${NC}"
echo "  • CLI Template: $TEMPLATES_DST/cli-template"
echo ""
echo -e "${CYAN}ℹ To create a new project:${NC}"
echo "  copier copy $TEMPLATES_DST/cli-template my-new-project"
echo ""
echo -e "${CYAN}ℹ Template features:${NC}"
echo "  • Typer for CLI framework"
echo "  • Rich for beautiful terminal output"
echo "  • pytest with 100% coverage example"
echo "  • Ruff for linting and formatting"
echo "  • mypy for type checking"
echo "  • pre-commit hooks"
echo "  • justfile for common tasks"
echo "  • mise for Python version management"
echo "  • uv for fast dependency management"
