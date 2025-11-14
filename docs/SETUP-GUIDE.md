## Setup Guide

Detailed instructions for setting up your macOS development environment.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation Methods](#installation-methods)
3. [Component Details](#component-details)
4. [GitHub Authentication](#github-authentication)
5. [Verification](#verification)
6. [Customization](#customization)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

- **macOS**: 10.15 (Catalina) or later
- **Processor**: Intel or Apple Silicon (M1/M2/M3)
- **Storage**: ~10 GB free space (includes AI models)
- **Internet**: Broadband connection recommended

### Before You Begin

1. **Update macOS** to the latest version
2. **Install Command Line Tools** (automatic during setup, or run):
   ```bash
   xcode-select --install
   ```
3. **Close VS Code** if it's currently running

## Installation Methods

### Method 1: One-Line Install (Recommended)

```bash
git clone https://github.com/hillfire77gcp/mac-dev-setup.git ~/mac-dev-setup && cd ~/mac-dev-setup && ./setup.sh
```

### Method 2: Step-by-Step

```bash
# 1. Clone the repository
git clone https://github.com/hillfire77gcp/mac-dev-setup.git ~/mac-dev-setup

# 2. Navigate to directory
cd ~/mac-dev-setup

# 3. Make setup script executable (if needed)
chmod +x setup.sh

# 4. Run setup
./setup.sh
```

### Method 3: Selective Installation

```bash
cd ~/mac-dev-setup

# Run individual installation scripts
./scripts/install-homebrew.sh
./scripts/install-cli-tools.sh
./scripts/install-python.sh
# ... etc
```

## Component Details

### 1. Homebrew (Package Manager)

**What it does:**
- Installs and manages software packages on macOS
- Required for most other tools in this setup

**Installation time:** ~2-5 minutes

**What gets installed:**
- Homebrew itself
- Command line tools (if not already installed)

**After installation:**
```bash
brew --version
brew doctor  # Check for issues
```

### 2. CLI Development Tools

**What it does:**
- Installs essential command-line tools for development

**Installation time:** ~5-10 minutes

**Tools included:**
- **mise**: Universal version manager (Python, Node.js, Ruby, etc.)
- **uv**: Fast Python package installer (10-100x faster than pip)
- **just**: Command runner (like make but better)
- **gh**: GitHub CLI for repo management
- **jq**: JSON processor for command-line
- **yq**: YAML processor
- **chezmoi**: Dotfiles manager
- **copier**: Project template tool
- **ruff**: Python linter and formatter

**After installation:**
```bash
mise --version
uv --version
just --version
```

### 3. Python Environment

**What it does:**
- Installs Python 3.12 via mise
- Sets up global Python environment

**Installation time:** ~5-10 minutes

**What gets installed:**
- Python 3.12.x (latest patch version)
- pip, setuptools, wheel (latest versions)
- mise configuration for Python

**After installation:**
```bash
python --version  # Should show Python 3.12.x
which python      # Should point to mise installation
```

### 4. Modern Terminal Tools

**What it does:**
- Replaces standard Unix tools with modern, enhanced versions

**Installation time:** ~5-10 minutes

**Tools included:**

| Old Tool | New Tool | Enhancement |
|----------|----------|-------------|
| cd | zoxide | Learns your habits, jump to frequent dirs |
| ls | eza | Colors, icons, git status |
| cat | bat | Syntax highlighting, line numbers |
| find | fd | Faster, simpler syntax |
| grep | ripgrep (rg) | 10x faster, respects .gitignore |
| - | fzf | Fuzzy finder for everything |
| - | starship | Beautiful cross-shell prompt |
| - | tldr | Simplified man pages |

**After installation:**
```bash
starship --version
zoxide --version
eza --version
```

### 5. VS Code + Extensions

**What it does:**
- Installs VS Code IDE
- Installs curated extensions for Python development
- Applies optimized settings

**Installation time:** ~10-15 minutes

**Extensions installed:**
- **ms-python.python**: Python language support
- **ms-python.vscode-pylance**: Fast Python IntelliSense
- **charliermarsh.ruff**: Python linting and formatting
- **github.copilot**: AI code completion (if you have access)
- **github.copilot-chat**: AI chat assistant
- **continue.continue**: Local AI chat with Ollama
- **eamodio.gitlens**: Advanced Git features
- **usernamehw.errorlens**: Inline error display
- **tamasfe.even-better-toml**: TOML language support
- **redhat.vscode-yaml**: YAML language support
- **pkief.material-icon-theme**: Beautiful file icons
- **dracula-theme.theme-dracula**: Dracula color theme
- **streetsidesoftware.code-spell-checker**: Spell checking

**Settings configured:**
- Python interpreter path (mise installation)
- Ruff as default formatter
- Format on save enabled
- Type checking enabled
- Terminal font set to MesloLGS NF
- Dracula theme
- Material icons

**After installation:**
```bash
code --version
code --list-extensions
```

### 6. AI Coding Tools

**What it does:**
- Sets up local AI coding assistant (no API costs!)
- Runs entirely on your Mac

**Installation time:** ~15-30 minutes (depends on internet speed)

**Components:**
- **Ollama**: Local AI inference server
- **DeepSeek Coder 6.7B**: ~3.8 GB coding model
- **Continue extension**: VS Code integration

**Features:**
- Free and private (code never leaves your machine)
- Works offline
- Integrated into VS Code
- Fast responses (GPU accelerated on M1/M2/M3)

**After installation:**
```bash
ollama --version
ollama list  # Should show deepseek-coder:6.7b
ollama run deepseek-coder:6.7b  # Test the model
```

**Usage in VS Code:**
1. Open Continue panel (Cmd+Shift+P → "Continue")
2. Ask coding questions
3. Get code suggestions and explanations

### 7. Nerd Fonts

**What it does:**
- Installs fonts with icon support for terminal

**Installation time:** ~2-3 minutes

**Fonts installed:**
- MesloLGS NF (Light, Medium, Small variants)
- Includes icons for:
  - Git status
  - File types
  - Programming languages
  - System icons

**After installation:**
1. Restart terminal
2. Set terminal font to "MesloLGS NF"
3. Enjoy beautiful icons in your prompt!

### 8. Dotfiles

**What it does:**
- Applies optimized configuration files
- Backs up existing configs first

**Installation time:** ~1-2 minutes

**Files applied:**

| File | Purpose | Location |
|------|---------|----------|
| .zshrc | Shell configuration | ~/.zshrc |
| .gitconfig | Git user config | ~/.gitconfig |
| .gitignore_global | Global git ignores | ~/.gitignore_global |
| starship.toml | Prompt configuration | ~/.config/starship.toml |
| config.toml | mise configuration | ~/.config/mise/config.toml |
| settings.json | VS Code settings | ~/Library/Application Support/Code/User/ |
| config.yaml | Continue AI config | ~/.continue/config.yaml |

**Features in .zshrc:**
- Modern tool initialization
- 50+ useful aliases
- Utility functions (new-py, mkcd, qcommit, etc.)
- Smart completion
- Enhanced history
- Preserves existing configs (SDKMAN, Conda, etc.)

**After installation:**
```bash
source ~/.zshrc  # Reload configuration
# Or restart terminal
```

### 9. Python Templates

**What it does:**
- Installs reusable project templates
- Enables instant project creation

**Installation time:** ~1 minute

**Templates included:**
- **CLI Template**: Full-featured Python CLI project
  - Typer framework
  - Rich terminal output
  - pytest with 100% coverage example
  - Ruff linting/formatting
  - mypy type checking
  - pre-commit hooks
  - justfile for common tasks
  - GitHub Actions CI/CD

**After installation:**
```bash
# Create new project
copier copy ~/dev/python-templates/cli-template my-project
cd my-project
mise install && just install
just test  # All tests pass!
```

### 10. macOS System Preferences

**What it does:**
- Configures macOS for developer-friendly defaults
- **Optional** (prompted during setup)

**Installation time:** ~1 minute

**Changes made:**
- Show hidden files in Finder
- Show all file extensions
- Show path bar in Finder
- Disable .DS_Store on network drives
- Faster keyboard repeat rate
- Enable tap to click
- Disable auto-correct
- Disable smart quotes/dashes
- Expand save/print panels by default

**Note:** Some changes require logout to take effect.

## GitHub Authentication

### Why Authenticate?

**With GitHub authentication:**
- Clone private repositories
- Create new repositories via CLI
- Higher API rate limits
- Push to remote repositories

**Without GitHub authentication:**
- Full local development still works
- Can clone public repositories
- Cannot create repos via `gh` command
- Lower API rate limits

### How to Authenticate

During setup, you'll be prompted to authenticate. Choose one:

**Option 1: Use existing authentication**
```bash
# If you already ran 'gh auth login' before
# The script will detect it and ask to use it
```

**Option 2: Authenticate during setup**
```bash
# Script will run 'gh auth login'
# Choose: HTTPS
# Choose: Login with browser
# Follow the browser prompts
```

**Option 3: Skip authentication**
```bash
# Choose to skip during setup
# You can authenticate later with:
gh auth login
```

## Verification

### Test Your Installation

```bash
# 1. Check Homebrew
brew --version
brew doctor

# 2. Check Python
python --version
which python  # Should be in ~/.local/share/mise/

# 3. Check CLI tools
mise --version
uv --version
just --version
ruff --version

# 4. Check terminal tools
starship --version
eza --version
bat --version
fd --version
rg --version

# 5. Check VS Code
code --version

# 6. Check AI tools
ollama list
ollama run deepseek-coder:6.7b "Write a hello world in Python"

# 7. Test template
cd /tmp
copier copy ~/dev/python-templates/cli-template test-project
cd test-project
mise install
just install
just test  # Should pass
```

### Check Your Shell

```bash
# 1. Restart terminal

# 2. Check prompt
# Should see beautiful Starship prompt with icons

# 3. Test aliases
ls  # Should use eza
cat README.md  # Should use bat with colors

# 4. Test zoxide
z mac-dev  # Should jump to ~/mac-dev-setup

# 5. Test fzf
Ctrl+R  # Should open fuzzy command history search
```

## Customization

### Modify Dotfiles

```bash
cd ~/mac-dev-setup

# Edit files in dotfiles/ directory
nano dotfiles/dot_zshrc
nano dotfiles/dot_config/empty_starship.toml
nano dotfiles/vscode/settings.json

# Re-apply dotfiles
./setup.sh
# Select option 8 (Dotfiles)
```

### Add Your Own Scripts

```bash
# Add custom installation script
cp scripts/install-homebrew.sh scripts/install-my-tools.sh
nano scripts/install-my-tools.sh

# Add to setup.sh component menu
nano setup.sh
# Add your component to the list
```

### Modify Templates

```bash
# Edit the CLI template
cd ~/mac-dev-setup/templates/cli-template
nano copier.yml  # Template configuration
nano "{{ project_name }}/pyproject.toml.jinja"  # Project config

# Changes will be used for new projects
```

## Troubleshooting

### Common Issues

#### 1. Homebrew Install Fails

**Symptoms:** Setup stops during Homebrew installation

**Solution:**
```bash
# Install manually
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# For Apple Silicon, add to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Re-run setup
cd ~/mac-dev-setup && ./setup.sh
```

#### 2. Python Not Found After Install

**Symptoms:** `python --version` shows old version or "command not found"

**Solution:**
```bash
# Reload shell
source ~/.zshrc

# Or restart terminal

# Verify mise
mise list python
mise use -g python@3.12

# Check PATH
echo $PATH | grep mise
```

#### 3. VS Code Extensions Won't Install

**Symptoms:** Extensions fail to install, permission errors

**Solution:**
```bash
# Ensure code command is available
code --version

# If not, install code command in VS Code:
# Open VS Code → Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"

# Re-run VS Code setup
cd ~/mac-dev-setup
./scripts/install-vscode.sh
```

#### 4. Ollama Model Download Fails

**Symptoms:** DeepSeek Coder model won't download

**Solution:**
```bash
# Check Ollama status
brew services list | grep ollama

# Restart Ollama
brew services restart ollama

# Manually pull model
ollama pull deepseek-coder:6.7b

# If still fails, check internet and disk space
```

#### 5. Terminal Looks Wrong

**Symptoms:** Prompt shows weird characters, no icons

**Solution:**
```bash
# Install Nerd Font
cd ~/mac-dev-setup
./scripts/install-fonts.sh

# Restart terminal

# Set font in terminal preferences to "MesloLGS NF"
# (Terminal → Preferences → Profiles → Font)
```

#### 6. Backups Not Created

**Symptoms:** Can't find backup directory

**Solution:**
```bash
# Check backup directory
ls ~/mac-dev-setup/backups/

# If empty, backups might not have been created
# (happens if no existing configs to backup)

# To manually backup:
cp ~/.zshrc ~/mac-dev-setup/backups/zshrc.backup.$(date +%Y%m%d)
```

### Getting More Help

If you encounter issues not covered here:

1. Check the main [README.md](../README.md)
2. Review [QUICK-START.md](QUICK-START.md) for commands
3. Check individual script files in `scripts/` directory
4. Open an issue on GitHub

## Next Steps

After successful installation:

1. **Restart your terminal**
2. **Set terminal font** to MesloLGS NF
3. **Review** [QUICK-START.md](QUICK-START.md) for common commands
4. **Create a test project** from template
5. **Customize** dotfiles to your preferences
6. **Enjoy** your new development environment!

---

**Need help?** Check the [Quick Start Guide](QUICK-START.md) or open an issue on GitHub.
