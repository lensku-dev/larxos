#!/usr/bin/env bash
clear

CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "               ██████████████▀"
echo "              ██████████████▀"
echo "             ██████████████▀"
echo "            ██████████████▀"
echo "           ██████████████▀"
echo "          ██████████████▀"
echo "         ██████████████▀"
echo "        ██████████████▀"
echo "       ██████████████▀"
echo "      ██████████████▀"
echo "     ██████████████▀"
echo "    ██████████████▀"
echo "   ██████████████▀"
echo "  ██████████████▀"
echo " ██████████████▀"
echo "████████████████████████████████████████▄"
echo "█████████████████████████████████████████▀"
echo " ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
echo -e "${NC}"
echo "====================================="
echo "   Welcome to the LarxOS Installer   "
echo "====================================="
echo ""
echo "Select your default Wayland Compositor:"
echo "1) Hyprland (Dynamic Tiling)"
echo "2) Niri (Scroll-based Tiling)"
echo ""

while true; do
    read -p "Enter choice [1-2]: " choice
    case $choice in
        1)
            echo "Selected: Hyprland"
            CHOSEN_WM="hyprland"
            break
            ;;
        2)
            echo "Selected: Niri"
            CHOSEN_WM="niri"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1 or 2."
            ;;
    esac
done

echo ""
echo "Proceeding with user setup..."
