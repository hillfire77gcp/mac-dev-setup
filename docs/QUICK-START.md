# Quick Start Guide

Essential commands and workflows for your new development environment.

## Installation

### Full Setup (All Components)
```bash
git clone https://github.com/hillfire77gcp/mac-dev-setup.git ~/mac-dev-setup
cd ~/mac-dev-setup
./setup.sh
# When prompted, type: all
```

### Selective Setup
```bash
cd ~/mac-dev-setup
./setup.sh
# Select specific components when prompted
```

## Daily Commands

### Python Development

```bash
# Create new project from template
copier copy ~/dev/python-templates/cli-template my-project
cd my-project

# Setup project
mise install        # Install Python version
just install        # Install dependencies

# Development workflow
just format         # Format code
just lint           # Check code quality
just typecheck      # Run type checker
just test           # Run tests
just check          # Run all checks

# Run your CLI
just run --help
```

### Modern Terminal Tools

```bash
# Smart directory navigation
z projects          # Jump to frequently used directory
z -l                # List all tracked directories

# Better file listing
ls                  # Uses eza with icons
ll                  # Detailed list
la                  # Show all files
lt                  # Tree view

# Better file search
fd pattern          # Find files by name
fd -e py            # Find Python files
rg "search term"    # Search file contents

# Better file viewing
bat filename.py     # View with syntax highlighting
bat -A file         # Show non-printable characters
```

### AI Coding Assistant

```bash
# Command line AI chat
ollama run deepseek-coder:6.7b

# In VS Code:
# 1. Cmd+Shift+P → "Continue: Open Chat"
# 2. Ask coding questions
# 3. Get AI-powered code suggestions
```

### Git Shortcuts

```bash
# Quick commit (from .zshrc aliases)
gaa                 # git add --all
gcm "message"       # git commit -m "message"
gp                  # git push
gl                  # git log --oneline -10

# Or use the custom function
qcommit "message"   # Add all, commit, ready to push
```

### VS Code

```bash
# Open project in VS Code
code .              # Current directory
code ~/dev/project  # Specific directory

# Install extension
code --install-extension publisher.extension-name

# List installed extensions
code --list-extensions
```

## Common Tasks

### Create New Python CLI Project

```bash
# Use the template
copier copy ~/dev/python-templates/cli-template my-tool
cd my-tool

# Answer template questions:
# - Project name: My Tool
# - Project slug: mytool (auto-generated)
# - Description: What it does
# - Author: Your Name
# - Python version: 3.12
# - Features: y (include all)

# Setup and test
mise install && just install
just test

# Start coding!
code .
```

### Update All Tools

```bash
# Update Homebrew and packages
brew update && brew upgrade

# Update Python versions
mise install python@latest

# Update Python packages in project
cd ~/dev/my-project
uv sync --upgrade
```

### Manage Dotfiles

```bash
# Edit a dotfile
nano ~/.zshrc

# Reload shell configuration
source ~/.zshrc

# Or just restart terminal
```

### Work with Backups

```bash
# List backups
ls ~/mac-dev-setup/backups/

# Restore from backup
cd ~/mac-dev-setup
./restore.sh
```

## Shell Functions (from .zshrc)

```bash
# Create new Python project
new-py myproject    # Creates directory, initializes git, sets up Python

# Create and enter directory
mkcd path/to/dir    # mkdir -p + cd

# Quick git commit
qcommit "message"   # git add . && git commit -m "message"

# Kill process on port
killport 8000       # Free up port 8000

# Extract any archive
extract file.tar.gz # Auto-detects archive type

# Backup a file
backup ~/.zshrc     # Creates timestamped backup
```

## Terminal Shortcuts

### zsh Key Bindings

```
Ctrl + R            # Search command history (with fzf)
Ctrl + T            # Fuzzy file finder (with fzf)
Ctrl + A            # Move to beginning of line
Ctrl + E            # Move to end of line
Ctrl + U            # Delete to beginning of line
Ctrl + K            # Delete to end of line
Ctrl + W            # Delete previous word
```

### Tab Completion

```bash
# Smart tab completion is enabled
python <TAB>        # Complete python commands
git <TAB>           # Complete git commands
cd ~/d<TAB>         # Complete directories
```

## Project Workflow Example

### Starting a New Project

```bash
# 1. Create from template
copier copy ~/dev/python-templates/cli-template github-stats
cd github-stats

# 2. Install dependencies
mise install
just install

# 3. Open in VS Code
code .

# 4. Start coding in src/github_stats/cli.py

# 5. Run tests as you code
just test

# 6. Check code quality
just check

# 7. Initialize git and push
git init
gh repo create github-stats --public --source=.
git add .
git commit -m "Initial commit"
git push -u origin main
```

## Troubleshooting

### Python Version Issues

```bash
# Check current Python
python --version
which python

# Set Python version for project
cd ~/dev/my-project
echo "python 3.12" > .tool-versions
mise install

# Set global Python version
mise use -g python@3.12
```

### VS Code Not Finding Python

1. Cmd+Shift+P → "Python: Select Interpreter"
2. Choose the mise Python: `~/.local/share/mise/installs/python/3.12/bin/python`

### Ollama Not Responding

```bash
# Check status
brew services list | grep ollama

# Restart service
brew services restart ollama

# Test
ollama list
ollama run deepseek-coder:6.7b
```

### Command Not Found

```bash
# Reload shell configuration
source ~/.zshrc

# Or restart terminal

# Check if tool is installed
which <command>
brew list | grep <tool>
```

## Configuration Files

Quick reference for where things live:

```
~/.zshrc                        # Shell configuration
~/.config/starship.toml         # Prompt configuration
~/.config/mise/config.toml      # Python version manager
~/.gitconfig                    # Git user config
~/.gitignore_global             # Global git ignores
~/.continue/config.yaml         # AI chat configuration
~/Library/Application Support/Code/User/settings.json  # VS Code settings
```

## Resources

- [Main README](../README.md) - Overview and features
- [Setup Guide](SETUP-GUIDE.md) - Detailed installation
- [Session Log](SETUP-LOG.md) - Original setup documentation

## Getting Help

```bash
# Tool help
just --list         # List available commands
mise --help         # mise help
uv --help          # uv help
copier --help      # copier help

# Command documentation
tldr <command>      # Simplified man pages
man <command>       # Full manual pages
```

---

**Tip:** Bookmark this file for quick reference! Open in VS Code with `code ~/mac-dev-setup/docs/QUICK-START.md`
