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
export EDITOR=nvim
export REPO_PATH="$HOME/repo"
alias pp='cd $REPO_PATH/notes'

# Default alias
alias l="ls -l -snew -g"
alias lt="ls -l -snew -g"
alias g="git"
alias t="todoist"
alias rm="rm -i"
alias vim="$EDITOR"
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
set -x PATH "$HOME/.cargo/bin:$PATH"
if test -f $HOME/.env.fish
    source $HOME/.env.fish
end
if test -f $HOME/.tcargo/env.fish
    source $HOME/.tcargo/env.fish
end
if test -f $HOME/.cargo/env.fish
    source $HOME/.cargo/env.fish
end

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

# Run a Cursor agent prompt headless
# Usage: ca "PROMPT"             stream the answer text
#        ca --raw "PROMPT"       raw stream-json lines
#        ca --model gpt-5 "..."  any other flag is passed to cursor-agent
#        echo "PROMPT" | ca      prompt from stdin
#        ca --log [N|all]        list the last N audit entries (default 20)
set -q CA_AUDIT_LOG; or set -gx CA_AUDIT_LOG "$HOME/.ca-audit.log"
function ca
    if test "$argv[1]" = --log
        if not test -f "$CA_AUDIT_LOG"
            echo "ca: no audit log at $CA_AUDIT_LOG" >&2
            return 1
        end
        set -l n 20
        test -n "$argv[2]"; and set n $argv[2]
        if test "$n" = all
            cat "$CA_AUDIT_LOG"
        else
            tail -n $n "$CA_AUDIT_LOG"
        end
        return 0
    end
    set -l raw 0
    set -l args
    for arg in $argv
        if test "$arg" = --raw
            set raw 1
        else
            set -a args $arg
        end
    end
    if test (count $args) -eq 0; and not isatty stdin
        # read -z instead of (cat): command substitutions do not inherit the pipe
        read -z -l piped
        set args (string trim -- $piped)
    end
    if test (count $args) -eq 0
        echo "usage: ca [--raw] [cursor-agent flags] \"PROMPT\" | ca --log [N|all]" >&2
        return 1
    end
    set -l started (date +%Y-%m-%dT%H:%M:%S%z)
    set -l rc 0
    if test $raw -eq 1
        cursor-agent --print --stream-partial-output --output-format stream-json $args
        set rc $status
    else
        # deltas carry timestamp_ms; the final assistant event repeats the whole text
        cursor-agent --print --stream-partial-output --output-format stream-json $args |
            jq -j --unbuffered 'select(.type == "assistant" and has("timestamp_ms")) | .message.content[]?.text // empty'
        set rc $pipestatus[1]
        echo
    end
    # string escape keeps multi-line prompts on a single log line
    printf '%s\t%s\texit=%s\tca %s\n' $started $PWD $rc \
        (string join ' ' -- (string escape -- $args)) >>"$CA_AUDIT_LOG"
    return $rc
end

# }}} Functions

# {{{ Jira Settings
export JIRA_USER=(jira me)
export JIRA_PAGE=50
# Jira token and aliases
# JIRA_API_TOKEN and JIRA_AUTH_TYPE="bearer" are set in .envrc
alias my-open-issue="jira issue list -a$(jira me) -sopen"
alias ji="fzf --preview-window down \
                --header-lines=1 \
                --preview-label 'Enter = View in browser,  Alt-Enter = Edit in terminal, Alt-j = Move, Alt-c = Create' \
                --color 'label:bold:red' \
                --preview 'jira issue view {1}' \
                --bind 'alt-enter:execute(jira issue edit {1})' \
                --bind 'enter:execute(jira open {1})' \
                --bind 'alt-c:execute(jira issue create)' \
                --bind 'alt-j:execute(jira issue move {1})'"
alias my-sprint="jira sprint list --current -a$(jira me) -RUnresolved --order-by priority --reverse --plain  --columns id,summary,status,type,reporter,priority,labels | ji"
alias my-report="jira issue list -r(jira me) --paginate $JIRA_PAGE -RUnresolved --plain  --columns id,summary,status,type,assignee,priority,labels | ji"
alias my-history="jira issue list -a$(jira me) --paginate $JIRA_PAGE -RUnresolved   --plain --order-by updated --columns id,summary,status,type,reporter,priority,labels | ji"

# Jira completion
jira completion fish | source
# }}} Jira Settings

# source "$HOME/.cargo/env.fish"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vaibhavgupta/Desktop/google-cloud-sdk/path.fish.inc' ]; . '/Users/vaibhavgupta/Desktop/google-cloud-sdk/path.fish.inc'; end

# Include the path: /Library/Frameworks/Python.framework/Versions/3.12/bin
