# Testing the Portable Setup

Since your Mac is already set up, here are ways to test the portability:

## Option 1: Create a Test User Account (Most Thorough) ⭐

This simulates a completely fresh macOS installation.

### Steps:
1. **Create new user:**
   ```bash
   # Open System Settings → Users & Groups → Add Account
   # Or via command line (requires admin):
   sudo dscl . -create /Users/testuser
   sudo dscl . -create /Users/testuser UserShell /bin/zsh
   sudo dscl . -create /Users/testuser RealName "Test User"
   sudo dscl . -create /Users/testuser UniqueID 503
   sudo dscl . -create /Users/testuser PrimaryGroupID 20
   sudo dscl . -create /Users/testuser NFSHomeDirectory /Users/testuser
   sudo dscl . -passwd /Users/testuser password123
   sudo createhomedir -c -u testuser
   ```

2. **Log out and log in as testuser**

3. **Clone and test:**
   ```bash
   git clone https://github.com/hillfire77gcp/mac-dev-setup.git ~/mac-dev-setup
   cd ~/mac-dev-setup
   ./setup.sh
   ```

4. **Verify:**
   - No errors mentioning `/Users/admin`
   - All paths use `/Users/testuser`
   - Shell loads without errors
   - Tools work correctly

5. **Clean up when done:**
   - Log back into your main account
   - Delete the test user in System Settings

**Pros:** Most accurate test, completely isolated
**Cons:** Requires creating/deleting a user account

---

## Option 2: Test in a Subdirectory with Fresh Config (Quick) ⭐⭐

Test the dotfiles in isolation without affecting your current setup.

### Steps:
```bash
# Create test environment
mkdir -p ~/test-setup
cd ~/test-setup

# Clone the repo
git clone https://github.com/hillfire77gcp/mac-dev-setup.git
cd mac-dev-setup

# Test just the dotfiles in a subshell with temporary HOME
env HOME="$PWD/test-home" zsh -c '
  # Create test home
  mkdir -p test-home/.config/mise

  # Copy dotfiles
  cp dotfiles/dot_zshrc test-home/.zshrc
  cp dotfiles/dot_gitconfig test-home/.gitconfig
  cp -r dotfiles/dot_config/* test-home/.config/

  # Test shell initialization
  echo "Testing shell initialization..."
  zsh -l
'
```

**Check for:**
- No references to `/Users/admin`
- No hardcoded paths
- Shell loads without errors

**Pros:** Safe, doesn't touch your config
**Cons:** Not a complete end-to-end test

---

## Option 3: Automated Portability Check (Instant) ⭐⭐⭐

Create a script to verify no hardcoded paths exist.

### Create test script:
```bash
cat > ~/dev/mac-dev-setup/test-portability.sh << 'EOF'
#!/bin/bash

echo "🔍 Testing Repository Portability"
echo "=================================="
echo ""

errors=0

# Test 1: Check for hardcoded /Users/admin paths (excluding docs)
echo "Test 1: Checking for hardcoded /Users/admin paths..."
if grep -r "/Users/admin" . \
    --exclude-dir=.git \
    --exclude-dir=backups \
    --exclude="SETUP-LOG.md" \
    --exclude="FIXES.md" \
    --exclude="TEST-GUIDE.md" \
    --exclude="test-portability.sh" \
    2>/dev/null; then
    echo "❌ FAIL: Found hardcoded /Users/admin paths"
    errors=$((errors + 1))
else
    echo "✅ PASS: No hardcoded /Users/admin paths"
fi
echo ""

# Test 2: Check dotfiles use portable paths
echo "Test 2: Checking dotfiles use \$HOME or ~..."
if grep -E "^[^#]*(/Users/[^/]+|/home/[^/]+)" dotfiles/dot_* dotfiles/vscode/* 2>/dev/null | grep -v "^\s*#"; then
    echo "❌ FAIL: Dotfiles contain absolute user paths"
    errors=$((errors + 1))
else
    echo "✅ PASS: Dotfiles use portable paths"
fi
echo ""

# Test 3: Check for zero-width characters in configs
echo "Test 3: Checking for zero-width characters..."
if python3 -c "
import sys
import os
for root, dirs, files in os.walk('dotfiles'):
    for file in files:
        if file.endswith(('.toml', '.json', '.zsh', '.zshrc')):
            path = os.path.join(root, file)
            with open(path, 'rb') as f:
                if b'\xe2\x80\x8b' in f.read():
                    print(f'Found in: {path}')
                    sys.exit(1)
" 2>/dev/null; then
    echo "❌ FAIL: Found zero-width characters"
    errors=$((errors + 1))
else
    echo "✅ PASS: No zero-width characters found"
fi
echo ""

# Test 4: Check compinit is at the top of zshrc
echo "Test 4: Checking compinit placement in zshrc..."
if head -20 dotfiles/dot_zshrc | grep -q "compinit"; then
    echo "✅ PASS: compinit initialized early"
else
    echo "❌ FAIL: compinit not found in first 20 lines"
    errors=$((errors + 1))
fi
echo ""

# Test 5: Check find=fd alias is commented
echo "Test 5: Checking find=fd alias is disabled..."
if grep "^alias find='fd'" dotfiles/dot_zshrc >/dev/null 2>&1; then
    echo "❌ FAIL: find=fd alias is active"
    errors=$((errors + 1))
else
    echo "✅ PASS: find=fd alias is disabled/commented"
fi
echo ""

# Summary
echo "=================================="
if [ $errors -eq 0 ]; then
    echo "✅ All tests passed! Repository is portable."
    exit 0
else
    echo "❌ $errors test(s) failed. Review issues above."
    exit 1
fi
EOF

chmod +x ~/dev/mac-dev-setup/test-portability.sh
```

### Run the test:
```bash
cd ~/dev/mac-dev-setup
./test-portability.sh
```

**Pros:** Fast, automated, can run anytime
**Cons:** Only checks for common issues, not full functionality

---

## Option 4: Ask Someone Else to Test (Community Testing) ⭐

The ultimate portability test!

### Steps:
1. Ask a friend/colleague with a Mac to test
2. Send them:
   ```bash
   git clone https://github.com/hillfire77gcp/mac-dev-setup.git ~/mac-dev-setup
   cd ~/mac-dev-setup
   ./setup.sh
   ```
3. Ask them to report:
   - Any errors during setup
   - Any references to your username
   - Whether tools work correctly

**Pros:** Real-world test on different hardware/setup
**Cons:** Requires another person

---

## Option 5: Test Individual Components (Selective)

Test specific parts without full setup:

### Test shell initialization:
```bash
# Create temporary zshrc
cp ~/dev/mac-dev-setup/dotfiles/dot_zshrc /tmp/test_zshrc

# Replace any remaining user-specific content
sed -i '' 's|/Users/admin|/Users/testuser|g' /tmp/test_zshrc

# Test in subshell
HOME=/tmp ZDOTDIR=/tmp zsh -c "source /tmp/test_zshrc && echo '✅ Shell loaded successfully'"
```

### Test starship config:
```bash
# Validate starship config
starship config ~/dev/mac-dev-setup/dotfiles/dot_config/empty_starship.toml
```

### Test VS Code settings:
```bash
# Check for hardcoded paths
python3 -c "
import json
with open('dotfiles/vscode/settings.json') as f:
    settings = json.load(f)
    # Check interpreter path uses variable
    interp = settings.get('python.defaultInterpreterPath', '')
    if '\${env:HOME}' in interp or interp.startswith('~'):
        print('✅ Python interpreter path is portable')
    else:
        print('❌ Hardcoded interpreter path:', interp)
"
```

**Pros:** Granular testing, safe
**Cons:** Doesn't test full integration

---

## Recommended Testing Strategy

**For maximum confidence, do this order:**

1. ✅ **First:** Run automated portability check (Option 3) - 30 seconds
2. ✅ **Then:** Test individual components (Option 5) - 5 minutes
3. ✅ **Finally:** Either create test user (Option 1) OR ask someone else (Option 4) - 30 minutes

This gives you quick validation + thorough real-world testing.

---

## What to Look For During Testing

### ✅ Good Signs:
- Shell loads without errors
- No mentions of `/Users/admin` anywhere
- Tools activate correctly (mise, starship, etc.)
- Python version shows correctly
- All paths use `$HOME`, `~`, or `${env:HOME}`

### ❌ Bad Signs:
- Error: `No such file or directory: /Users/admin/...`
- Error: `command not found: compdef`
- Error: `invalid value 'ype' for '--type'`
- Any hardcoded username in output

---

## Quick Validation Checklist

After someone tests, verify:

- [ ] No shell initialization errors
- [ ] Python version displays correctly
- [ ] `mise list` shows installed Python
- [ ] `just --list` works in a test project
- [ ] Starship prompt displays correctly
- [ ] No `/Users/admin` in any configs
- [ ] Setup script completes without errors

---

## Automated GitHub Actions Test (Advanced)

You could also add a GitHub Action to test:

```yaml
# .github/workflows/test.yml
name: Test Setup
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Test portability
        run: ./test-portability.sh
```

This runs the portability check on every commit!
