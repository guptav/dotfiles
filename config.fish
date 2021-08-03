#/usr/local/bin/fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function ide
    tmux split-window -v -p 10
    tmux select-pane -t 1
    tmux split-window -h -p 30
    tmux select-pane -t 1
end
