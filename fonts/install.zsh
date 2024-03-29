0=${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}

function install_font() {
    local font="$1"

    case "$(uname -s)" in
        Darwin)
            local font_dir="${HOME}/Library/Fonts"
            ;;
        *)
            local font_dir="${HOME}/.local/share/fonts"
            ;;
  esac

    local base_path="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v2.3.3/patched-fonts"
    local source="${base_path}/${font// /%20}"
    local target="${font_dir}/${font}"

    http_get "${source}" ${target}
}

install_font "Meslo/M/Regular/complete/Meslo LG M Regular Nerd Font Complete.ttf"
install_font "Meslo/M/Italic/complete/Meslo LG M Italic Nerd Font Complete.ttf"
install_font "Meslo/M/Bold/complete/Meslo LG M Bold Nerd Font Complete.ttf"
install_font "Meslo/M/Bold-Italic/complete/Meslo LG M Bold Italic Nerd Font Complete.ttf"

install_font "SourceCodePro/Regular/complete/Sauce Code Pro Nerd Font Complete.ttf"
install_font "SourceCodePro/Bold/complete/Sauce Code Pro Bold Nerd Font Complete.ttf"
install_font "SourceCodePro/Italic/complete/Sauce Code Pro Italic Nerd Font Complete.ttf"
