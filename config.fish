#/usr/local/bin/fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# TMUX Helper
function ide
    tmux split-window -v -p 20
    tmux select-pane -t 1
    tmux split-window -h -p 30
    tmux select-pane -t 1
end

# Default settings
export EDITOR=vim

# Default alias
alias l="exa -l -snew -g --icons  --git-ignore --ignore-glob .git"
alias lt="exa -l -snew -g --icons  --git-ignore --ignore-glob .git"
alias g="git"
alias t="task"
alias rm="rm -i"
alias b=~/bin/b
alias aa="cd (git root)"

set tmux_sess (tmux display-message -p '#S');
alias tkill="tmux list-sessions | awk '{print \$1}'| sed -e 's/$tmux_sess//g' | fzf --no-preview  | xargs -I{} tmux kill-session -t '{}'"

# FZF Settings
export FZF_DEFAULT_OPTS='--layout=reverse --border --layout=reverse --info=inline --preview "~/.vim/bundle/fzf.vim/bin/preview.sh {}" --header "CTRL-O (open in browser) ╱ ALT-E (examine in editor)/ CTRL-/ (Change preview window)"  --bind "ctrl-/:change-preview-window(down,70%|hidden|)" --bind 'ctrl-w:toggle-preview-wrap'  --bind "ctrl-o:execute-silent:git op {}" --bind "alt-e:execute:vim {} > /dev/tty"'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fzf_configure_bindings --directory=\cp

function rg
  command rg -n $argv | fzf
end

# Install plugins
function _install
    fisher install jorgebucaran/fisher                                                                                                 │
    fisher install PatrickF1/fzf.fish
    fisher install jethrokuan/z                                                                                                        │
    fisher install simnalamburt/shellder                                                                                               │
end

# Start the theme
function theme
  starship init fish | source
end

set PATH $PATH ~/bin
# export DOCKER_HOST='unix:///Users/vaibhavgupta/.local/share/containers/podman/machine/podman-machine-default/podman.sock'

# git-fuzzy
export GIT_FUZZY_STATUS_ADD_KEY='Ctrl-g'
export GIT_FUZZY_STATUS_RESET_KEY='Ctrl-f'
export GF_DIFF_FILE_PREVIEW_DEFAULTS="--color"
set -x PATH "/Users/vaibhavgupta/repo/git-fuzzy/bin:$PATH"

# Keyboard Bindings
bind \cs beginning-of-line
bind \co "git cb"
bind \ct "git fuzzy status"
bind \cg "git gl"
