#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;94m'
RED='\033[0;31m'
GRAY='\033[0;37m'
BOLD='\033[1m'
NC='\033[0m'

print_step() { echo -e "${BLUE}[*]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${GRAY}[i]${NC} $1"; }

REPO_RAW="https://raw.githubusercontent.com/vmkspv/zenith-theme-gtk/main"
DEFAULT_THEME_PATH="${HOME}/.local/share/gtksourceview-5/styles"
DEFAULT_PTYXIS_PATH="${HOME}/.local/share/org.gnome.Ptyxis/palettes"

create_directory() {
    local dir=$1

    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_info "Created directory: ${dir}"
    fi
}

download_file() {
    local url=$1
    local output=$2

    if curl -fsSL "$url" -o "$output" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

install_theme() {
    print_step "Installing the Zenith theme..."
    create_directory "$DEFAULT_THEME_PATH"

    if download_file "$REPO_RAW/gtksourceview-5/styles/zenith.xml" "$DEFAULT_THEME_PATH/zenith.xml"; then
        print_success "The Zenith theme installed successfully"
    else
        print_error "Failed to install the Zenith theme"
        return 1
    fi
}

install_ptyxis() {
    print_step "Installing the color palette for Ptyxis..."
    create_directory "$DEFAULT_PTYXIS_PATH"

    if download_file "$REPO_RAW/org.gnome.Ptyxis/palettes/zenith.palette" "$DEFAULT_PTYXIS_PATH/zenith.palette"; then
        print_success "The color palette for Ptyxis installed successfully"
    else
        print_error "Failed to install the color palette for Ptyxis"
        return 1
    fi
}

show_help() {
    echo "usage: $0 [OPTIONS]"
    echo
    echo "options:"
    echo "  --theme           install the Zenith theme only"
    echo "  --ptyxis          install the color palette for Ptyxis only"
    echo "  --full            install the theme and Ptyxis color palette"
    exit 0
}

echo -e "${BOLD}Welcome to the Zenith theme installer!${NC}"
echo "This script will help you install the Zenith theme for GtkSourceView"
echo

INSTALL_THEME=false
INSTALL_PTYXIS=false

if [ $# -eq 0 ]; then
    show_help
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --theme)
            INSTALL_THEME=true
            shift
            ;;
        --ptyxis)
            INSTALL_PTYXIS=true
            shift
            ;;
        --full)
            INSTALL_THEME=true
            INSTALL_PTYXIS=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ "$INSTALL_THEME" = true ]; then
    install_theme
fi

if [ "$INSTALL_PTYXIS" = true ]; then
    install_ptyxis
fi

echo
print_info "Done! Ensure that all steps are successful"
