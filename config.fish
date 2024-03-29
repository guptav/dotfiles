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

set tmux_sess (tmux display-message -p '#S');
alias tkill="tmux list-sessions | awk '{print \$1}'| sed -e 's/$tmux_sess//g' | fzf --no-preview  | xargs -I{} tmux kill-session -t '{}'"

# FZF Settings
export FZF_DEFAULT_OPTS='--layout=reverse --border --layout=reverse --info=inline --preview "~/.vim/bundle/fzf.vim/bin/preview.sh {}"'
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
