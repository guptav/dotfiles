#/usr/local/bin/fish

# Fish config
# Author: Vaibhav Gupta
#
. ~/.envrc
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# TMUX Helper
function ide
    tmux split-window -v -l 20%
    tmux select-pane -t 1
    tmux split-window -h -l 30%
    tmux send-keys -t 2 'tty-clock -s' C-m
    tmux split-window -v -l 70%
    tmux select-pane -t 1
end

function install_tools
  brew install tty-clock neofetch lolcat
end

# Default settings
export EDITOR=vim

# Default alias
alias l="ls -l -snew -g"
alias lt="ls -l -snew -g"
alias g="git"
alias t="task"
alias rm="rm -i"
alias b=~/bin/b
alias pp='cd ~/Personal/repo/notes'
alias ai='tmux display-popup -E -h "80%" -w "80%" "tmux a -t ai "'

set tmux_sess (tmux display-message -p '#S');
alias tkill="tmux list-sessions | awk '{print \$1}'| sed -e 's/$tmux_sess//g' | fzf --no-preview  | xargs -I{} tmux kill-session -t '{}'"

# FZF Settings
export FZF_DEFAULT_OPTS='--layout=reverse --border --layout=reverse --info=inline --preview "~/.vim/bundle/fzf.vim/bin/preview.sh {}" --header "CTRL-O (open in browser) ╱ ALT-E (examine in editor)/ CTRL-/ (Change preview window)"  --bind "ctrl-/:change-preview-window(down,70%|hidden|)" --bind 'ctrl-w:toggle-preview-wrap'  --bind "ctrl-o:execute-silent:git op {}" --bind "alt-e:execute:vim {} > /dev/tty" --bind "ctrl-b:preview-half-page-up,ctrl-f:preview-half-page-down"'
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
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# git-fuzzy
export GIT_FUZZY_STATUS_ADD_KEY='Ctrl-g'
export GIT_FUZZY_STATUS_RESET_KEY='Ctrl-f'
export GF_DIFF_FILE_PREVIEW_DEFAULTS="--color"
set -x PATH "/opt/homebrew/Cellar/vim/9.1.0350/bin:/Users/vaibhavgupta/Personal/repo/git-fuzzy/bin:$PATH"
set -x PATH "/Users/vaibhavgupta/Library/Python/3.9/bin/:$PATH"

# Keyboard Bindings
bind \cs beginning-of-line
bind \co "git cb"
bind \ct "git fuzzy status"
bind \cg "git gl"

# open in browser
function op
    cat ~/commands.yaml | yq '.bookmarks.[] | .[]' | fzf --preview '~/bin/b.sh {}' | xargs open
end

# Jira token and aliases
# JIRA_API_TOKEN and JIRA_AUTH_TYPE="bearer" are set in .envrc
alias my-open-issue="jira issue list -a$(jira me) -sopen"
# Jira completion
jira completion fish | source
