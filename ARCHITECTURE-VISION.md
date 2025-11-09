# Architecture Vision
**mac-dev-setup: Zero-to-Production Development Environment**

---

## Purpose & Core Philosophy

**Mission:** Transform a fresh macOS system into a production-ready Python development environment in under 30 minutes, with zero manual configuration.

**Design Principles:**
1. **Portability First** - Works for any user on any Mac, no hardcoded paths
2. **Speed Over Convention** - Modern Rust tools (mise, uv, ruff) over traditional Python tooling
3. **AI-Native** - Local AI (Ollama) + cloud AI (Copilot) integrated from day one
4. **Safety by Default** - Automatic backups before every change, easy rollback
5. **Composability** - Modular scripts that can be run independently or together
6. **Reproducibility** - Project templates ensure every project follows best practices

---

## Current State (v1.0)

### What We Built
```
┌─────────────────────────────────────────────────────────────┐
│                      USER INTERFACE                          │
│  ./setup.sh - Interactive menu (10 install options)         │
│  ./restore.sh - Backup restoration                          │
└─────────────┬───────────────────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────────────────┐
│                   ORCHESTRATION LAYER                        │
│  • Component selection & dependency checking                │
│  • Backup system (timestamped, gitignored)                  │
│  • Logging (color-coded, progress indicators)               │
│  • Shared functions (log_*, backup_file, command_exists)    │
└─────────────┬───────────────────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────────────────┐
│                  INSTALLATION MODULES                        │
│  10 modular scripts (scripts/*.sh):                         │
│  ├─ install-homebrew.sh     - Package manager               │
│  ├─ install-cli-tools.sh    - mise, uv, just, gh, etc.     │
│  ├─ install-python.sh       - Python env setup              │
│  ├─ install-terminal-tools.sh - starship, zoxide, fzf      │
│  ├─ install-fonts.sh        - Nerd Fonts                    │
│  ├─ install-vscode.sh       - Editor + extensions           │
│  ├─ install-ai-tools.sh     - Ollama + DeepSeek            │
│  ├─ apply-dotfiles.sh       - Shell/Git/VS Code config     │
│  ├─ install-templates.sh    - Project templates            │
│  └─ configure-macos.sh      - System preferences           │
└─────────────┬───────────────────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────────────────┐
│                  CONFIGURATION LAYER                         │
│  dotfiles/                  - Portable configs (no /Users/) │
│  ├─ dot_zshrc              - Shell setup (323 lines)       │
│  ├─ dot_gitconfig          - Git core config               │
│  ├─ vscode/settings.json   - Editor config                 │
│  ├─ continue/config.yaml   - AI assistant config           │
│  └─ dot_config/            - Tool configs (starship, mise) │
└─────────────┬───────────────────────────────────────────────┘
              │
┌─────────────▼───────────────────────────────────────────────┐
│                   TEMPLATE SYSTEM                            │
│  templates/cli-template/    - Copier-based project gen     │
│  └─ Generates:                                              │
│     • pyproject.toml (PEP 621)                              │
│     • justfile (task runner)                                │
│     • .mise.toml (Python version)                           │
│     • src/ + tests/ structure                               │
│     • Pre-commit hooks, CI/CD workflow                      │
└─────────────────────────────────────────────────────────────┘
```

### Strengths
- ✅ **Clean separation of concerns** - Each script has single responsibility
- ✅ **Excellent documentation** - README, CLAUDE.md, guides in docs/
- ✅ **User-friendly** - Interactive menu, colored output, progress indicators
- ✅ **Portable** - Uses $HOME consistently, works for any user
- ✅ **Safe** - Backup before modify, idempotent (can run multiple times)

### Gaps (Preventing v1.0 Release)
- ❌ **No error handling in modules** - Silent failures possible
- ❌ **Runtime data in Git** - Privacy/portability violation (Continue cache)
- ❌ **Code duplication** - Homebrew check repeated 5x, tool install pattern 2x
- ❌ **Broken reference** - config.json doesn't exist (config.yaml does)
- ❌ **No validation** - Can't verify installation succeeded
- ❌ **Manual dependencies** - User must select options in correct order

---

## Evolution Path

### Phase 1: Foundation (v1.1) - Production Ready
**Goal:** Fix critical issues, ready for public beta release

```
Current Issues          →  Solutions
──────────────────────     ─────────────────────────────────
No error handling      →  Add set -euo pipefail to all modules
Runtime files in Git   →  Remove .sqlite, .json from tracking
Code duplication       →  Create scripts/common.sh library
Broken config ref      →  Fix config.json → config.yaml
No validation          →  Create verify.sh health check
Manual dependencies    →  Auto-resolve prerequisites in menu
```

**Architecture Changes:**
```bash
scripts/
├─ common.sh            # NEW: Shared functions
│  ├─ check_homebrew()
│  ├─ check_dependency()
│  ├─ install_brew_tools()
│  └─ validate_directory()
├─ install-*.sh         # UPDATED: Use common.sh, add set -e
└─ ...

./verify.sh             # NEW: Post-install validation
./setup.sh              # UPDATED: Dependency resolution
```

**Success Criteria:**
- Zero critical issues in ANALYSIS-RECOMMENDATIONS.md
- Passes test-portability.sh on fresh macOS
- verify.sh confirms all tools installed correctly

---

### Phase 2: Intelligence (v2.0) - Self-Healing
**Goal:** System that detects and fixes its own issues

```
┌──────────────────────────────────────────────────┐
│            INTELLIGENT ORCHESTRATOR              │
├──────────────────────────────────────────────────┤
│  ./setup.sh --mode=<interactive|auto|repair>    │
│                                                  │
│  Modes:                                          │
│  • interactive - Current menu-based (default)   │
│  • auto - Detect what's missing, install it     │
│  • repair - Fix broken installations            │
└──────────────┬───────────────────────────────────┘
               │
    ┌──────────▼──────────┐
    │  Health Monitor     │
    │  (verify.sh++)      │
    ├─────────────────────┤
    │  Detects:           │
    │  • Missing tools    │
    │  • Outdated configs │
    │  • Broken PATH      │
    │  • Version skew     │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │  Auto-Repair        │
    ├─────────────────────┤
    │  • Reinstall tool   │
    │  • Update config    │
    │  • Fix permissions  │
    │  • Resolve conflicts│
    └─────────────────────┘
```

**Key Features:**
- **Auto-detection:** `./setup.sh --auto` installs only what's missing
- **Repair mode:** `./setup.sh --repair` fixes broken installations
- **Health checks:** Continuous monitoring (verify on shell startup)
- **Smart updates:** `./update.sh` only updates changed components
- **Rollback points:** Named restore points, not just timestamps

---

### Phase 3: Ecosystem (v3.0) - Universal Dev Environment
**Goal:** Support multiple languages, platforms, and workflows

```
Expansion Dimensions:

1. Languages
   Python (current) → Node.js → Go → Rust → Java

2. Platforms
   macOS (current) → Linux (Ubuntu, Fedora) → WSL2

3. Project Types
   CLI (current) → Web API → Data Science → ML/AI → Mobile

4. Team Features
   Individual (current) → Team configs → Organization standards
```

**Architecture Evolution:**
```
mac-dev-setup/  →  universal-dev-setup/
│
├─ core/                    # Platform-agnostic logic
│  ├─ orchestrator.sh
│  ├─ health-monitor.sh
│  └─ backup-manager.sh
│
├─ platforms/
│  ├─ macos/               # Current scripts move here
│  ├─ linux/
│  │  ├─ ubuntu/
│  │  └─ fedora/
│  └─ windows/
│     └─ wsl2/
│
├─ languages/
│  ├─ python/              # Current Python setup
│  ├─ nodejs/
│  ├─ go/
│  ├─ rust/
│  └─ java/
│
├─ templates/
│  ├─ python/
│  │  ├─ cli/             # Current CLI template
│  │  ├─ web-api/         # NEW: FastAPI template
│  │  ├─ ml/              # NEW: ML project template
│  │  └─ package/         # NEW: Library template
│  ├─ nodejs/
│  └─ go/
│
└─ profiles/
   ├─ personal.yml         # Individual developer
   ├─ team.yml             # Team standards
   └─ enterprise.yml       # Org-wide policies
```

**Configuration DSL:**
```yaml
# profile.yml - Declarative environment specification
name: "Python ML Developer"
platform: macos
languages:
  - python: "3.12"
  - r: "4.3"
tools:
  - docker
  - kubernetes
  - jupyter
  - databricks-cli
editors:
  - vscode
  - pycharm
ai_assistants:
  - github-copilot
  - continue+ollama
templates:
  - python/ml
  - python/web-api
system_preferences:
  dark_mode: true
  dock_autohide: true
```

---

## Design Decisions & Trade-offs

### 1. Shell Scripts vs Python
**Decision:** Bash scripts
**Rationale:**
- ✅ No dependencies (bash ships with macOS)
- ✅ Direct system interaction (PATH, dotfiles)
- ✅ Familiar to DevOps engineers
- ❌ Harder to test, less portable

**Future:** Consider Python CLI for complex logic (v3.0+)

### 2. Modular vs Monolithic
**Decision:** Modular scripts (10 separate files)
**Rationale:**
- ✅ Single responsibility principle
- ✅ Independent execution possible
- ✅ Easier to maintain/test
- ❌ More files to manage
- ❌ Shared code duplication (solved in v1.1)

### 3. Interactive vs Declarative
**Decision:** Interactive menu (current), add declarative in v2.0
**Rationale:**
- Current: Great for first-time users
- Future: Declarative (YAML) for teams/CI/CD

### 4. Homebrew Lock-in
**Decision:** Fully embrace Homebrew
**Rationale:**
- ✅ De facto standard on macOS
- ✅ Handles dependencies
- ✅ Updates/uninstalls
- ❌ macOS-only (addressed in v3.0 with platform abstraction)

### 5. AI Tools Strategy
**Decision:** Ollama (local) + Copilot (cloud)
**Rationale:**
- ✅ Free option (Ollama) for all users
- ✅ Best-in-class option (Copilot) for those with access
- ✅ Privacy (local) + performance (cloud)
- ❌ Continue extension sometimes unstable

---

## Technical Principles

### Portability
```bash
# NEVER
/Users/admin/dev/project

# ALWAYS
$HOME/dev/project
~/dev/project
${env:HOME}/dev/project  # VS Code
```

### Idempotency
```bash
# Scripts can run multiple times safely
if command_exists tool; then
    log_success "Already installed"
else
    brew install tool
fi
```

### Fail-Fast (v1.1+)
```bash
set -euo pipefail  # Exit on error, undefined var, pipe failure
```

### Backup-First
```bash
backup_file "$target"  # Always backup before modify
# Restore available via ./restore.sh
```

### Composability
```bash
# Each script works standalone
./scripts/install-python.sh

# Or orchestrated
./setup.sh  # Calls all scripts
```

---

## Success Metrics

### v1.0 → v1.1 (Production Ready)
- ✅ Zero critical bugs
- ✅ 100% error handling coverage
- ✅ Fresh Mac → working env in <30 min
- ✅ 100+ GitHub stars (community validation)

### v2.0 (Self-Healing)
- ✅ Auto-detect + repair broken installs
- ✅ Zero manual intervention for updates
- ✅ Health check on every shell startup (<100ms)
- ✅ 1000+ GitHub stars

### v3.0 (Universal)
- ✅ Support 3+ platforms (macOS, Linux, WSL2)
- ✅ Support 5+ languages (Python, Node, Go, Rust, Java)
- ✅ 10+ project templates
- ✅ Used by 10+ companies for onboarding
- ✅ 5000+ GitHub stars

---

## Risk Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Homebrew breaking changes | High | Pin critical formula versions, test on Homebrew updates |
| Tool incompatibilities | Medium | Lock versions in templates, test matrices |
| User environment corruption | High | Always backup first, easy rollback with ./restore.sh |
| Platform fragmentation (v3.0) | High | Extensive CI/CD across platforms, beta testing program |
| Template rot | Medium | Automated template testing, quarterly reviews |

---

## Next Steps

### Immediate (Next 2 Weeks)
1. ✅ Fix all critical issues from ANALYSIS-RECOMMENDATIONS.md
2. ✅ Create scripts/common.sh with shared functions
3. ✅ Implement verify.sh health check
4. ✅ Add dependency auto-resolution
5. ✅ Test on 3 fresh Macs (clean installs)
6. ✅ Tag v1.1 release

### Short-term (Next 3 Months)
1. Implement `--auto` mode (detect + install missing)
2. Create update.sh for config refresh
3. Add dry-run mode (`--dry-run`)
4. Expand templates (web-api, package, ml)
5. Community feedback iteration
6. Tag v2.0 release

### Long-term (Next Year)
1. Ubuntu/WSL2 support
2. Node.js/Go language support
3. Team profiles (YAML-based config)
4. Automated testing framework
5. Plugin system for extensions
6. Tag v3.0 release

---

## Conclusion

**mac-dev-setup is 85% of the way to being the definitive macOS development environment tool.** The architecture is sound, the user experience is excellent, and the vision is clear. After fixing the critical issues identified in the analysis, this project will be ready for widespread adoption.

**The path forward:**
1. **v1.1** - Fix bugs, add validation → Production ready
2. **v2.0** - Add intelligence → Self-healing system
3. **v3.0** - Expand scope → Universal dev environment

**Core Identity (Never Changes):**
- Zero-to-production in <30 minutes
- Portable, safe, fast
- AI-native development
- Best practices by default

This is not just a setup script—it's **the foundation for the next decade of development environments.**
