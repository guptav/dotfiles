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

# FZF Settings
export FZF_DEFAULT_OPTS='--layout=reverse --border --layout=reverse --info=inline --preview "~/.vim/bundle/fzf.vim/bin/preview.sh {}"'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fzf_configure_bindings --directory=\cp

# Install plugins
function _install
    fisher install PatrickF1/fzf.fish
end
