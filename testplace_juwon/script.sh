#!/usr/bin/env bash

dir="$(realpath "${1:-$(pwd)}")"
echo "Opening $dir in VSCode..."
exec mac code --folder-uri "vscode-remote://ssh-remote+$(whoami)@$(hostname)@orb$dir"