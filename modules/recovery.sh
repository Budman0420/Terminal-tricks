#!/usr/bin/env bash

# ============================================================
# Terminal Tricks
# Recovery System
# ============================================================


# ------------------------------------------------------------
# Reset / Recovery
# ------------------------------------------------------------

reset() {

    case "${1:-}" in

        wifi)

            echo
            echo "Restarting NetworkManager..."
            echo

            if systemctl list-unit-files 2>/dev/null \
                | grep -q '^NetworkManager.service'; then

                sudo systemctl restart NetworkManager

                echo "WiFi/network service restarted."

            else

                echo "NetworkManager was not found."

            fi

            ;;


        network)

            echo
            echo "Refreshing network..."
            echo

            if systemctl list-unit-files 2>/dev/null \
                | grep -q '^NetworkManager.service'; then

                sudo systemctl restart NetworkManager

                echo "NetworkManager restarted."

            else

                echo "NetworkManager not found."

            fi


            if systemctl list-unit-files 2>/dev/null \
                | grep -q '^systemd-resolved.service'; then

                sudo systemctl restart systemd-resolved

                echo "systemd-resolved restarted."

            fi


            if command -v resolvectl >/dev/null 2>&1; then

                resolvectl flush-caches 2>/dev/null || true

                echo "DNS cache flushed."

            fi

            echo
            echo "Network refresh complete."

            ;;


        audio)

            echo
            echo "Refreshing audio..."
            echo

            if systemctl --user list-unit-files 2>/dev/null \
                | grep -q '^pipewire.service'; then

                systemctl --user restart pipewire \
                    2>/dev/null || true

                echo "PipeWire restarted."

            else

                echo "PipeWire not found."

            fi


            if systemctl --user list-unit-files 2>/dev/null \
                | grep -q '^pipewire-pulse.service'; then

                systemctl --user restart pipewire-pulse \
                    2>/dev/null || true

                echo "PipeWire Pulse restarted."

            fi

            ;;


        bluetooth)

            echo
            echo "Restarting Bluetooth..."
            echo

            if systemctl list-unit-files 2>/dev/null \
                | grep -q '^bluetooth.service'; then

                sudo systemctl restart bluetooth

                echo "Bluetooth restarted."

            else

                echo "Bluetooth service not found."

            fi

            ;;


        usb)

            echo
            echo "=============================================="
            echo "                 USB DEVICES"
            echo "=============================================="
            echo

            if command -v lsusb >/dev/null 2>&1; then

                lsusb

            else

                echo "lsusb is not installed."
                echo
                echo "Install it with:"
                echo "  i usbutils"

            fi

            echo
            echo "USB hardware reset is intentionally NOT automatic."
            echo
            echo "Why?"
            echo "A blind USB reset could disconnect:"
            echo "  - keyboards"
            echo "  - mice"
            echo "  - storage drives"
            echo "  - Flipper/ESP32 hardware"
            echo "  - other USB devices"
            echo

            ;;


        display)

            echo
            echo "=============================================="
            echo "                DISPLAY RESET"
            echo "=============================================="
            echo
            echo "WARNING:"
            echo "Restarting the display manager will log you out."
            echo

            read -rp "Continue? [y/N]: " ANSWER

            if [[ "$ANSWER" =~ ^[Yy]$ ]]; then

                sudo systemctl restart display-manager

            else

                echo
                echo "Display reset cancelled."

            fi

            ;;


        failed)

            echo
            echo "=============================================="
            echo "             FAILED SERVICES"
            echo "=============================================="
            echo

            systemctl --failed

            echo
            read -rp "Clear failed service markers? [y/N]: " ANSWER

            if [[ "$ANSWER" =~ ^[Yy]$ ]]; then

                sudo systemctl reset-failed

                echo
                echo "Failed service markers cleared."

            else

                echo
                echo "Operation cancelled."

            fi

            ;;


        all)

            echo
            echo "================================================"
            echo "            NUCLEAR SOFT RESET"
            echo "================================================"
            echo
            echo "This will restart recoverable system services."
            echo
            echo "It will NOT:"
            echo "  - reboot the computer"
            echo "  - restart the display manager"
            echo "  - unload graphics drivers"
            echo "  - reset USB hardware"
            echo

            read -rp "Type I UNDERSTAND to continue: " ANSWER

            if [[ "$ANSWER" != "I UNDERSTAND" ]]; then

                echo
                echo "Nuclear reset cancelled."
                return 0

            fi


            echo
            echo "Authenticating..."
            echo

            sudo -k

            if ! sudo -v; then

                echo
                echo "Authentication failed."
                echo "Nuclear reset cancelled."

                return 1

            fi


            echo
            echo "Authorization accepted."
            echo "Beginning soft reset..."
            echo


            echo "[1/4] Network..."

            if systemctl list-unit-files 2>/dev/null \
                | grep -q '^NetworkManager.service'; then

                sudo systemctl restart NetworkManager

                echo "      NetworkManager restarted."

            else

                echo "      NetworkManager not found."

            fi


            echo "[2/4] DNS..."

            if systemctl list-unit-files 2>/dev/null \
                | grep -q '^systemd-resolved.service'; then

                sudo systemctl restart systemd-resolved

                echo "      systemd-resolved restarted."

            else

                echo "      systemd-resolved not found."

            fi


            if command -v resolvectl >/dev/null 2>&1; then

                resolvectl flush-caches 2>/dev/null || true

                echo "      DNS cache flushed."

            fi


            echo "[3/4] Audio..."

            if systemctl --user list-unit-files 2>/dev/null \
                | grep -q '^pipewire.service'; then

                systemctl --user restart pipewire \
                    2>/dev/null || true

                echo "      PipeWire restarted."

            else

                echo "      PipeWire not found."

            fi


            if systemctl --user list-unit-files 2>/dev/null \
                | grep -q '^pipewire-pulse.service'; then

                systemctl --user restart pipewire-pulse \
                    2>/dev/null || true

            fi


            echo "[4/4] Bluetooth..."

            if systemctl list-unit-files 2>/dev/null \
                | grep -q '^bluetooth.service'; then

                sudo systemctl restart bluetooth \
                    2>/dev/null || true

                echo "      Bluetooth restarted."

            else

                echo "      Bluetooth service not found."

            fi


            echo
            echo "Clearing failed service markers..."

            sudo systemctl reset-failed


            echo
            echo "================================================"
            echo "        SOFT NUCLEAR RESET COMPLETE"
            echo "================================================"
            echo
            echo "No reboot was performed."
            echo
            echo "Network:    refreshed"
            echo "DNS:        refreshed"
            echo "Audio:      refreshed"
            echo "Bluetooth:  refreshed"
            echo "Failures:   cleared"
            echo

            ;;


        *)

            echo
            echo "Available resets:"
            echo
            echo "  reset wifi"
            echo "  reset network"
            echo "  reset audio"
            echo "  reset bluetooth"
            echo "  reset usb"
            echo "  reset display"
            echo "  reset failed"
            echo "  reset all"
            echo

            ;;

    esac
}
