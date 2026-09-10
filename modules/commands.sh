#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Command Installer
# ============================================================

BIN_DIR="$HOME/bin"


# ------------------------------------------------------------
# Prepare ~/bin
# ------------------------------------------------------------

mkdir -p "$BIN_DIR"


# ------------------------------------------------------------
# help
# ------------------------------------------------------------

cat > "$BIN_DIR/help" <<'EOF'
#!/usr/bin/env bash

echo
echo "=============================================="
echo "              TERMINAL TRICKS - HELP"
echo "=============================================="
echo

echo "SYSTEM"
echo "  sysinfo       System information"
echo "  hardware      Hardware information"
echo "  netinfo       Network information"
echo "  diskinfo      Disk information"
echo "  processes     Top processes"
echo "  doctor        Check terminal setup"

echo
echo "RECOVERY"
echo "  reset wifi       Reset WiFi/network"
echo "  reset network    Reset network + DNS"
echo "  reset audio      Reset audio"
echo "  reset bluetooth  Reset Bluetooth"
echo "  reset usb        Show USB devices"
echo "  reset display    Restart graphical session"
echo "  reset failed     Clear failed service states"
echo "  reset all        Protected soft nuclear reset"

echo
echo "FILES / PROJECTS"
echo "  bigfiles       Find large files"
echo "  jump home      Go to home directory"
echo "  jump projects  Go to ~/Projects"
echo "  jump ai        Go to AI project"
echo "  jump dp        Go to Digital Purgatory"
echo "  jump tricks    Go to Terminal Tricks"

echo
echo "PACKAGES"
echo "  install <pkg>  Install package"
echo "  remove <pkg>   Remove package"
echo "  search <pkg>   Search packages"
echo "  update         Update package lists"
echo "  upgrade        Upgrade packages"
echo "  i <pkg>        Universal package installer"
echo "  f <pkg>        Universal package search"

echo
echo "TOOLS"
echo "  help           Show this help"
echo "  doctor         Check Terminal Tricks"
echo "  my-system      Quick system summary"
echo "  command-center Open interactive menu"
echo "  backupbash     Backup shell configuration"

echo
echo "=============================================="
echo
EOF

chmod +x "$BIN_DIR/help"


# ------------------------------------------------------------
# my-system
# ------------------------------------------------------------

cat > "$BIN_DIR/my-system" <<'EOF'
#!/usr/bin/env bash

echo
echo "======================================"
echo "              SYSTEM"
echo "======================================"
echo

echo "User:     $(whoami)"
echo "Hostname: $(hostname)"
echo "Kernel:   $(uname -r)"
echo "Shell:    ${SHELL:-unknown}"
echo "Uptime:   $(uptime -p)"

echo
echo "CPU:"
lscpu 2>/dev/null \
    | grep -m1 "Model name" \
    | sed 's/^[[:space:]]*//' \
    || echo "Unavailable"

echo
echo "RAM:"
free -h

echo
echo "Disk:"
df -h /

echo
EOF

chmod +x "$BIN_DIR/my-system"


# ------------------------------------------------------------
# command-center
# ------------------------------------------------------------

cat > "$BIN_DIR/command-center" <<'EOF'
#!/usr/bin/env bash

if [[ -f "$HOME/.terminal_tricks/core/bash_loader.sh" ]]; then

    source "$HOME/.terminal_tricks/core/bash_loader.sh"
    menu

else

    echo
    echo "Terminal Tricks functions are not loaded."
    echo
    echo "Try:"
    echo "  source ~/.bashrc"
    echo
    echo "Then run:"
    echo "  command-center"
    echo

fi
EOF

chmod +x "$BIN_DIR/command-center"


# ------------------------------------------------------------
# doctor
# ------------------------------------------------------------

cat > "$BIN_DIR/doctor" <<'EOF'
#!/usr/bin/env bash

if [[ -f "$HOME/.terminal_tricks/core/bash_loader.sh" ]]; then

    source "$HOME/.terminal_tricks/core/bash_loader.sh"
    menu
else

    echo
    echo "Terminal Tricks functions are not loaded."
    echo
    echo "Try:"
    echo "  source ~/.bashrc"
    echo

fi
EOF

chmod +x "$BIN_DIR/doctor"


# ------------------------------------------------------------
# backupbash
# ------------------------------------------------------------

cat > "$BIN_DIR/backupbash" <<'EOF'
#!/usr/bin/env bash

if [[ -f "$HOME/.terminal_tricks/core/bash_loader.sh" ]]; then

    source "$HOME/.terminal_tricks/core/bash_loader.sh"
    menu

else

    echo
    echo "Terminal Tricks functions are not loaded."
    echo
    echo "Try:"
    echo "  source ~/.bashrc"
    echo

fi
EOF

chmod +x "$BIN_DIR/backupbash"


# ------------------------------------------------------------
# Installer completion
# ------------------------------------------------------------

echo "Command tools installed to:"
echo "$BIN_DIR"
