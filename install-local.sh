#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

INSTALL_DIR="$HOME/.local/bin"
BINARY_PATH="/usr/local/lib/node_modules/synclaude/dist/cli/index.js"

echo -e "${GREEN}Installing synclaude with session resumption support...${NC}"

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Create symlink to our installed version
if [ -f "$BINARY_PATH" ]; then
    ln -sf "$BINARY_PATH" "$INSTALL_DIR/synclaude"
    echo -e "${GREEN}✓ Created symlink: $INSTALL_DIR/synclaude${NC}"
else
    echo -e "${RED}✗ synclaude not found at $BINARY_PATH${NC}"
    echo "Make sure you've run: npm install -g . from the synclaude directory"
    exit 1
fi

# Check if INSTALL_DIR is in PATH and add if needed
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠ Adding $INSTALL_DIR to PATH${NC}"

    # Detect shell and update config
    if [[ -n "$BASH_VERSION" ]]; then
        SHELL_RC="$HOME/.bashrc"
    elif [[ -n "$ZSH_VERSION" ]]; then
        SHELL_RC="$HOME/.zshrc"
    elif [[ -n "$FISH_VERSION" ]]; then
        SHELL_RC="$HOME/.config/fish/config.fish"
    else
        SHELL_RC="$HOME/.profile"
    fi

    # Only add PATH export if it doesn't already exist in the config file
    PATH_EXPORT="export PATH=\"\$PATH:$INSTALL_DIR\""
    if ! grep -q "PATH.*$INSTALL_DIR" "$SHELL_RC" 2>/dev/null; then
        echo "$PATH_EXPORT" >> "$SHELL_RC"
        echo -e "${YELLOW}Added to $SHELL_RC - restart your shell or run 'source $SHELL_RC'${NC}"
    else
        echo -e "${GREEN}PATH already configured in $SHELL_RC${NC}"
    fi
fi

echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${GREEN}Run 'synclaude --help' to see the new -c flag${NC}"