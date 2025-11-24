#/usr/local/bin/fish

# Fish config
# Author: Vaibhav Gupta
#
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# {{{ Default Settings

# Load environment variables
. ~/.envrc

# TMUX Settings
tmux set mouse off
set tmux_sess (tmux display-message -p '#S');

# FZF Settings
export FZF_DEFAULT_OPTS='--layout=reverse --border --layout=reverse --info=inline --preview "/opt/homebrew/bin/bat {}" --header "CTRL-O (open in browser) ╱ ALT-E (examine in editor)/ CTRL-/ (Change preview window)"  --bind "ctrl-/:change-preview-window(down,70%|hidden|)" --bind 'ctrl-w:toggle-preview-wrap'  --bind "ctrl-o:execute-silent:git op {}" --bind "alt-e:execute:vim {} > /dev/tty" --bind "ctrl-b:preview-half-page-up,ctrl-f:preview-half-page-down"'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fzf_configure_bindings --directory=\cp

# }}} Default Settings

# {{{ Default settings and aliases
export EDITOR=vim
export REPO_PATH="$HOME/repo"
alias pp='cd $REPO_PATH/notes'

# Default alias
alias l="ls -l -snew -g"
alias lt="ls -l -snew -g"
alias g="git"
alias t="todoist"
alias rm="rm -i"
alias vim="nvim"
alias b=~/bin/b
alias ai='tmux display-popup -E -h "80%" -w "80%" "tmux a -t ai "'
alias tkill="tmux list-sessions | awk '{print \$1}'| sed -e 's/$tmux_sess//g' | fzf --no-preview  | xargs -I{} tmux kill-session -t '{}'"

export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# git-fuzzy
export GIT_FUZZY_STATUS_ADD_KEY='Ctrl-g'
export GIT_FUZZY_STATUS_RESET_KEY='Ctrl-f'
export GF_DIFF_FILE_PREVIEW_DEFAULTS="--color"

# }}} Default settings and aliases

# {{{ Path Settings
set PATH $PATH ~/bin
set -x PATH "/opt/homebrew/opt/ruby/bin:$PATH"
set -x PATH "$HOME/github/everything.fzf:$PATH"
set -x PATH "$HOME/github/git-fuzzy/bin:$PATH"
source "$HOME/.cargo/env.fish"

# }}} Path Settings

# {{{ Keyboard Bindings
bind \cs beginning-of-line
bind \co "git cb"
# TODO: This is not working as expected
bind \ct "git fuzzy status"
bind \cg "git gl"

# }}} Keyboard Bindings

# {{{ Functions

# TMUX Helper Functions
function ide
    tmux split-window -v -l 20%
    tmux select-pane -t 1
    tmux split-window -h -l 30%
    tmux send-keys -t 2 'tty-clock -s' C-m
    tmux split-window -v -l 70%
    tmux select-pane -t 1
end

# Install useful tools
function install_tools
  brew install tty-clock neofetch lolcat
end

# Ripgrep with FZF
# Usage: rgg <search-term>
# TODO: Fix this function
function rgg
  command rg -n $argv | fzf
end

# Install plugins
function _install
    fisher install jorgebucaran/fisher
    fisher install PatrickF1/fzf.fish
    fisher install jethrokuan/z
    fisher install simnalamburt/shellder
    fisher install mordax7/fish-fzf-todoist
end

# Start the theme
function theme
  starship init fish | source
end

# open in browser
function op
    cat ~/commands.yaml | yq '.bookmarks.[] | .[]' | fzf --preview '~/bin/b.sh {}' | xargs open
end

# Check git status in all repos in current directory
function git-check
    for dir in *;
        if test -d "$dir/.git"
            cd $dir
            if test (git status --porcelain -uno | wc -l) -gt 0
                # In different color
                echo (set_color red) "==> Uncommitted changes in $dir" (set_color normal)
                git st
            end
            echo ""
            cd ..
        end
    end
end

# }}} Functions

# Jira token and aliases
# JIRA_API_TOKEN and JIRA_AUTH_TYPE="bearer" are set in .envrc
# alias my-open-issue="jira issue list -a$(jira me) -sopen"
# Jira completion
# jira completion fish | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vaibhavgupta/Desktop/google-cloud-sdk/path.fish.inc' ]; . '/Users/vaibhavgupta/Desktop/google-cloud-sdk/path.fish.inc'; end

