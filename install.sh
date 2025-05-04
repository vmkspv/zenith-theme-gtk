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
DEFAULT_LANGS_PATH="${HOME}/.local/share/gtksourceview-5/language-specs"

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

install_languages() {
    print_step "Installing language definitions..."
    create_directory "$DEFAULT_LANGS_PATH"

    local success=true
    local lang_specs=("nginx.lang" "cisco.lang" "fstab.lang")

    for lang in "${lang_specs[@]}"; do
        if download_file "$REPO_RAW/gtksourceview-5/language-specs/$lang" "$DEFAULT_LANGS_PATH/$lang"; then
            print_success "Installed: $lang"
        else
            print_error "Failed to install: $lang"
            success=false
        fi
    done

    if [ "$success" = true ]; then
        print_success "Language definitions installed successfully"
    else
        print_error "Failed to install language definitions"
        return 1
    fi
}

show_help() {
    echo "usage: $0 [OPTIONS]"
    echo
    echo "options:"
    echo "  --theme           install the Zenith theme only"
    echo "  --langs           install language definitions only"
    echo "  --full            install both theme and language definitions"
    exit 0
}

echo -e "${BOLD}Welcome to the Zenith theme installer!${NC}"
echo "This script will help you install the Zenith theme for GtkSourceView"
echo

INSTALL_THEME=false
INSTALL_LANGS=false

if [ $# -eq 0 ]; then
    show_help
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --theme)
            INSTALL_THEME=true
            shift
            ;;
        --langs)
            INSTALL_LANGS=true
            shift
            ;;
        --full)
            INSTALL_THEME=true
            INSTALL_LANGS=true
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

if [ "$INSTALL_LANGS" = true ]; then
    install_languages
fi

echo
print_info "Done! Ensure that all steps are successful"