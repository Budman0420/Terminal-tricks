#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Zsh Adapter
# ============================================================


# ------------------------------------------------------------
# Zsh Configuration
# ------------------------------------------------------------

ZSHRC="$HOME/.zshrc"
ZPROFILE="$HOME/.zprofile"


# ------------------------------------------------------------
# Backup Existing Configuration
# ------------------------------------------------------------

echo
echo "Preparing Zsh configuration..."
echo

backup_file "$ZSHRC"
backup_file "$ZPROFILE"


# ------------------------------------------------------------
# Create Terminal Tricks Core Directory
# ------------------------------------------------------------

mkdir -p "$TERMINAL_TRICKS_DIR/core"


# ------------------------------------------------------------
# Copy Shared Modules
# ------------------------------------------------------------

cp "$MODULE_DIR/aliases.sh" \
    "$TERMINAL_TRICKS_DIR/core/aliases.sh"

cp "$MODULE_DIR/functions.sh" \
    "$TERMINAL_TRICKS_DIR/core/functions.sh"

cp "$MODULE_DIR/recovery.sh" \
    "$TERMINAL_TRICKS_DIR/core/recovery.sh"

cp "$MODULE_DIR/history.sh" \
    "$TERMINAL_TRICKS_DIR/core/history.sh"

cp "$MODULE_DIR/cleanup.sh" \
    "$TERMINAL_TRICKS_DIR/core/cleanup.sh"


# ------------------------------------------------------------
# Create Zsh Loader
# ------------------------------------------------------------

cat > "$TERMINAL_TRICKS_DIR/core/zsh_loader.zsh" <<'EOF'

# ============================================================
# Terminal Tricks
# Zsh Loader
# ============================================================

TERMINAL_TRICKS_CORE="$HOME/.terminal_tricks/core"


# ------------------------------------------------------------
# Load Aliases
# ------------------------------------------------------------

if [[ -f "$TERMINAL_TRICKS_CORE/aliases.sh" ]]; then
    source "$TERMINAL_TRICKS_CORE/aliases.sh"
fi


# ------------------------------------------------------------
# Load History
# ------------------------------------------------------------

if [[ -f "$TERMINAL_TRICKS_CORE/history.sh" ]]; then
    source "$TERMINAL_TRICKS_CORE/history.sh"
fi


# ------------------------------------------------------------
# Load Cleanup
# ------------------------------------------------------------

if [[ -f "$TERMINAL_TRICKS_CORE/cleanup.sh" ]]; then
    source "$TERMINAL_TRICKS_CORE/cleanup.sh"
fi


# ------------------------------------------------------------
# Load Functions
# ------------------------------------------------------------

if [[ -f "$TERMINAL_TRICKS_CORE/functions.sh" ]]; then
    source "$TERMINAL_TRICKS_CORE/functions.sh"
fi


# ------------------------------------------------------------
# Load Recovery
# ------------------------------------------------------------

if [[ -f "$TERMINAL_TRICKS_CORE/recovery.sh" ]]; then
    source "$TERMINAL_TRICKS_CORE/recovery.sh"
fi

EOF


# ------------------------------------------------------------
# Create Zsh Configuration Block
# ------------------------------------------------------------

cat > "$CONFIG_DIR/zshrc.block" <<'EOF'

# Terminal Tricks
if [[ -f "$HOME/.terminal_tricks/core/zsh_loader.zsh" ]]; then
    source "$HOME/.terminal_tricks/core/zsh_loader.zsh"
fi

EOF


# ------------------------------------------------------------
# Install Managed Zsh Block
# ------------------------------------------------------------

add_config_block \
    "$ZSHRC" \
    "$CONFIG_DIR/zshrc.block"


# ------------------------------------------------------------
# Configure ~/bin for Zsh
# ------------------------------------------------------------

if [[ ! -f "$ZPROFILE" ]]; then
    touch "$ZPROFILE"
fi


if ! grep -q 'Terminal Tricks ~/bin' "$ZPROFILE" 2>/dev/null; then

    cat >> "$ZPROFILE" <<'EOF'

# Terminal Tricks ~/bin
if [[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi

EOF

fi


# ------------------------------------------------------------
# Complete
# ------------------------------------------------------------

echo
echo "Zsh adapter installed."
echo
echo "Zsh core:"
echo "  $TERMINAL_TRICKS_DIR/core"
echo
echo "Zsh configuration:"
echo "  $ZSHRC"
echo
echo "Zsh PATH:"
echo "  $ZPROFILE"
echo
