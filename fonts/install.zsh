0=${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}

readonly JETBRAINS_MONO_VERSION="v2.304"
readonly NERD_FONTS_VERSION="v3.4.0"

function install_font() {
    local source="$1"
    local filename="$2"
    local font_dir

    case "$(uname -s)" in
        Darwin)
            font_dir="${HOME}/Library/Fonts"
            ;;
        *)
            font_dir="${HOME}/.local/share/fonts"
            ;;
    esac

    local target="${font_dir}/${filename}"

    http_get "${source}" "${target}"
}

function refresh_font_cache() {
    if [ "$(uname -s)" = "Darwin" ]; then
        return 0
    fi

    if ! command -v fc-cache >/dev/null 2>&1; then
        echo -e "\tSkipping font cache refresh (fc-cache not found)"
        return 0
    fi

    echo -e "\tRefreshing font cache"
    fc-cache -f "${HOME}/.local/share/fonts"
}

install_font "https://raw.githubusercontent.com/JetBrains/JetBrainsMono/${JETBRAINS_MONO_VERSION}/fonts/ttf/JetBrainsMono-Regular.ttf" "JetBrainsMono-Regular.ttf" || return 1
install_font "https://raw.githubusercontent.com/JetBrains/JetBrainsMono/${JETBRAINS_MONO_VERSION}/fonts/ttf/JetBrainsMono-Italic.ttf" "JetBrainsMono-Italic.ttf" || return 1
install_font "https://raw.githubusercontent.com/JetBrains/JetBrainsMono/${JETBRAINS_MONO_VERSION}/fonts/ttf/JetBrainsMono-Bold.ttf" "JetBrainsMono-Bold.ttf" || return 1
install_font "https://raw.githubusercontent.com/JetBrains/JetBrainsMono/${JETBRAINS_MONO_VERSION}/fonts/ttf/JetBrainsMono-BoldItalic.ttf" "JetBrainsMono-BoldItalic.ttf" || return 1

install_font "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/${NERD_FONTS_VERSION}/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf" "SymbolsNerdFontMono-Regular.ttf" || return 1

refresh_font_cache || return 1
