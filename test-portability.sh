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
    --exclude="CLAUDE.md" \
    --exclude="test-portability.sh" \
    2>/dev/null; then
    echo "❌ FAIL: Found hardcoded /Users/admin paths"
    errors=$((errors + 1))
else
    echo "✅ PASS: No hardcoded /Users/admin paths (CLAUDE.md examples excluded)"
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
python3 -c "
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
sys.exit(0)
" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ PASS: No zero-width characters found"
else
    echo "❌ FAIL: Found zero-width characters"
    errors=$((errors + 1))
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
