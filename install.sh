#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Main Installer
# ============================================================

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODULE_DIR="$SCRIPT_DIR/modules"
CONFIG_DIR="$SCRIPT_DIR/config"


# ------------------------------------------------------------
# Load common functions
# ------------------------------------------------------------

if [[ ! -f "$MODULE_DIR/common.sh" ]]; then
    echo "ERROR: common.sh was not found."
    echo
    echo "Expected:"
    echo "$MODULE_DIR/common.sh"
    exit 1
fi

source "$MODULE_DIR/common.sh"


# ------------------------------------------------------------
# Start
# ------------------------------------------------------------

banner

echo "Installer location:"
echo "$SCRIPT_DIR"
echo


# ------------------------------------------------------------
# Create installation directories
# ------------------------------------------------------------

echo "[1/7] Preparing Terminal Tricks directories..."

mkdir -p "$TERMINAL_TRICKS_DIR"
mkdir -p "$TERMINAL_TRICKS_DIR/core"
mkdir -p "$TERMINAL_TRICKS_DIR/adapters"
mkdir -p "$TERMINAL_TRICKS_DIR/backups"


# ------------------------------------------------------------
# Detect shell
# ------------------------------------------------------------

echo "[2/7] Detecting current shell..."

detect_shell


# ------------------------------------------------------------
# Check required modules
# ------------------------------------------------------------

echo "[3/7] Checking installer modules..."

MODULES=(
    "aliases.sh"
    "functions.sh"
    "commands.sh"
    "recovery.sh"
    "history.sh"
    "cleanup.sh"
)

for MODULE in "${MODULES[@]}"; do

    if [[ -f "$MODULE_DIR/$MODULE" ]]; then

        echo "OK   $MODULE"

    else

        echo "MISS $MODULE"
        echo
        echo "Installation cannot continue."
        exit 1

    fi

done


# ------------------------------------------------------------
# Install shared components
# ------------------------------------------------------------

echo
echo "[4/7] Installing shared components..."

source "$MODULE_DIR/aliases.sh"
source "$MODULE_DIR/functions.sh"
source "$MODULE_DIR/commands.sh"
source "$MODULE_DIR/recovery.sh"
source "$MODULE_DIR/history.sh"
source "$MODULE_DIR/cleanup.sh"

# ------------------------------------------------------------
# Install shell-specific configuration
# ------------------------------------------------------------

echo
echo "[5/7] Installing shell adapter..."

case "$SHELL_TYPE" in

    bash)

        if [[ -f "$MODULE_DIR/bash_install.sh" ]]; then

            source "$MODULE_DIR/bash_install.sh"

        else

            echo "ERROR: Bash installer missing."
            exit 1

        fi

        ;;

    zsh)

        if [[ -f "$MODULE_DIR/zsh_install.sh" ]]; then

            source "$MODULE_DIR/zsh_install.sh"

        else

            echo "ERROR: Zsh installer missing."
            exit 1

        fi

        ;;

    *)

        echo "WARNING: Unsupported shell."
        echo
        echo "Your shell is:"
        echo "$SHELL_TYPE"
        echo
        echo "Shared components were installed."
        echo "Shell-specific configuration was skipped."

        ;;

esac


# ------------------------------------------------------------
# Set permissions
# ------------------------------------------------------------

echo
echo "[6/7] Setting permissions..."

chmod +x "$MODULE_DIR"/*.sh 2>/dev/null || true

chmod +x "$SCRIPT_DIR/install.sh"


# ------------------------------------------------------------
# Final verification
# ------------------------------------------------------------

echo
echo "[7/7] Running installer verification..."

check_command bash

if command -v zsh >/dev/null 2>&1; then
    echo "OK   zsh"
else
    echo "INFO zsh not installed"
fi

if [[ -d "$TERMINAL_TRICKS_DIR" ]]; then
    echo "OK   $TERMINAL_TRICKS_DIR"
else
    echo "MISS $TERMINAL_TRICKS_DIR"
fi


# ------------------------------------------------------------
# Complete
# ------------------------------------------------------------

echo
echo "=============================================="
echo "       TERMINAL TRICKS INSTALLER COMPLETE"
echo "=============================================="
echo

echo "Detected shell:"
echo "  $SHELL_TYPE"

echo
echo "Installed to:"
echo "  $TERMINAL_TRICKS_DIR"

echo
echo "Next step:"
echo "  source ~/.bashrc"
echo
