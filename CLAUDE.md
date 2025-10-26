# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **macOS development environment setup repository** that provides automated installation and configuration scripts for a modern Python development environment. The repository is designed to be portable and work for any macOS user without hardcoded paths.

## Key Commands

### Running the Setup

```bash
# Clone and run full setup
git clone https://github.com/hillfire77gcp/mac-dev-setup.git ~/mac-dev-setup
cd ~/mac-dev-setup
./setup.sh

# Interactive menu - select components to install
./setup.sh

# Restore from backup
./restore.sh
```

### What Gets Installed

The setup.sh provides an interactive menu to install:
1. Homebrew (package manager)
2. CLI Tools (ripgrep, fd, fzf, eza, bat, jq, httpie)
3. Python Environment (mise, uv, ruff, mypy, pytest)
4. Modern Terminal Tools (starship, zoxide)
5. VS Code + Extensions
6. AI Coding Tools (Ollama, DeepSeek Coder)
7. Nerd Fonts (MesloLGS NF)
8. Dotfiles (zshrc, gitconfig, starship, VS Code settings)
9. Python Templates (CLI project template)
10. macOS System Preferences

### Development Workflow After Setup

```bash
# Create new Python CLI project from template
copier copy ~/dev/python-templates/cli-template my-project
cd my-project

# Install dependencies
mise install  # Installs Python version from .mise.toml
just install  # Installs project dependencies via uv

# Run common tasks
just test      # Run pytest
just lint      # Run ruff linting
just format    # Format code with ruff
just check     # Run all quality checks
```

## Architecture and Structure

### Repository Structure

```
mac-dev-setup/
├── setup.sh                    # Main interactive installation script
├── restore.sh                  # Backup restoration script
├── .gitignore                  # Git ignore (includes runtime files)
├── scripts/                    # Modular installation scripts
│   ├── install-homebrew.sh     # Install Homebrew
│   ├── install-cli-tools.sh    # Install CLI utilities
│   ├── install-python.sh       # Install mise, uv, Python tools
│   ├── install-terminal-tools.sh  # Install starship, zoxide
│   ├── install-fonts.sh        # Install Nerd Fonts
│   ├── install-vscode.sh       # Install VS Code + extensions
│   ├── install-ai-tools.sh     # Install Ollama + models
│   ├── apply-dotfiles.sh       # Copy dotfiles to home directory
│   ├── install-templates.sh    # Copy templates to ~/dev/python-templates
│   └── configure-macos.sh      # Set macOS system preferences
├── dotfiles/                   # Configuration files (portable)
│   ├── dot_zshrc               # Zsh shell config
│   ├── dot_gitconfig           # Git core config
│   ├── empty_dot_gitignore_global  # Global git ignore patterns
│   ├── dot_config/
│   │   ├── empty_starship.toml    # Starship prompt config
│   │   └── mise/config.toml       # Mise global Python config
│   ├── vscode/
│   │   ├── settings.json          # VS Code settings
│   │   └── extensions.txt         # VS Code extension list
│   └── continue/                  # Continue AI extension config
│       ├── config.ts
│       ├── config.yaml
│       └── [runtime directories - gitignored]
├── templates/                  # Project templates
│   └── cli-template/           # Python CLI project template
│       ├── copier.yml          # Template configuration
│       └── {{ project_name }}/  # Jinja2 templated project
├── docs/                       # Documentation
│   ├── SETUP-GUIDE.md          # Detailed setup instructions
│   ├── QUICK-START.md          # Quick reference guide
│   └── SETUP-LOG.md            # Original setup session log
└── backups/                    # Auto-generated backups (gitignored)
```

### Script Architecture

**Main Setup Script (setup.sh)**:
- Interactive menu-driven installation
- Sources modular scripts from `scripts/` directory
- Creates timestamped backups before any changes
- Validates installations with comprehensive checks
- Provides colored output with progress indicators
- Idempotent - safe to run multiple times

**Modular Scripts Pattern**:
Each script in `scripts/` follows this pattern:
```bash
#!/usr/bin/env bash
# Assumes log functions defined in parent script:
# - log_header, log_info, log_success, log_error
# - backup_file function

log_header "Component Name"
# Installation logic using portable paths ($HOME, not /Users/admin)
log_success "Component installed"
```

**Backup System**:
- All backups go to: `~/mac-dev-setup/backups/YYYYMMDD_HHMMSS/`
- Backups are gitignored to prevent commit of user data
- restore.sh provides interactive restoration

### Dotfiles Architecture

**Naming Convention**:
- `dot_zshrc` → installed as `~/.zshrc`
- `empty_dot_gitignore_global` → installed as `~/.gitignore_global`
- `dot_config/empty_starship.toml` → installed as `~/.config/starship.toml`

**Portability Strategy**:
- All paths use `$HOME`, `~`, or `${env:HOME}` variables
- No hardcoded `/Users/admin` paths
- User-specific aliases should go in `~/.zshrc.local` (sourced at end)
- Continue runtime directories are gitignored to prevent user data commits

**Key Configuration Files**:
1. **dot_zshrc**: Complete shell config with:
   - Tool initialization (mise, starship, zoxide, fzf)
   - Modern CLI aliases (eza, bat, ripgrep, fd)
   - Python development aliases
   - Git shortcuts
   - Utility functions (mkcd, new-py, qcommit, killport)
   - Sources `~/.zshrc.local` for user-specific customization

2. **vscode/settings.json**: VS Code config with:
   - Python interpreter path using `${env:HOME}`
   - Ruff formatter and linter enabled
   - Format-on-save enabled
   - Pylance type checking
   - Terminal font set to MesloLGS NF
   - Material icons + Dracula theme

3. **dot_config/empty_starship.toml**: Prompt showing:
   - Git branch and status
   - Python version (from mise)
   - Directory path
   - Command duration

### Templates Architecture

**CLI Template** (`templates/cli-template/`):
- Uses Copier for templating (Jinja2 syntax)
- Variables: `project_name`, `project_slug`, `author_name`, etc.
- Generates complete Python project with:
  - `pyproject.toml` - PEP 621 compliant project config
  - `justfile` - Task runner commands (test, lint, format, run)
  - `src/{{ project_slug }}/` - Source code with Typer CLI
  - `tests/` - pytest tests with 100% coverage example
  - `.mise.toml` - Python version specification
  - `README.md` - Project documentation

**Installation**:
- Templates copied to `~/dev/python-templates/` during setup
- Users create projects with: `copier copy ~/dev/python-templates/cli-template project-name`

## Important Patterns and Conventions

### Path Portability

**CRITICAL**: Never use hardcoded user paths like `/Users/admin`. Always use:
- `$HOME` in shell scripts
- `~` in config files and documentation
- `${env:HOME}` in VS Code settings.json

**Examples**:
```bash
# ✅ GOOD
excludesfile = ~/.gitignore_global
"python.defaultInterpreterPath": "${env:HOME}/.local/share/mise/installs/python/latest/bin/python"
alias dev='cd ~/dev'

# ❌ BAD
excludesfile = /Users/admin/.gitignore_global
"python.defaultInterpreterPath": "/Users/admin/.local/share/mise/installs/python/latest/bin/python"
alias stocks='pushd /Users/admin/dev/stocks'
```

### User-Specific Customization

User-specific aliases and paths should go in `~/.zshrc.local` (not tracked in repo):
```bash
# Example ~/.zshrc.local
alias myproject='cd ~/dev/my-specific-project'
export MY_API_KEY="secret"
```

The main `dot_zshrc` sources this file at the end if it exists.

### Backup Before Modify

All installation scripts follow this pattern:
```bash
backup_file "$target_file"
# Now safe to modify/replace
```

### Idempotency

Scripts check if tools are already installed:
```bash
if ! command -v mise &> /dev/null; then
    brew install mise
fi
```

### Default Directories

The setup creates and uses these standard directories:
- `~/dev/` - All development work
- `~/dev/projects/` - Active projects
- `~/dev/python-templates/` - Project templates
- `~/mac-dev-setup/` - This repository (suggested location)
- `~/mac-dev-setup/backups/` - Configuration backups (gitignored)

## Development Workflow Philosophy

The setup prioritizes:

1. **Speed** - Rust-based tools (mise, uv, ruff) that are 10-100x faster than traditional Python tools
2. **AI-First** - Multiple AI coding assistants (Copilot, Continue with Ollama, free local AI)
3. **Automation** - One command to set up entire environment
4. **Consistency** - Project templates ensure all projects follow best practices
5. **Portability** - Works on any macOS system without modification
6. **Safety** - Automatic backups before any configuration changes

### Tool Stack Rationale

- **mise** (not pyenv): Faster, handles Python + other languages, auto-activates environments
- **uv** (not pip): 10-100x faster package installation, better dependency resolution
- **ruff** (not flake8/black/isort): Single tool replaces 5+ tools, extremely fast
- **just** (not make): Better syntax, clearer error messages, simpler to use
- **starship** (not oh-my-zsh): Fast, cross-shell, minimal configuration
- **Ollama + DeepSeek** (not paid APIs): Free local AI, privacy-focused, works offline

## Common Tasks and Troubleshooting

### Adding New Tools to Setup

1. Add installation logic to appropriate script in `scripts/`
2. Test idempotency (run script twice - should not error)
3. Ensure all paths are portable (use $HOME)
4. Add to menu in `setup.sh`
5. Update README.md with tool description

### Modifying Dotfiles

1. Edit files in `dotfiles/` directory
2. Test changes don't break portability
3. Re-run `./setup.sh` and select "Dotfiles" to apply
4. Or manually: `./scripts/apply-dotfiles.sh`

### Updating VS Code Extensions

1. Edit `dotfiles/vscode/extensions.txt`
2. Re-run `./setup.sh` and select "VS Code" option
3. Or manually: `./scripts/install-vscode.sh`

### Template Development

1. Edit files in `templates/cli-template/`
2. Test template generation:
   ```bash
   cd /tmp
   copier copy ~/mac-dev-setup/templates/cli-template test-project
   cd test-project
   mise install && just install && just test
   ```
3. If working, copy to installed templates:
   ```bash
   cp -r ~/mac-dev-setup/templates ~/dev/python-templates
   ```

## Testing and Validation

Before committing changes:

1. **Path Portability Check**:
   ```bash
   grep -r "/Users/admin" . --exclude-dir=.git --exclude-dir=backups --exclude="SETUP-LOG.md"
   # Should return no results (except SETUP-LOG.md which is historical)
   ```

2. **Idempotency Test**: Run `./setup.sh` twice - should not error on second run

3. **Clean Install Test**: Best done in VM or clean macOS installation

4. **Template Test**: Generate project from template and ensure it works

## Git Workflow

### What's Tracked
- All scripts, dotfiles, templates, and documentation
- Clean template files without user-specific data

### What's Ignored
- `backups/` - User-specific configuration backups
- `dotfiles/continue/index/` - Runtime workspace data
- `dotfiles/continue/sessions/` - User session history
- `dotfiles/continue/dev_data/` - Development data
- Standard temp files (.DS_Store, *.swp, __pycache__, etc.)

### Committing Changes

All scripts and dotfiles should remain portable. Never commit:
- User-specific paths (`/Users/admin`)
- API keys or secrets
- Runtime-generated files
- User-specific backups

## Future Development Ideas

Potential enhancements:
- Add support for other project templates (web app, library, data science)
- Optional installation of additional tools (Docker, databases)
- GitHub Actions for testing setup script
- chezmoi integration for dotfiles management
- Support for other shells (bash, fish)
- Linux/Ubuntu support (currently macOS only)
