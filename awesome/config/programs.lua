local programs = {}

-- This is used later as the default terminal and editor to run.
programs.terminal = "alacritty -e tmux"
programs.editor = "vim"
programs.editor_cmd = "gvim"
programs.lock_cmd = 'slock'
programs.screenshot = "scrot -e 'mv $f ~/screenshots/ 2>/dev/null'"
programs.audio_volume_up = "pulseaudio-ctl up"
programs.audio_volume_down = "pulseaudio-ctl down"

return programs
