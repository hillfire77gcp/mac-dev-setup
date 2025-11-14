# macOS Development Environment Setup

**One-command setup for a complete modern Python development environment on macOS**

This repository contains everything you need to set up a professional development environment on a fresh macOS installation. Just clone and run!

## Features

- 🍺 **Homebrew** - Package manager for macOS
- 🐍 **Python 3.12** - Via mise version manager
- 💻 **VS Code** - With pre-configured extensions and settings
- 🤖 **Free AI Tools** - Ollama + DeepSeek Coder (local, no API costs)
- ✨ **Modern CLI Tools** - starship, zoxide, fzf, eza, bat, fd, ripgrep
- ⚙️ **Dotfiles** - Optimized shell configs, git config, and more
- 📋 **Project Templates** - Python CLI project template with best practices
- 🔤 **Nerd Fonts** - Beautiful terminal fonts
- 🔧 **Development Tools** - mise, uv, just, ruff, mypy, pytest

## Quick Start

### One-Line Install

```bash
git clone https://github.com/hillfire77gcp/mac-dev-setup.git ~/mac-dev-setup && cd ~/mac-dev-setup && ./setup.sh
```

### What Gets Installed

**Essentials:**
- Homebrew (if not already installed)
- Git and GitHub CLI
- Modern Python environment (mise + uv)

**Development Tools:**
- **mise** - Fast version manager for Python, Node.js, etc.
- **uv** - Lightning-fast Python package installer
- **just** - Command runner (better than make)
- **ruff** - Fast Python linter and formatter
- **copier** - Project templating tool

**Terminal Enhancements:**
- **starship** - Beautiful cross-shell prompt
- **zoxide** - Smarter cd command (tracks your most-used directories)
- **fzf** - Fuzzy finder for files, commands, history
- **eza** - Modern ls replacement with colors and icons
- **bat** - Better cat with syntax highlighting
- **fd** - Better find command
- **ripgrep** - Better grep (super fast)

**VS Code Setup:**
- Python language support (Pylance)
- Ruff extension for linting/formatting
- GitHub Copilot (if you have access)
- Continue extension for local AI chat
- GitLens for advanced Git features
- Material Icon Theme
- Dracula theme

**AI Coding Assistants:**
- **Ollama** - Local AI inference server (free)
- **DeepSeek Coder 6.7B** - Free local coding model
- **Continue** - VS Code extension for AI chat

## Interactive Installation

The setup script provides an interactive menu where you can choose which components to install:

```bash
./setup.sh
```

You'll be prompted to select:
1. Homebrew
2. CLI Tools
3. Python Environment
4. Modern Terminal Tools
5. VS Code + Extensions
6. AI Coding Tools
7. Nerd Fonts
8. Dotfiles
9. Python Templates
10. macOS System Preferences

**Or install everything at once:** Just type `all` when prompted!

## What You Get

### Enhanced Terminal

Beautiful Starship prompt with:
- Git branch and status
- Python version display
- Command execution time
- Directory path with smart truncation

Modern aliases:
```bash
ls → eza --icons --group-directories-first
cat → bat --style=auto
cd → zoxide (smart directory jumping)
```

### Python Development

Perfect Python setup with:
- Python 3.12 (managed by mise)
- Fast package installation (uv)
- Modern linting and formatting (ruff)
- Type checking (mypy)
- Testing (pytest with coverage)
- Task runner (just)

### Free AI Coding

Local AI coding assistant that runs on your Mac:
- No API costs
- Works offline
- Privacy-focused (your code never leaves your machine)
- Integrated into VS Code via Continue extension

### Project Templates

Create new Python CLI projects instantly:

```bash
copier copy ~/dev/python-templates/cli-template my-new-project
cd my-new-project
mise install
just install
just test  # All tests pass with 100% coverage!
```

Each new project includes:
- Typer for CLI framework
- Rich for beautiful terminal output
- pytest with coverage
- Ruff for linting/formatting
- mypy for type checking
- Pre-commit hooks
- GitHub Actions CI/CD (optional)
- justfile for common tasks

## Backup & Restore

All existing configurations are automatically backed up before modification.

**Backup location:** `~/mac-dev-setup/backups/YYYYMMDD_HHMMSS/`

**To restore a backup:**
```bash
./restore.sh
```

The restore script provides an interactive menu to restore individual files or entire backups.

## Repository Structure

```
mac-dev-setup/
├── setup.sh              # Main installation script
├── restore.sh            # Backup restore script
├── scripts/              # Modular installation scripts
│   ├── install-homebrew.sh
│   ├── install-cli-tools.sh
│   ├── install-python.sh
│   ├── install-terminal-tools.sh
│   ├── install-fonts.sh
│   ├── install-vscode.sh
│   ├── install-ai-tools.sh
│   ├── apply-dotfiles.sh
│   ├── install-templates.sh
│   └── configure-macos.sh
├── dotfiles/             # Configuration files
│   ├── dot_zshrc         # Enhanced shell config
│   ├── dot_gitconfig     # Git user config
│   ├── empty_dot_gitignore_global  # Global git ignore
│   ├── dot_config/
│   │   ├── empty_starship.toml     # Prompt config
│   │   └── mise/config.toml        # Python version config
│   ├── vscode/
│   │   ├── settings.json           # VS Code settings
│   │   └── extensions.txt          # Extension list
│   └── continue/
│       ├── config.yaml             # AI chat config
│       └── config.ts               # TypeScript config extension
├── templates/            # Project templates
│   └── cli-template/     # Python CLI project template
├── docs/                 # Documentation
│   ├── SETUP-GUIDE.md    # Detailed setup guide
│   ├── QUICK-START.md    # Quick reference
│   └── SETUP-LOG.md      # Session log from original setup
└── backups/              # Automatic backups (gitignored)
```

## Requirements

- macOS (tested on macOS Sequoia 15.0+)
- Command Line Tools (installed automatically if needed)
- Internet connection (for downloading packages)

## GitHub Authentication

The script can work with or without GitHub authentication:

- **With authentication:** Can clone private repos, create repos, higher API limits
- **Without authentication:** Full local development environment still works

GitHub CLI authentication is optional and prompted during setup.

## Post-Installation

After running the setup:

1. **Restart your terminal** (or run `source ~/.zshrc`)
2. **Set terminal font** to "MesloLGS NF" in terminal preferences
3. **Test the installation:**
   ```bash
   # Check Python
   python --version

   # Test AI assistant
   ollama run deepseek-coder:6.7b

   # Create a test project
   copier copy ~/dev/python-templates/cli-template test-project
   cd test-project
   just install
   just test
   ```

## Customization

All configuration files are in the `dotfiles/` directory. Modify them to suit your preferences:

- **Shell:** Edit `dotfiles/dot_zshrc`
- **Prompt:** Edit `dotfiles/dot_config/empty_starship.toml`
- **VS Code:** Edit `dotfiles/vscode/settings.json`
- **Git:** Edit `dotfiles/dot_gitconfig`

After modifying, re-run `./setup.sh` and select only "Dotfiles" to apply changes.

## Troubleshooting

### Homebrew Installation Fails
Run manually: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

### VS Code Extensions Won't Install
Ensure VS Code command line tools are installed: Open VS Code → Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"

### AI Tools (Ollama) Not Working
Check if service is running: `brew services list | grep ollama`
Restart if needed: `brew services restart ollama`

### Python Not Found
Ensure mise is initialized: `mise install python@3.12 && mise use -g python@3.12`

## Documentation

- [Setup Guide](docs/SETUP-GUIDE.md) - Detailed installation instructions
- [Quick Start](docs/QUICK-START.md) - Common commands and workflows
- [Setup Log](docs/SETUP-LOG.md) - Original setup session documentation

## License

MIT License - Feel free to use and modify for your own setup!

## Credits

Created by [hillfire77gcp](https://github.com/hillfire77gcp)

Powered by amazing open-source tools and the macOS developer community.

---

**Happy Coding!** 🚀
