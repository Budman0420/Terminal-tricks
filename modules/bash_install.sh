#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Bash Adapter
# ============================================================


# ------------------------------------------------------------
# Bash Configuration
# ------------------------------------------------------------

BASHRC="$HOME/.bashrc"
PROFILE="$HOME/.profile"


# ------------------------------------------------------------
# Backup Existing Configuration
# ------------------------------------------------------------

echo
echo "Preparing Bash configuration..."
echo

backup_file "$BASHRC"
backup_file "$PROFILE"


# ------------------------------------------------------------
# Create Terminal Tricks Core Directory
# ------------------------------------------------------------

mkdir -p "$TERMINAL_TRICKS_DIR/core"


# ------------------------------------------------------------
# Copy Core Modules
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
# Create Terminal Tricks Loader
# ------------------------------------------------------------

cat > "$TERMINAL_TRICKS_DIR/core/bash_loader.sh" <<'EOF'
#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Bash Loader
# ============================================================

TERMINAL_TRICKS_CORE="$HOME/.terminal_tricks/core"


# ------------------------------------------------------------
# Load Aliases
# ------------------------------------------------------------

if [[ -f "$TERMINAL_TRICKS_CORE/aliases.sh" ]]; then
    source "$TERMINAL_TRICKS_CORE/aliases.sh"
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
EOF

chmod +x "$TERMINAL_TRICKS_DIR/core/bash_loader.sh"


# ------------------------------------------------------------
# Create Managed Bash Configuration Block
# ------------------------------------------------------------

cat > "$CONFIG_DIR/bashrc.block" <<'EOF'

# Terminal Tricks
if [[ -f "$HOME/.terminal_tricks/core/bash_loader.sh" ]]; then
    source "$HOME/.terminal_tricks/core/bash_loader.sh"
fi

EOF


# ------------------------------------------------------------
# Install Managed Block
# ------------------------------------------------------------

add_config_block \
    "$BASHRC" \
    "$CONFIG_DIR/bashrc.block"


# ------------------------------------------------------------
# Bash PATH Configuration
# ------------------------------------------------------------

PATH_BLOCK="$CONFIG_DIR/profile.block"

if [[ ! -f "$PATH_BLOCK" ]]; then

    cat > "$PATH_BLOCK" <<'EOF'

# Terminal Tricks ~/bin
if [[ -d "$HOME/bin" && ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
fi

EOF

fi


add_config_block \
    "$PROFILE" \
    "$PATH_BLOCK"


# ------------------------------------------------------------
# Complete
# ------------------------------------------------------------

echo
echo "Bash adapter installed."
echo
echo "Terminal Tricks core:"
echo "  $TERMINAL_TRICKS_DIR/core"
echo
echo "Bash configuration:"
echo "  $BASHRC"
echo
echo "PATH configuration:"
echo "  $PROFILE"
echo
