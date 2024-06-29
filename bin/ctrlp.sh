#!/bin/bash
cat ~/commands.yaml | yq '.commands | to_entries[] | .value[]["type"]=.key | .value' |
      yq '.[] | (.type + "/" + (.cmd |map(tostring())|join("; ")) + .help)' |
      fzf --no-preview | tr -d '\n' | cut -d# -f1 | cut -d/ -f2 | tr -d '\n' |
      xargs -0 -I{} tmux send-keys '{}'
